// ---------------------------------------------------------------------------
// End-to-end testbench for the central-controller-element HLS kernel.
//
// The kernel is used unmodified. The testbench only drives it from files:
//
//   tb/work/adc.txt  --(pass 1)--> kernel --> tb/work/windowed{0,1}.txt
//   tb/work/windowed{0,1}.txt --(tb/run_aie.sh N)--> AIE x86sim (N chirps)
//   AIE output --> tb/work/aie{0,1}.txt --(pass 2)--> kernel
//   kernel --> tb/work/mm.txt (DRAM words)
//
// The chirp count is derived from the ADC file: every chirp is 2048 complex
// samples (1024 beats of two samples).  The kernel is called once with
// num_chirps = N, so its internal chirp loop, the chirp * 2048 DRAM stride and
// the ap_uint<8> chirp field are all exercised.
//
// Pass 1 runs with an all-zero mask so aie_consume_one() reads only the 64+64
// mask beats of each chirp and keeps no blocks; pass 2 runs with the real AIE
// output and is the one whose DRAM writes are checked.
//
// Finally tb/golden.py --check --chirps N compares every stage against a
// bit-exact model.
// ---------------------------------------------------------------------------

#include "../src/main.h"

#include <cstdio>
#include <cstdlib>
#include <string>
#include <vector>

#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>

namespace {

struct Iq {
    int r;
    int i;
};

const unsigned kSamplesPerChirp = 2048;
const unsigned kBeatsPerChirp = kSamplesPerChirp / 2;  // 1024
const unsigned kBlocks = 128;
const unsigned kWordsPerChirp = kBlocks * 16;          // 2048
const unsigned kMaxChirps = 256;                       // mm depth / 2048

std::string find_component_dir() {
    char buf[4096];
    if (!getcwd(buf, sizeof buf)) return std::string();
    std::string dir(buf);
    for (int i = 0; i < 12; ++i) {
        struct stat st;
        if (stat((dir + "/hls_config.cfg").c_str(), &st) == 0) return dir;
        std::string::size_type slash = dir.find_last_of('/');
        if (slash == std::string::npos || slash == 0) break;
        dir.erase(slash);
    }
    return std::string();
}

bool read_iq(const std::string &path, std::vector<Iq> &out) {
    FILE *f = std::fopen(path.c_str(), "r");
    if (!f) return false;
    out.clear();
    int r = 0, i = 0;
    while (std::fscanf(f, "%d %d", &r, &i) == 2) out.push_back(Iq{r, i});
    std::fclose(f);
    return true;
}

bool write_iq(const std::string &path, const std::vector<Iq> &v) {
    FILE *f = std::fopen(path.c_str(), "w");
    if (!f) return false;
    for (std::size_t k = 0; k < v.size(); ++k)
        std::fprintf(f, "%d %d\n", v[k].r, v[k].i);
    std::fclose(f);
    return true;
}

ap_uint<32> pack_iq(int r, int i) {
    ap_uint<32> w;
    w.range(15, 0) = (ap_uint<16>)(ap_int<16>)r;
    w.range(31, 16) = (ap_uint<16>)(ap_int<16>)i;
    return w;
}

Iq unpack_iq(ap_uint<32> w) {
    return Iq{(int)(ap_int<16>)w.range(15, 0), (int)(ap_int<16>)w.range(31, 16)};
}

// One kernel invocation. adc holds chirps * 2048 complex samples; aie0/aie1
// are the 32-bit words the AIE would deliver on in_aie00 / in_aie01, already
// concatenated in chirp order.
void run_pass(unsigned chirps, const std::vector<Iq> &adc,
              const std::vector<ap_uint<32>> &aie0,
              const std::vector<ap_uint<32>> &aie1, std::vector<Iq> &out0,
              std::vector<Iq> &out1, ap_uint<32> *mm) {
    hls::stream<pkt_adc> in_adc0;
    hls::stream<pkt> out00, out01, in_aie00, in_aie01;

    const unsigned beats = chirps * kBeatsPerChirp;
    for (unsigned b = 0; b < beats; ++b) {
        pkt_adc p;
        p.data.range(31, 0) = pack_iq(adc[2 * b].r, adc[2 * b].i);
        p.data.range(63, 32) = pack_iq(adc[2 * b + 1].r, adc[2 * b + 1].i);
        p.last = ((b + 1) % kBeatsPerChirp == 0) ? 1 : 0;
        in_adc0.write(p);
    }
    for (std::size_t k = 0; k < aie0.size(); ++k) {
        pkt p;
        p.data = aie0[k];
        p.last = 0;
        in_aie00.write(p);
    }
    for (std::size_t k = 0; k < aie1.size(); ++k) {
        pkt p;
        p.data = aie1[k];
        p.last = 0;
        in_aie01.write(p);
    }

    kernel(mm, in_adc0, out00, out01, in_aie00, in_aie01, chirps);

    out0.clear();
    out1.clear();
    while (!out00.empty()) out0.push_back(unpack_iq(out00.read().data));
    while (!out01.empty()) out1.push_back(unpack_iq(out01.read().data));
}

std::vector<ap_uint<32>> load_words(const std::string &path) {
    std::vector<Iq> v;
    std::vector<ap_uint<32>> w;
    if (!read_iq(path, v)) return w;
    for (std::size_t k = 0; k < v.size(); ++k) w.push_back(pack_iq(v[k].r, v[k].i));
    return w;
}

}  // namespace

int main() {
    const std::string comp = find_component_dir();
    if (comp.empty()) {
        std::printf("TB: cannot locate hls_config.cfg walking up from the cwd\n");
        return 1;
    }
    const std::string work = comp + "/tb/work";
    mkdir(work.c_str(), 0777);

    std::vector<Iq> adc;
    if (!read_iq(work + "/adc.txt", adc)) {
        std::printf("TB: missing %s/adc.txt -- run tb/run_test.sh\n", work.c_str());
        return 1;
    }
    if (adc.empty() || adc.size() % kSamplesPerChirp != 0) {
        std::printf("TB: ADC file has %zu samples, expected a multiple of %u\n",
                    adc.size(), kSamplesPerChirp);
        return 1;
    }
    const unsigned chirps = (unsigned)(adc.size() / kSamplesPerChirp);
    if (chirps > kMaxChirps) {
        std::printf("TB: %u chirps exceeds the %u-chirp mm buffer\n", chirps,
                    kMaxChirps);
        return 1;
    }
    const unsigned windowed_beats = chirps * kBeatsPerChirp;
    const unsigned mm_words = chirps * kWordsPerChirp;

    static ap_uint<32> mm[kMaxChirps * kWordsPerChirp];
    std::vector<Iq> w0, w1;

    // ---- pass 1: ADC -> Hamming window -> two output streams --------------
    const std::vector<ap_uint<32>> zero(chirps * 64, ap_uint<32>(0));
    run_pass(chirps, adc, zero, zero, w0, w1, mm);

    if (w0.size() != windowed_beats || w1.size() != windowed_beats) {
        std::printf("TB: pass 1 produced %zu / %zu windowed samples, expected %u\n",
                    w0.size(), w1.size(), windowed_beats);
        return 1;
    }
    if (!write_iq(work + "/windowed0.txt", w0) ||
        !write_iq(work + "/windowed1.txt", w1)) {
        std::printf("TB: cannot write windowed output\n");
        return 1;
    }
    std::printf("TB: windowed %u chirps (%u samples) -> tb/work/windowed{0,1}.txt\n",
                chirps, chirps * kSamplesPerChirp);

    // ---- hand the windowed frames to the AIE, chirp by chirp ---------------
    const std::string aie_cmd =
        "bash " + comp + "/tb/run_aie.sh " + std::to_string(chirps);
    std::printf("TB: running AIE (%s)\n", aie_cmd.c_str());
    std::fflush(stdout);
    int aie_rc = std::system(aie_cmd.c_str());
    if (aie_rc != 0) {
        std::printf("TB: AIE step failed (status %d)\n", aie_rc);
        return 1;
    }

    std::vector<ap_uint<32>> aie0 = load_words(work + "/aie0.txt");
    std::vector<ap_uint<32>> aie1 = load_words(work + "/aie1.txt");
    if (aie0.size() < chirps * 64 || aie1.size() < chirps * 64) {
        std::printf("TB: AIE output too short (%zu / %zu words, need >= %u each)\n",
                    aie0.size(), aie1.size(), chirps * 64);
        return 1;
    }
    std::printf("TB: AIE returned %zu / %zu words\n", aie0.size(), aie1.size());

    // ---- pass 2: AIE output -> kernel -> DRAM -----------------------------
    run_pass(chirps, adc, aie0, aie1, w0, w1, mm);

    FILE *f = std::fopen((work + "/mm.txt").c_str(), "w");
    if (!f) {
        std::printf("TB: cannot write mm.txt\n");
        return 1;
    }
    for (unsigned k = 0; k < mm_words; ++k) {
        Iq v = unpack_iq(mm[k]);
        std::fprintf(f, "%d %d\n", v.r, v.i);
    }
    std::fclose(f);

    std::printf("TB: captured %u DRAM words\n", mm_words);

    // ---- compare every stage against the model ----------------------------
    const std::string check = "python3 " + comp + "/tb/golden.py --check --chirps " +
                              std::to_string(chirps);
    std::printf("TB: %s\n\n", check.c_str());
    std::fflush(stdout);
    int rc = std::system(check.c_str());
    if (rc == -1) return 1;
    return WIFEXITED(rc) ? WEXITSTATUS(rc) : 1;
}
