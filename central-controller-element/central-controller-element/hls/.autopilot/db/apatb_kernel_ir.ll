; ModuleID = '/home/light/MajorProject/serious-aie-fft/central-controller-element/central-controller-element/hls/.autopilot/db/a.g.ld.5.gdce.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-i128:128-i256:256-i512:512-i1024:1024-i2048:2048-i4096:4096-n8:16:32:64-S128-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "fpga64-xilinx-none"

%"struct.ap_uint<32>" = type { %"struct.ap_int_base<32, false>" }
%"struct.ap_int_base<32, false>" = type { %"struct.ssdm_int<32, false>" }
%"struct.ssdm_int<32, false>" = type { i32 }
%"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>" = type { %"struct.hls::axis<ap_uint<64>>" }
%"struct.hls::axis<ap_uint<64>>" = type { %"struct.ap_uint<64>", %"struct.ap_uint<8>", %"struct.ap_uint<8>", %"struct.hls::axis_disabled_signal", %"struct.ap_uint<1>", %"struct.hls::axis_disabled_signal", %"struct.hls::axis_disabled_signal" }
%"struct.ap_uint<64>" = type { %"struct.ap_int_base<64, false>" }
%"struct.ap_int_base<64, false>" = type { %"struct.ssdm_int<64, false>" }
%"struct.ssdm_int<64, false>" = type { i64 }
%"struct.ap_uint<8>" = type { %"struct.ap_int_base<8, false>" }
%"struct.ap_int_base<8, false>" = type { %"struct.hls::axis_disabled_signal" }
%"struct.ap_uint<1>" = type { %"struct.ap_int_base<1, false>" }
%"struct.ap_int_base<1, false>" = type { %"struct.ssdm_int<1, false>" }
%"struct.ssdm_int<1, false>" = type { i1 }
%"struct.hls::axis_disabled_signal" = type { i8 }
%"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>" = type { %"struct.hls::axis<ap_uint<32>>" }
%"struct.hls::axis<ap_uint<32>>" = type { %"struct.ap_uint<32>", %"struct.ap_uint<4>", %"struct.ap_uint<4>", %"struct.hls::axis_disabled_signal", %"struct.ap_uint<1>", %"struct.hls::axis_disabled_signal", %"struct.hls::axis_disabled_signal" }
%"struct.ap_uint<4>" = type { %"struct.ap_int_base<4, false>" }
%"struct.ap_int_base<4, false>" = type { %"struct.ssdm_int<4, false>" }
%"struct.ssdm_int<4, false>" = type { i4 }

; Function Attrs: noinline
define void @apatb_kernel_ir(%"struct.ap_uint<32>"* noalias nonnull "maxi" %mm, %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* noalias nonnull align 8 dereferenceable(16) %in_adc0, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* noalias nonnull align 4 dereferenceable(12) %out_r_00, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* noalias nonnull align 4 dereferenceable(12) %out_r_01, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* noalias nonnull align 4 dereferenceable(12) %in_r_00, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* noalias nonnull align 4 dereferenceable(12) %in_r_01, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* noalias nonnull align 4 dereferenceable(12) %out_d_02, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* noalias nonnull align 4 dereferenceable(12) %out_d_03, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* noalias nonnull align 4 dereferenceable(12) %in_d_02, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* noalias nonnull align 4 dereferenceable(12) %in_d_03, i32 %num_chirps) local_unnamed_addr #0 {
entry:
  %0 = bitcast %"struct.ap_uint<32>"* %mm to [201326592 x %"struct.ap_uint<32>"]*
  %1 = call i8* @malloc(i64 805306368)
  %mm_copy = bitcast i8* %1 to [201326592 x i32]*
  %in_adc0_copy.data = alloca i64, align 512
  %in_adc0_copy.keep = alloca i8, align 512
  %in_adc0_copy.strb = alloca i8, align 512
  %in_adc0_copy.last = alloca i1, align 512
  %out_r_00_copy.data = alloca i32, align 512
  %out_r_00_copy.keep = alloca i4, align 512
  %out_r_00_copy.strb = alloca i4, align 512
  %out_r_00_copy.last = alloca i1, align 512
  %out_r_01_copy.data = alloca i32, align 512
  %out_r_01_copy.keep = alloca i4, align 512
  %out_r_01_copy.strb = alloca i4, align 512
  %out_r_01_copy.last = alloca i1, align 512
  %in_r_00_copy.data = alloca i32, align 512
  %in_r_00_copy.keep = alloca i4, align 512
  %in_r_00_copy.strb = alloca i4, align 512
  %in_r_00_copy.last = alloca i1, align 512
  %in_r_01_copy.data = alloca i32, align 512
  %in_r_01_copy.keep = alloca i4, align 512
  %in_r_01_copy.strb = alloca i4, align 512
  %in_r_01_copy.last = alloca i1, align 512
  %out_d_02_copy.data = alloca i32, align 512
  %out_d_02_copy.keep = alloca i4, align 512
  %out_d_02_copy.strb = alloca i4, align 512
  %out_d_02_copy.last = alloca i1, align 512
  %out_d_03_copy.data = alloca i32, align 512
  %out_d_03_copy.keep = alloca i4, align 512
  %out_d_03_copy.strb = alloca i4, align 512
  %out_d_03_copy.last = alloca i1, align 512
  %in_d_02_copy.data = alloca i32, align 512
  %in_d_02_copy.keep = alloca i4, align 512
  %in_d_02_copy.strb = alloca i4, align 512
  %in_d_02_copy.last = alloca i1, align 512
  %in_d_03_copy.data = alloca i32, align 512
  %in_d_03_copy.keep = alloca i4, align 512
  %in_d_03_copy.strb = alloca i4, align 512
  %in_d_03_copy.last = alloca i1, align 512
  call fastcc void @copy_in([201326592 x %"struct.ap_uint<32>"]* nonnull %0, [201326592 x i32]* %mm_copy, %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* nonnull %in_adc0, i64* nonnull align 512 %in_adc0_copy.data, i8* nonnull align 512 %in_adc0_copy.keep, i8* nonnull align 512 %in_adc0_copy.strb, i1* nonnull align 512 %in_adc0_copy.last, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* nonnull %out_r_00, i32* nonnull align 512 %out_r_00_copy.data, i4* nonnull align 512 %out_r_00_copy.keep, i4* nonnull align 512 %out_r_00_copy.strb, i1* nonnull align 512 %out_r_00_copy.last, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* nonnull %out_r_01, i32* nonnull align 512 %out_r_01_copy.data, i4* nonnull align 512 %out_r_01_copy.keep, i4* nonnull align 512 %out_r_01_copy.strb, i1* nonnull align 512 %out_r_01_copy.last, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* nonnull %in_r_00, i32* nonnull align 512 %in_r_00_copy.data, i4* nonnull align 512 %in_r_00_copy.keep, i4* nonnull align 512 %in_r_00_copy.strb, i1* nonnull align 512 %in_r_00_copy.last, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* nonnull %in_r_01, i32* nonnull align 512 %in_r_01_copy.data, i4* nonnull align 512 %in_r_01_copy.keep, i4* nonnull align 512 %in_r_01_copy.strb, i1* nonnull align 512 %in_r_01_copy.last, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* nonnull %out_d_02, i32* nonnull align 512 %out_d_02_copy.data, i4* nonnull align 512 %out_d_02_copy.keep, i4* nonnull align 512 %out_d_02_copy.strb, i1* nonnull align 512 %out_d_02_copy.last, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* nonnull %out_d_03, i32* nonnull align 512 %out_d_03_copy.data, i4* nonnull align 512 %out_d_03_copy.keep, i4* nonnull align 512 %out_d_03_copy.strb, i1* nonnull align 512 %out_d_03_copy.last, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* nonnull %in_d_02, i32* nonnull align 512 %in_d_02_copy.data, i4* nonnull align 512 %in_d_02_copy.keep, i4* nonnull align 512 %in_d_02_copy.strb, i1* nonnull align 512 %in_d_02_copy.last, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* nonnull %in_d_03, i32* nonnull align 512 %in_d_03_copy.data, i4* nonnull align 512 %in_d_03_copy.keep, i4* nonnull align 512 %in_d_03_copy.strb, i1* nonnull align 512 %in_d_03_copy.last)
  call void @apatb_kernel_hw([201326592 x i32]* %mm_copy, i64* %in_adc0_copy.data, i8* %in_adc0_copy.keep, i8* %in_adc0_copy.strb, i1* %in_adc0_copy.last, i32* %out_r_00_copy.data, i4* %out_r_00_copy.keep, i4* %out_r_00_copy.strb, i1* %out_r_00_copy.last, i32* %out_r_01_copy.data, i4* %out_r_01_copy.keep, i4* %out_r_01_copy.strb, i1* %out_r_01_copy.last, i32* %in_r_00_copy.data, i4* %in_r_00_copy.keep, i4* %in_r_00_copy.strb, i1* %in_r_00_copy.last, i32* %in_r_01_copy.data, i4* %in_r_01_copy.keep, i4* %in_r_01_copy.strb, i1* %in_r_01_copy.last, i32* %out_d_02_copy.data, i4* %out_d_02_copy.keep, i4* %out_d_02_copy.strb, i1* %out_d_02_copy.last, i32* %out_d_03_copy.data, i4* %out_d_03_copy.keep, i4* %out_d_03_copy.strb, i1* %out_d_03_copy.last, i32* %in_d_02_copy.data, i4* %in_d_02_copy.keep, i4* %in_d_02_copy.strb, i1* %in_d_02_copy.last, i32* %in_d_03_copy.data, i4* %in_d_03_copy.keep, i4* %in_d_03_copy.strb, i1* %in_d_03_copy.last, i32 %num_chirps)
  call void @copy_back([201326592 x %"struct.ap_uint<32>"]* %0, [201326592 x i32]* %mm_copy, %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* %in_adc0, i64* %in_adc0_copy.data, i8* %in_adc0_copy.keep, i8* %in_adc0_copy.strb, i1* %in_adc0_copy.last, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %out_r_00, i32* %out_r_00_copy.data, i4* %out_r_00_copy.keep, i4* %out_r_00_copy.strb, i1* %out_r_00_copy.last, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %out_r_01, i32* %out_r_01_copy.data, i4* %out_r_01_copy.keep, i4* %out_r_01_copy.strb, i1* %out_r_01_copy.last, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %in_r_00, i32* %in_r_00_copy.data, i4* %in_r_00_copy.keep, i4* %in_r_00_copy.strb, i1* %in_r_00_copy.last, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %in_r_01, i32* %in_r_01_copy.data, i4* %in_r_01_copy.keep, i4* %in_r_01_copy.strb, i1* %in_r_01_copy.last, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %out_d_02, i32* %out_d_02_copy.data, i4* %out_d_02_copy.keep, i4* %out_d_02_copy.strb, i1* %out_d_02_copy.last, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %out_d_03, i32* %out_d_03_copy.data, i4* %out_d_03_copy.keep, i4* %out_d_03_copy.strb, i1* %out_d_03_copy.last, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %in_d_02, i32* %in_d_02_copy.data, i4* %in_d_02_copy.keep, i4* %in_d_02_copy.strb, i1* %in_d_02_copy.last, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %in_d_03, i32* %in_d_03_copy.data, i4* %in_d_03_copy.keep, i4* %in_d_03_copy.strb, i1* %in_d_03_copy.last)
  call void @free(i8* %1)
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @copy_in([201326592 x %"struct.ap_uint<32>"]* readonly, [201326592 x i32]*, %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"*, i64* align 512 "unpacked"="3.0" %_V_data_V, i8* align 512 "unpacked"="3.1" %_V_keep_V, i8* align 512 "unpacked"="3.2" %_V_strb_V, i1* align 512 "unpacked"="3.3" %_V_last_V, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*, i32* align 512 "unpacked"="5.0" %_V_data_V1, i4* align 512 "unpacked"="5.1" %_V_keep_V2, i4* align 512 "unpacked"="5.2" %_V_strb_V3, i1* align 512 "unpacked"="5.3" %_V_last_V4, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*, i32* align 512 "unpacked"="10.0" %_V_data_V15, i4* align 512 "unpacked"="10.1" %_V_keep_V26, i4* align 512 "unpacked"="10.2" %_V_strb_V37, i1* align 512 "unpacked"="10.3" %_V_last_V48, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*, i32* align 512 "unpacked"="9.0" %_V_data_V159, i4* align 512 "unpacked"="9.1" %_V_keep_V2610, i4* align 512 "unpacked"="9.2" %_V_strb_V3711, i1* align 512 "unpacked"="9.3" %_V_last_V4812, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*, i32* align 512 "unpacked"="11.0" %_V_data_V15913, i4* align 512 "unpacked"="11.1" %_V_keep_V261014, i4* align 512 "unpacked"="11.2" %_V_strb_V371115, i1* align 512 "unpacked"="11.3" %_V_last_V481216, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*, i32* align 512 "unpacked"="19.0" %_V_data_V2, i4* align 512 "unpacked"="19.1" %_V_keep_V3, i4* align 512 "unpacked"="19.2" %_V_strb_V4, i1* align 512 "unpacked"="19.3" %_V_last_V5, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*, i32* align 512 "unpacked"="21.0" %_V_data_V26, i4* align 512 "unpacked"="21.1" %_V_keep_V37, i4* align 512 "unpacked"="21.2" %_V_strb_V48, i1* align 512 "unpacked"="21.3" %_V_last_V59, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*, i32* align 512 "unpacked"="17.0" %_V_data_V1591317, i4* align 512 "unpacked"="17.1" %_V_keep_V26101418, i4* align 512 "unpacked"="17.2" %_V_strb_V37111519, i1* align 512 "unpacked"="17.3" %_V_last_V48121620, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*, i32* align 512 "unpacked"="19.0" %_V_data_V159131721, i4* align 512 "unpacked"="19.1" %_V_keep_V2610141822, i4* align 512 "unpacked"="19.2" %_V_strb_V3711151923, i1* align 512 "unpacked"="19.3" %_V_last_V4812162024) unnamed_addr #1 {
entry:
  call fastcc void @"onebyonecpy_hls.p0a201326592struct.ap_uint<32>"([201326592 x i32]* %1, [201326592 x %"struct.ap_uint<32>"]* %0)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>.272"(i64* align 512 %_V_data_V, i8* align 512 %_V_keep_V, i8* align 512 %_V_strb_V, i1* align 512 %_V_last_V, %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* %2)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"(i32* align 512 %_V_data_V1, i4* align 512 %_V_keep_V2, i4* align 512 %_V_strb_V3, i1* align 512 %_V_last_V4, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %3)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"(i32* align 512 %_V_data_V15, i4* align 512 %_V_keep_V26, i4* align 512 %_V_strb_V37, i1* align 512 %_V_last_V48, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %4)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"(i32* align 512 %_V_data_V159, i4* align 512 %_V_keep_V2610, i4* align 512 %_V_strb_V3711, i1* align 512 %_V_last_V4812, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %5)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"(i32* align 512 %_V_data_V15913, i4* align 512 %_V_keep_V261014, i4* align 512 %_V_strb_V371115, i1* align 512 %_V_last_V481216, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %6)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"(i32* align 512 %_V_data_V2, i4* align 512 %_V_keep_V3, i4* align 512 %_V_strb_V4, i1* align 512 %_V_last_V5, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %7)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"(i32* align 512 %_V_data_V26, i4* align 512 %_V_keep_V37, i4* align 512 %_V_strb_V48, i1* align 512 %_V_last_V59, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %8)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"(i32* align 512 %_V_data_V1591317, i4* align 512 %_V_keep_V26101418, i4* align 512 %_V_strb_V37111519, i1* align 512 %_V_last_V48121620, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %9)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"(i32* align 512 %_V_data_V159131721, i4* align 512 %_V_keep_V2610141822, i4* align 512 %_V_strb_V3711151923, i1* align 512 %_V_last_V4812162024, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %10)
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @"onebyonecpy_hls.p0a201326592struct.ap_uint<32>"([201326592 x i32]* %dst, [201326592 x %"struct.ap_uint<32>"]* readonly %src) unnamed_addr #2 {
entry:
  %0 = icmp eq [201326592 x i32]* %dst, null
  %1 = icmp eq [201326592 x %"struct.ap_uint<32>"]* %src, null
  %2 = or i1 %0, %1
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a201326592struct.ap_uint<32>"([201326592 x i32]* nonnull %dst, [201326592 x %"struct.ap_uint<32>"]* nonnull %src, i64 201326592)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a201326592struct.ap_uint<32>"([201326592 x i32]* %dst, [201326592 x %"struct.ap_uint<32>"]* readonly %src, i64 %num) local_unnamed_addr #3 {
entry:
  %0 = icmp eq [201326592 x %"struct.ap_uint<32>"]* %src, null
  %1 = icmp eq [201326592 x i32]* %dst, null
  %2 = or i1 %1, %0
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond7 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond7, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %for.loop.lr.ph
  %for.loop.idx8 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %for.loop ]
  %src.addr.0.0.05 = getelementptr [201326592 x %"struct.ap_uint<32>"], [201326592 x %"struct.ap_uint<32>"]* %src, i64 0, i64 %for.loop.idx8, i32 0, i32 0, i32 0
  %3 = getelementptr [201326592 x i32], [201326592 x i32]* %dst, i64 0, i64 %for.loop.idx8
  %4 = load i32, i32* %src.addr.0.0.05, align 4
  store i32 %4, i32* %3, align 4
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx8, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %for.loop, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"(%"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* %dst, i64* align 512 "unpacked"="1.0" %src_V_data_V, i8* align 512 "unpacked"="1.1" %src_V_keep_V, i8* align 512 "unpacked"="1.2" %src_V_strb_V, i1* align 512 "unpacked"="1.3" %src_V_last_V) unnamed_addr #4 {
entry:
  %0 = icmp eq %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"(%"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* nonnull %dst, i64* align 512 %src_V_data_V, i8* align 512 %src_V_keep_V, i8* align 512 %src_V_strb_V, i1* align 512 %src_V_last_V)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"(%"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* nocapture, i64* nocapture align 512 "unpacked"="1.0" %_V_data_V, i8* nocapture align 512 "unpacked"="1.1" %_V_keep_V, i8* nocapture align 512 "unpacked"="1.2" %_V_strb_V, i1* nocapture align 512 "unpacked"="1.3" %_V_last_V) unnamed_addr #5 {
entry:
  %1 = alloca i1
  %2 = alloca i64
  %3 = alloca i8
  %4 = alloca i8
  %5 = alloca %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"
  br label %empty

empty:                                            ; preds = %push, %entry
  %6 = bitcast i64* %_V_data_V to i8*
  %7 = call i1 @fpga_fifo_not_empty_8(i8* %6)
  br i1 %7, label %push, label %ret

push:                                             ; preds = %empty
  %8 = bitcast i64* %2 to i8*
  %9 = bitcast i64* %_V_data_V to i8*
  call void @fpga_fifo_pop_8(i8* %8, i8* %9)
  %10 = load volatile i64, i64* %2
  call void @fpga_fifo_pop_1(i8* %4, i8* %_V_keep_V)
  %11 = load volatile i8, i8* %4
  call void @fpga_fifo_pop_1(i8* %3, i8* %_V_strb_V)
  %12 = load volatile i8, i8* %3
  %13 = bitcast i1* %1 to i8*
  %14 = bitcast i1* %_V_last_V to i8*
  call void @fpga_fifo_pop_1(i8* %13, i8* %14)
  %15 = bitcast i1* %1 to i8*
  %16 = load i8, i8* %15
  %17 = trunc i8 %16 to i1
  %.fca.0.0.0.0.0.insert = insertvalue %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>" undef, i64 %10, 0, 0, 0, 0, 0
  %.fca.0.1.0.0.0.insert = insertvalue %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>" %.fca.0.0.0.0.0.insert, i8 %11, 0, 1, 0, 0, 0
  %.fca.0.2.0.0.0.insert = insertvalue %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>" %.fca.0.1.0.0.0.insert, i8 %12, 0, 2, 0, 0, 0
  %.fca.0.4.0.0.0.insert = insertvalue %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>" %.fca.0.2.0.0.0.insert, i1 %17, 0, 4, 0, 0, 0
  store %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>" %.fca.0.4.0.0.0.insert, %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* %5
  %18 = bitcast %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* %5 to i8*
  %19 = bitcast %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* %0 to i8*
  call void @fpga_fifo_push_16(i8* %18, i8* %19)
  br label %empty, !llvm.loop !6

ret:                                              ; preds = %empty
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @copy_out([201326592 x %"struct.ap_uint<32>"]*, [201326592 x i32]* readonly, %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"*, i64* align 512 "unpacked"="3.0" %_V_data_V, i8* align 512 "unpacked"="3.1" %_V_keep_V, i8* align 512 "unpacked"="3.2" %_V_strb_V, i1* align 512 "unpacked"="3.3" %_V_last_V, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*, i32* align 512 "unpacked"="5.0" %_V_data_V1, i4* align 512 "unpacked"="5.1" %_V_keep_V2, i4* align 512 "unpacked"="5.2" %_V_strb_V3, i1* align 512 "unpacked"="5.3" %_V_last_V4, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*, i32* align 512 "unpacked"="10.0" %_V_data_V15, i4* align 512 "unpacked"="10.1" %_V_keep_V26, i4* align 512 "unpacked"="10.2" %_V_strb_V37, i1* align 512 "unpacked"="10.3" %_V_last_V48, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*, i32* align 512 "unpacked"="9.0" %_V_data_V159, i4* align 512 "unpacked"="9.1" %_V_keep_V2610, i4* align 512 "unpacked"="9.2" %_V_strb_V3711, i1* align 512 "unpacked"="9.3" %_V_last_V4812, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*, i32* align 512 "unpacked"="11.0" %_V_data_V15913, i4* align 512 "unpacked"="11.1" %_V_keep_V261014, i4* align 512 "unpacked"="11.2" %_V_strb_V371115, i1* align 512 "unpacked"="11.3" %_V_last_V481216, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*, i32* align 512 "unpacked"="19.0" %_V_data_V2, i4* align 512 "unpacked"="19.1" %_V_keep_V3, i4* align 512 "unpacked"="19.2" %_V_strb_V4, i1* align 512 "unpacked"="19.3" %_V_last_V5, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*, i32* align 512 "unpacked"="21.0" %_V_data_V26, i4* align 512 "unpacked"="21.1" %_V_keep_V37, i4* align 512 "unpacked"="21.2" %_V_strb_V48, i1* align 512 "unpacked"="21.3" %_V_last_V59, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*, i32* align 512 "unpacked"="17.0" %_V_data_V1591317, i4* align 512 "unpacked"="17.1" %_V_keep_V26101418, i4* align 512 "unpacked"="17.2" %_V_strb_V37111519, i1* align 512 "unpacked"="17.3" %_V_last_V48121620, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*, i32* align 512 "unpacked"="19.0" %_V_data_V159131721, i4* align 512 "unpacked"="19.1" %_V_keep_V2610141822, i4* align 512 "unpacked"="19.2" %_V_strb_V3711151923, i1* align 512 "unpacked"="19.3" %_V_last_V4812162024) unnamed_addr #6 {
entry:
  call fastcc void @"onebyonecpy_hls.p0a201326592struct.ap_uint<32>.213"([201326592 x %"struct.ap_uint<32>"]* %0, [201326592 x i32]* %1)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"(%"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* %2, i64* align 512 %_V_data_V, i8* align 512 %_V_keep_V, i8* align 512 %_V_strb_V, i1* align 512 %_V_last_V)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>.230"(%"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %3, i32* align 512 %_V_data_V1, i4* align 512 %_V_keep_V2, i4* align 512 %_V_strb_V3, i1* align 512 %_V_last_V4)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>.230"(%"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %4, i32* align 512 %_V_data_V15, i4* align 512 %_V_keep_V26, i4* align 512 %_V_strb_V37, i1* align 512 %_V_last_V48)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>.230"(%"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %5, i32* align 512 %_V_data_V159, i4* align 512 %_V_keep_V2610, i4* align 512 %_V_strb_V3711, i1* align 512 %_V_last_V4812)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>.230"(%"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %6, i32* align 512 %_V_data_V15913, i4* align 512 %_V_keep_V261014, i4* align 512 %_V_strb_V371115, i1* align 512 %_V_last_V481216)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>.230"(%"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %7, i32* align 512 %_V_data_V2, i4* align 512 %_V_keep_V3, i4* align 512 %_V_strb_V4, i1* align 512 %_V_last_V5)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>.230"(%"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %8, i32* align 512 %_V_data_V26, i4* align 512 %_V_keep_V37, i4* align 512 %_V_strb_V48, i1* align 512 %_V_last_V59)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>.230"(%"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %9, i32* align 512 %_V_data_V1591317, i4* align 512 %_V_keep_V26101418, i4* align 512 %_V_strb_V37111519, i1* align 512 %_V_last_V48121620)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>.230"(%"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %10, i32* align 512 %_V_data_V159131721, i4* align 512 %_V_keep_V2610141822, i4* align 512 %_V_strb_V3711151923, i1* align 512 %_V_last_V4812162024)
  ret void
}

declare i8* @malloc(i64) local_unnamed_addr

declare void @free(i8*) local_unnamed_addr

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @"onebyonecpy_hls.p0a201326592struct.ap_uint<32>.213"([201326592 x %"struct.ap_uint<32>"]* %dst, [201326592 x i32]* readonly %src) unnamed_addr #2 {
entry:
  %0 = icmp eq [201326592 x %"struct.ap_uint<32>"]* %dst, null
  %1 = icmp eq [201326592 x i32]* %src, null
  %2 = or i1 %0, %1
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a201326592struct.ap_uint<32>.216"([201326592 x %"struct.ap_uint<32>"]* nonnull %dst, [201326592 x i32]* nonnull %src, i64 201326592)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a201326592struct.ap_uint<32>.216"([201326592 x %"struct.ap_uint<32>"]* %dst, [201326592 x i32]* readonly %src, i64 %num) local_unnamed_addr #3 {
entry:
  %0 = icmp eq [201326592 x i32]* %src, null
  %1 = icmp eq [201326592 x %"struct.ap_uint<32>"]* %dst, null
  %2 = or i1 %1, %0
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond7 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond7, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %for.loop.lr.ph
  %for.loop.idx8 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %for.loop ]
  %3 = getelementptr [201326592 x i32], [201326592 x i32]* %src, i64 0, i64 %for.loop.idx8
  %dst.addr.0.0.06 = getelementptr [201326592 x %"struct.ap_uint<32>"], [201326592 x %"struct.ap_uint<32>"]* %dst, i64 0, i64 %for.loop.idx8, i32 0, i32 0, i32 0
  %4 = load i32, i32* %3, align 4
  store i32 %4, i32* %dst.addr.0.0.06, align 4
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx8, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %for.loop, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"(i32* align 512 "unpacked"="0.0" %dst_V_data_V, i4* align 512 "unpacked"="0.1" %dst_V_keep_V, i4* align 512 "unpacked"="0.2" %dst_V_strb_V, i1* align 512 "unpacked"="0.3" %dst_V_last_V, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %src) unnamed_addr #4 {
entry:
  %0 = icmp eq %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>.226"(i32* align 512 %dst_V_data_V, i4* align 512 %dst_V_keep_V, i4* align 512 %dst_V_strb_V, i1* align 512 %dst_V_last_V, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* nonnull %src)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>.226"(i32* nocapture align 512 "unpacked"="0.0" %_V_data_V, i4* nocapture align 512 "unpacked"="0.1" %_V_keep_V, i4* nocapture align 512 "unpacked"="0.2" %_V_strb_V, i1* nocapture align 512 "unpacked"="0.3" %_V_last_V, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* nocapture) unnamed_addr #5 {
entry:
  %1 = alloca %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"
  %2 = alloca i32
  %3 = alloca i4
  %4 = alloca i4
  %5 = alloca i1
  br label %empty

empty:                                            ; preds = %push, %entry
  %6 = bitcast %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %0 to i8*
  %7 = call i1 @fpga_fifo_not_empty_12(i8* %6)
  br i1 %7, label %push, label %ret

push:                                             ; preds = %empty
  %8 = bitcast %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %1 to i8*
  %9 = bitcast %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %0 to i8*
  call void @fpga_fifo_pop_12(i8* %8, i8* %9)
  %10 = load volatile %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>", %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %1
  %.fca.0.0.0.0.0.extract = extractvalue %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>" %10, 0, 0, 0, 0, 0
  %.fca.0.1.0.0.0.extract = extractvalue %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>" %10, 0, 1, 0, 0, 0
  %.fca.0.2.0.0.0.extract = extractvalue %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>" %10, 0, 2, 0, 0, 0
  %.fca.0.4.0.0.0.extract = extractvalue %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>" %10, 0, 4, 0, 0, 0
  store i32 %.fca.0.0.0.0.0.extract, i32* %2
  %11 = bitcast i32* %2 to i8*
  %12 = bitcast i32* %_V_data_V to i8*
  call void @fpga_fifo_push_4(i8* %11, i8* %12)
  store i4 %.fca.0.1.0.0.0.extract, i4* %4
  %13 = bitcast i4* %4 to i8*
  %14 = bitcast i4* %_V_keep_V to i8*
  call void @fpga_fifo_push_1(i8* %13, i8* %14)
  store i4 %.fca.0.2.0.0.0.extract, i4* %3
  %15 = bitcast i4* %3 to i8*
  %16 = bitcast i4* %_V_strb_V to i8*
  call void @fpga_fifo_push_1(i8* %15, i8* %16)
  store i1 %.fca.0.4.0.0.0.extract, i1* %5
  %17 = bitcast i1* %5 to i8*
  %18 = bitcast i1* %_V_last_V to i8*
  call void @fpga_fifo_push_1(i8* %17, i8* %18)
  br label %empty, !llvm.loop !8

ret:                                              ; preds = %empty
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>.230"(%"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %dst, i32* align 512 "unpacked"="1.0" %src_V_data_V, i4* align 512 "unpacked"="1.1" %src_V_keep_V, i4* align 512 "unpacked"="1.2" %src_V_strb_V, i1* align 512 "unpacked"="1.3" %src_V_last_V) unnamed_addr #4 {
entry:
  %0 = icmp eq %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>.233"(%"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* nonnull %dst, i32* align 512 %src_V_data_V, i4* align 512 %src_V_keep_V, i4* align 512 %src_V_strb_V, i1* align 512 %src_V_last_V)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>.233"(%"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* nocapture, i32* nocapture align 512 "unpacked"="1.0" %_V_data_V, i4* nocapture align 512 "unpacked"="1.1" %_V_keep_V, i4* nocapture align 512 "unpacked"="1.2" %_V_strb_V, i1* nocapture align 512 "unpacked"="1.3" %_V_last_V) unnamed_addr #5 {
entry:
  %1 = alloca i32
  %2 = alloca i4
  %3 = alloca i4
  %4 = alloca i1
  %5 = alloca %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"
  br label %empty

empty:                                            ; preds = %push, %entry
  %6 = bitcast i32* %_V_data_V to i8*
  %7 = call i1 @fpga_fifo_not_empty_4(i8* %6)
  br i1 %7, label %push, label %ret

push:                                             ; preds = %empty
  %8 = bitcast i32* %1 to i8*
  %9 = bitcast i32* %_V_data_V to i8*
  call void @fpga_fifo_pop_4(i8* %8, i8* %9)
  %10 = load volatile i32, i32* %1
  %11 = bitcast i4* %3 to i8*
  %12 = bitcast i4* %_V_keep_V to i8*
  call void @fpga_fifo_pop_1(i8* %11, i8* %12)
  %13 = bitcast i4* %3 to i8*
  %14 = load i8, i8* %13
  %15 = trunc i8 %14 to i4
  %16 = bitcast i4* %2 to i8*
  %17 = bitcast i4* %_V_strb_V to i8*
  call void @fpga_fifo_pop_1(i8* %16, i8* %17)
  %18 = bitcast i4* %2 to i8*
  %19 = load i8, i8* %18
  %20 = trunc i8 %19 to i4
  %21 = bitcast i1* %4 to i8*
  %22 = bitcast i1* %_V_last_V to i8*
  call void @fpga_fifo_pop_1(i8* %21, i8* %22)
  %23 = bitcast i1* %4 to i8*
  %24 = load i8, i8* %23
  %25 = trunc i8 %24 to i1
  %.fca.0.0.0.0.0.insert = insertvalue %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>" undef, i32 %10, 0, 0, 0, 0, 0
  %.fca.0.1.0.0.0.insert = insertvalue %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>" %.fca.0.0.0.0.0.insert, i4 %15, 0, 1, 0, 0, 0
  %.fca.0.2.0.0.0.insert = insertvalue %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>" %.fca.0.1.0.0.0.insert, i4 %20, 0, 2, 0, 0, 0
  %.fca.0.4.0.0.0.insert = insertvalue %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>" %.fca.0.2.0.0.0.insert, i1 %25, 0, 4, 0, 0, 0
  store %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>" %.fca.0.4.0.0.0.insert, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %5
  %26 = bitcast %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %5 to i8*
  %27 = bitcast %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %0 to i8*
  call void @fpga_fifo_push_12(i8* %26, i8* %27)
  br label %empty, !llvm.loop !8

ret:                                              ; preds = %empty
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>.272"(i64* align 512 "unpacked"="0.0" %dst_V_data_V, i8* align 512 "unpacked"="0.1" %dst_V_keep_V, i8* align 512 "unpacked"="0.2" %dst_V_strb_V, i1* align 512 "unpacked"="0.3" %dst_V_last_V, %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* %src) unnamed_addr #4 {
entry:
  %0 = icmp eq %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>.275"(i64* align 512 %dst_V_data_V, i8* align 512 %dst_V_keep_V, i8* align 512 %dst_V_strb_V, i1* align 512 %dst_V_last_V, %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* nonnull %src)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>.275"(i64* nocapture align 512 "unpacked"="0.0" %_V_data_V, i8* nocapture align 512 "unpacked"="0.1" %_V_keep_V, i8* nocapture align 512 "unpacked"="0.2" %_V_strb_V, i1* nocapture align 512 "unpacked"="0.3" %_V_last_V, %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* nocapture) unnamed_addr #5 {
entry:
  %1 = alloca %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"
  %2 = alloca i1
  %3 = alloca i64
  %4 = alloca i8
  %5 = alloca i8
  br label %empty

empty:                                            ; preds = %push, %entry
  %6 = bitcast %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* %0 to i8*
  %7 = call i1 @fpga_fifo_not_empty_16(i8* %6)
  br i1 %7, label %push, label %ret

push:                                             ; preds = %empty
  %8 = bitcast %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* %1 to i8*
  %9 = bitcast %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* %0 to i8*
  call void @fpga_fifo_pop_16(i8* %8, i8* %9)
  %10 = load volatile %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>", %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* %1
  %.fca.0.0.0.0.0.extract = extractvalue %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>" %10, 0, 0, 0, 0, 0
  %.fca.0.1.0.0.0.extract = extractvalue %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>" %10, 0, 1, 0, 0, 0
  %.fca.0.2.0.0.0.extract = extractvalue %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>" %10, 0, 2, 0, 0, 0
  %.fca.0.4.0.0.0.extract = extractvalue %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>" %10, 0, 4, 0, 0, 0
  store i64 %.fca.0.0.0.0.0.extract, i64* %3
  %11 = bitcast i64* %3 to i8*
  %12 = bitcast i64* %_V_data_V to i8*
  call void @fpga_fifo_push_8(i8* %11, i8* %12)
  store i8 %.fca.0.1.0.0.0.extract, i8* %5
  call void @fpga_fifo_push_1(i8* %5, i8* %_V_keep_V)
  store i8 %.fca.0.2.0.0.0.extract, i8* %4
  call void @fpga_fifo_push_1(i8* %4, i8* %_V_strb_V)
  store i1 %.fca.0.4.0.0.0.extract, i1* %2
  %13 = bitcast i1* %2 to i8*
  %14 = bitcast i1* %_V_last_V to i8*
  call void @fpga_fifo_push_1(i8* %13, i8* %14)
  br label %empty, !llvm.loop !6

ret:                                              ; preds = %empty
  ret void
}

declare void @apatb_kernel_hw([201326592 x i32]* %mm, i64* %in_adc0_V_data_V, i8* %in_adc0_V_keep_V, i8* %in_adc0_V_strb_V, i1* %in_adc0_V_last_V, i32* %out_r_00_V_data_V, i4* %out_r_00_V_keep_V, i4* %out_r_00_V_strb_V, i1* %out_r_00_V_last_V, i32* %out_r_01_V_data_V, i4* %out_r_01_V_keep_V, i4* %out_r_01_V_strb_V, i1* %out_r_01_V_last_V, i32* %in_r_00_V_data_V, i4* %in_r_00_V_keep_V, i4* %in_r_00_V_strb_V, i1* %in_r_00_V_last_V, i32* %in_r_01_V_data_V, i4* %in_r_01_V_keep_V, i4* %in_r_01_V_strb_V, i1* %in_r_01_V_last_V, i32* %out_d_02_V_data_V, i4* %out_d_02_V_keep_V, i4* %out_d_02_V_strb_V, i1* %out_d_02_V_last_V, i32* %out_d_03_V_data_V, i4* %out_d_03_V_keep_V, i4* %out_d_03_V_strb_V, i1* %out_d_03_V_last_V, i32* %in_d_02_V_data_V, i4* %in_d_02_V_keep_V, i4* %in_d_02_V_strb_V, i1* %in_d_02_V_last_V, i32* %in_d_03_V_data_V, i4* %in_d_03_V_keep_V, i4* %in_d_03_V_strb_V, i1* %in_d_03_V_last_V, i32 %num_chirps)

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @copy_back([201326592 x %"struct.ap_uint<32>"]*, [201326592 x i32]* readonly, %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"*, i64* align 512 "unpacked"="3.0" %_V_data_V, i8* align 512 "unpacked"="3.1" %_V_keep_V, i8* align 512 "unpacked"="3.2" %_V_strb_V, i1* align 512 "unpacked"="3.3" %_V_last_V, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*, i32* align 512 "unpacked"="5.0" %_V_data_V1, i4* align 512 "unpacked"="5.1" %_V_keep_V2, i4* align 512 "unpacked"="5.2" %_V_strb_V3, i1* align 512 "unpacked"="5.3" %_V_last_V4, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*, i32* align 512 "unpacked"="10.0" %_V_data_V15, i4* align 512 "unpacked"="10.1" %_V_keep_V26, i4* align 512 "unpacked"="10.2" %_V_strb_V37, i1* align 512 "unpacked"="10.3" %_V_last_V48, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*, i32* align 512 "unpacked"="9.0" %_V_data_V159, i4* align 512 "unpacked"="9.1" %_V_keep_V2610, i4* align 512 "unpacked"="9.2" %_V_strb_V3711, i1* align 512 "unpacked"="9.3" %_V_last_V4812, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*, i32* align 512 "unpacked"="11.0" %_V_data_V15913, i4* align 512 "unpacked"="11.1" %_V_keep_V261014, i4* align 512 "unpacked"="11.2" %_V_strb_V371115, i1* align 512 "unpacked"="11.3" %_V_last_V481216, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*, i32* align 512 "unpacked"="19.0" %_V_data_V2, i4* align 512 "unpacked"="19.1" %_V_keep_V3, i4* align 512 "unpacked"="19.2" %_V_strb_V4, i1* align 512 "unpacked"="19.3" %_V_last_V5, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*, i32* align 512 "unpacked"="21.0" %_V_data_V26, i4* align 512 "unpacked"="21.1" %_V_keep_V37, i4* align 512 "unpacked"="21.2" %_V_strb_V48, i1* align 512 "unpacked"="21.3" %_V_last_V59, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*, i32* align 512 "unpacked"="17.0" %_V_data_V1591317, i4* align 512 "unpacked"="17.1" %_V_keep_V26101418, i4* align 512 "unpacked"="17.2" %_V_strb_V37111519, i1* align 512 "unpacked"="17.3" %_V_last_V48121620, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*, i32* align 512 "unpacked"="19.0" %_V_data_V159131721, i4* align 512 "unpacked"="19.1" %_V_keep_V2610141822, i4* align 512 "unpacked"="19.2" %_V_strb_V3711151923, i1* align 512 "unpacked"="19.3" %_V_last_V4812162024) unnamed_addr #6 {
entry:
  call fastcc void @"onebyonecpy_hls.p0a201326592struct.ap_uint<32>.213"([201326592 x %"struct.ap_uint<32>"]* %0, [201326592 x i32]* %1)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"(%"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* %2, i64* align 512 %_V_data_V, i8* align 512 %_V_keep_V, i8* align 512 %_V_strb_V, i1* align 512 %_V_last_V)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>.230"(%"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %3, i32* align 512 %_V_data_V1, i4* align 512 %_V_keep_V2, i4* align 512 %_V_strb_V3, i1* align 512 %_V_last_V4)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>.230"(%"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %4, i32* align 512 %_V_data_V15, i4* align 512 %_V_keep_V26, i4* align 512 %_V_strb_V37, i1* align 512 %_V_last_V48)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>.230"(%"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %5, i32* align 512 %_V_data_V159, i4* align 512 %_V_keep_V2610, i4* align 512 %_V_strb_V3711, i1* align 512 %_V_last_V4812)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>.230"(%"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %6, i32* align 512 %_V_data_V15913, i4* align 512 %_V_keep_V261014, i4* align 512 %_V_strb_V371115, i1* align 512 %_V_last_V481216)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>.230"(%"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %7, i32* align 512 %_V_data_V2, i4* align 512 %_V_keep_V3, i4* align 512 %_V_strb_V4, i1* align 512 %_V_last_V5)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>.230"(%"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %8, i32* align 512 %_V_data_V26, i4* align 512 %_V_keep_V37, i4* align 512 %_V_strb_V48, i1* align 512 %_V_last_V59)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>.230"(%"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %9, i32* align 512 %_V_data_V1591317, i4* align 512 %_V_keep_V26101418, i4* align 512 %_V_strb_V37111519, i1* align 512 %_V_last_V48121620)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>.230"(%"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %10, i32* align 512 %_V_data_V159131721, i4* align 512 %_V_keep_V2610141822, i4* align 512 %_V_strb_V3711151923, i1* align 512 %_V_last_V4812162024)
  ret void
}

declare void @kernel_hw_stub(%"struct.ap_uint<32>"* noalias nonnull, %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* noalias nonnull, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* noalias nonnull, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* noalias nonnull, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* noalias nonnull, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* noalias nonnull, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* noalias nonnull, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* noalias nonnull, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* noalias nonnull, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* noalias nonnull, i32)

define void @kernel_hw_stub_wrapper([201326592 x i32]* %mm, i64* %in_adc0_V_data_V, i8* %in_adc0_V_keep_V, i8* %in_adc0_V_strb_V, i1* %in_adc0_V_last_V, i32* %out_r_00_V_data_V, i4* %out_r_00_V_keep_V, i4* %out_r_00_V_strb_V, i1* %out_r_00_V_last_V, i32* %out_r_01_V_data_V, i4* %out_r_01_V_keep_V, i4* %out_r_01_V_strb_V, i1* %out_r_01_V_last_V, i32* %in_r_00_V_data_V, i4* %in_r_00_V_keep_V, i4* %in_r_00_V_strb_V, i1* %in_r_00_V_last_V, i32* %in_r_01_V_data_V, i4* %in_r_01_V_keep_V, i4* %in_r_01_V_strb_V, i1* %in_r_01_V_last_V, i32* %out_d_02_V_data_V, i4* %out_d_02_V_keep_V, i4* %out_d_02_V_strb_V, i1* %out_d_02_V_last_V, i32* %out_d_03_V_data_V, i4* %out_d_03_V_keep_V, i4* %out_d_03_V_strb_V, i1* %out_d_03_V_last_V, i32* %in_d_02_V_data_V, i4* %in_d_02_V_keep_V, i4* %in_d_02_V_strb_V, i1* %in_d_02_V_last_V, i32* %in_d_03_V_data_V, i4* %in_d_03_V_keep_V, i4* %in_d_03_V_strb_V, i1* %in_d_03_V_last_V, i32 %num_chirps) #7 {
entry:
  %0 = call i8* @malloc(i64 805306368)
  %1 = bitcast i8* %0 to [201326592 x %"struct.ap_uint<32>"]*
  %2 = call i8* @malloc(i64 16)
  %3 = bitcast i8* %2 to %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"*
  %4 = call i8* @malloc(i64 12)
  %5 = bitcast i8* %4 to %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*
  %6 = call i8* @malloc(i64 12)
  %7 = bitcast i8* %6 to %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*
  %8 = call i8* @malloc(i64 12)
  %9 = bitcast i8* %8 to %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*
  %10 = call i8* @malloc(i64 12)
  %11 = bitcast i8* %10 to %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*
  %12 = call i8* @malloc(i64 12)
  %13 = bitcast i8* %12 to %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*
  %14 = call i8* @malloc(i64 12)
  %15 = bitcast i8* %14 to %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*
  %16 = call i8* @malloc(i64 12)
  %17 = bitcast i8* %16 to %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*
  %18 = call i8* @malloc(i64 12)
  %19 = bitcast i8* %18 to %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"*
  call void @copy_out([201326592 x %"struct.ap_uint<32>"]* %1, [201326592 x i32]* %mm, %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* %3, i64* %in_adc0_V_data_V, i8* %in_adc0_V_keep_V, i8* %in_adc0_V_strb_V, i1* %in_adc0_V_last_V, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %5, i32* %out_r_00_V_data_V, i4* %out_r_00_V_keep_V, i4* %out_r_00_V_strb_V, i1* %out_r_00_V_last_V, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %7, i32* %out_r_01_V_data_V, i4* %out_r_01_V_keep_V, i4* %out_r_01_V_strb_V, i1* %out_r_01_V_last_V, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %9, i32* %in_r_00_V_data_V, i4* %in_r_00_V_keep_V, i4* %in_r_00_V_strb_V, i1* %in_r_00_V_last_V, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %11, i32* %in_r_01_V_data_V, i4* %in_r_01_V_keep_V, i4* %in_r_01_V_strb_V, i1* %in_r_01_V_last_V, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %13, i32* %out_d_02_V_data_V, i4* %out_d_02_V_keep_V, i4* %out_d_02_V_strb_V, i1* %out_d_02_V_last_V, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %15, i32* %out_d_03_V_data_V, i4* %out_d_03_V_keep_V, i4* %out_d_03_V_strb_V, i1* %out_d_03_V_last_V, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %17, i32* %in_d_02_V_data_V, i4* %in_d_02_V_keep_V, i4* %in_d_02_V_strb_V, i1* %in_d_02_V_last_V, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %19, i32* %in_d_03_V_data_V, i4* %in_d_03_V_keep_V, i4* %in_d_03_V_strb_V, i1* %in_d_03_V_last_V)
  %20 = bitcast [201326592 x %"struct.ap_uint<32>"]* %1 to %"struct.ap_uint<32>"*
  call void @kernel_hw_stub(%"struct.ap_uint<32>"* %20, %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* %3, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %5, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %7, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %9, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %11, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %13, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %15, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %17, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %19, i32 %num_chirps)
  call void @copy_in([201326592 x %"struct.ap_uint<32>"]* %1, [201326592 x i32]* %mm, %"class.hls::stream<hls::axis<ap_uint<64>, 0, 0, 0, '8', false>, 0>"* %3, i64* %in_adc0_V_data_V, i8* %in_adc0_V_keep_V, i8* %in_adc0_V_strb_V, i1* %in_adc0_V_last_V, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %5, i32* %out_r_00_V_data_V, i4* %out_r_00_V_keep_V, i4* %out_r_00_V_strb_V, i1* %out_r_00_V_last_V, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %7, i32* %out_r_01_V_data_V, i4* %out_r_01_V_keep_V, i4* %out_r_01_V_strb_V, i1* %out_r_01_V_last_V, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %9, i32* %in_r_00_V_data_V, i4* %in_r_00_V_keep_V, i4* %in_r_00_V_strb_V, i1* %in_r_00_V_last_V, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %11, i32* %in_r_01_V_data_V, i4* %in_r_01_V_keep_V, i4* %in_r_01_V_strb_V, i1* %in_r_01_V_last_V, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %13, i32* %out_d_02_V_data_V, i4* %out_d_02_V_keep_V, i4* %out_d_02_V_strb_V, i1* %out_d_02_V_last_V, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %15, i32* %out_d_03_V_data_V, i4* %out_d_03_V_keep_V, i4* %out_d_03_V_strb_V, i1* %out_d_03_V_last_V, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %17, i32* %in_d_02_V_data_V, i4* %in_d_02_V_keep_V, i4* %in_d_02_V_strb_V, i1* %in_d_02_V_last_V, %"class.hls::stream<hls::axis<ap_uint<32>, 0, 0, 0, '8', false>, 0>"* %19, i32* %in_d_03_V_data_V, i4* %in_d_03_V_keep_V, i4* %in_d_03_V_strb_V, i1* %in_d_03_V_last_V)
  call void @free(i8* %0)
  call void @free(i8* %2)
  call void @free(i8* %4)
  call void @free(i8* %6)
  call void @free(i8* %8)
  call void @free(i8* %10)
  call void @free(i8* %12)
  call void @free(i8* %14)
  call void @free(i8* %16)
  call void @free(i8* %18)
  ret void
}

declare i1 @fpga_fifo_not_empty_16(i8*)

declare i1 @fpga_fifo_not_empty_12(i8*)

declare i1 @fpga_fifo_not_empty_4(i8*)

declare i1 @fpga_fifo_not_empty_8(i8*)

declare void @fpga_fifo_pop_16(i8*, i8*)

declare void @fpga_fifo_pop_12(i8*, i8*)

declare void @fpga_fifo_pop_4(i8*, i8*)

declare void @fpga_fifo_pop_1(i8*, i8*)

declare void @fpga_fifo_pop_8(i8*, i8*)

declare void @fpga_fifo_push_16(i8*, i8*)

declare void @fpga_fifo_push_12(i8*, i8*)

declare void @fpga_fifo_push_4(i8*, i8*)

declare void @fpga_fifo_push_1(i8*, i8*)

declare void @fpga_fifo_push_8(i8*, i8*)

attributes #0 = { noinline "fpga.wrapper.func"="wrapper" }
attributes #1 = { argmemonly noinline willreturn "fpga.wrapper.func"="copyin" }
attributes #2 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="onebyonecpy_hls" }
attributes #3 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="arraycpy_hls" }
attributes #4 = { argmemonly noinline willreturn "fpga.wrapper.func"="onebyonecpy_hls" }
attributes #5 = { argmemonly noinline willreturn "fpga.wrapper.func"="streamcpy_hls" }
attributes #6 = { argmemonly noinline willreturn "fpga.wrapper.func"="copyout" }
attributes #7 = { "fpga.wrapper.func"="stub" }

!llvm.dbg.cu = !{}
!llvm.ident = !{!0, !0, !0, !0, !0, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1}
!llvm.module.flags = !{!2, !3, !4}
!blackbox_cfg = !{!5}

!0 = !{!"AMD/Xilinx clang version 16.0.6"}
!1 = !{!"clang version 7.0.0 "}
!2 = !{i32 2, !"Dwarf Version", i32 4}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.rotate.disable"}
!8 = distinct !{!8, !7}
