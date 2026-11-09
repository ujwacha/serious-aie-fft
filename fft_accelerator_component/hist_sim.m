function hist_sim
% HIST_SIM  Linear block-mean histogram, median noise estimate (MATLAB only).
%
% Per frame:
%   x      = sum of close-frequency tones + complex noise
%   P      = |FFT(x .* hamming)|^2
%   bmean  = sum of 16 consecutive P / 16              (128 values)
%   hist   = 64 linear bins; span from a coarse median pass, then a fine pass
%   med    = 50th percentile of the fine histogram
%   nf     = med * 16/gammaincinv(0.5,16)               (median -> mean)
%   thr    = nf * 10^(thr_db/10)
%   mask   = P > thr
%
% Scenes:
%   sparse : 8 isolated/close tones
%   dense  : 8 sparse + 400 tones packed into ~650..1250 with a Gaussian
%            amplitude envelope (one dense image-like hump).  Hamming is
%            applied before the FFT.
%
% Panel 4 sweeps the number of dense tones.
%
% Run: hist_sim

    rng(1);

    N      = 2048;
    THR_DB = 8.3934;       % -ln(1e-3): 8.393 dB above the noise mean
    QBINS  = 64;

    n     = (0:N-1).';
    w     = 0.54 - 0.46*cos(2*pi*n/(N-1));   % Hamming
    SUMW  = sum(w);
    SUMW2 = sum(w.^2);

    % ---------------- targets -------------------------------------------
    % [fractional bin, SNR (dB) at the peak bin, phase]
    sparse = [ ...
        300.0  24  0.3; ...
        301.6  20  1.1; ...   % close to 300
        303.2  17  2.0; ...
        700.0  21  0.0; ...
        702.2  18  0.7; ...   % close to 700
        512.4   9  1.9; ...   % weak, isolated
       1280.3  12  2.4; ...
       1500.7  14  0.5];

    dense = [sparse; dense_targets(N, 400, 2)];

    % ---------------- frames --------------------------------------------
    P1 = make_frame(N, w, SUMW, SUMW2, sparse, 11);
    P2 = make_frame(N, w, SUMW, SUMW2, dense , 12);

    % ---------------- estimator -----------------------------------------
    [nf1, thr1]                  = med_cfar(P1, THR_DB, QBINS);
    [nf2, thr2, cnt2, bm2, span2] = med_cfar(P2, THR_DB, QBINS);

    m1 = metrics(P1, thr1, sparse);
    m2 = metrics(P2, thr2, dense);

    % ---------------- console report ------------------------------------
    fprintf('\n===== linear block-mean histogram, median =====\n');
    fprintf('true per-bin noise power = 1.000 (0.00 dB), thr = mean + %.1f dB\n\n', THR_DB);
    fprintf('scenario  ntgt  floor(dB)  thr(dB)  det/tgt   bits   fill16\n');
    fprintf('------------------------------------------------------------\n');
    row('sparse', nf1, thr1, m1);
    row('dense ', nf2, thr2, m2);
    fprintf('\n');

    % ---------------- plots ---------------------------------------------
    x  = (0:N-1).';
    y1 = 10*log10(max(P1, 1e-12));
    y2 = 10*log10(max(P2, 1e-12));

    figure('Color','w','Position',[80 80 1500 900]);

    % --- sparse profile
    subplot(2,2,1);
    prof(x, y1, sparse, thr1, sprintf('sparse: %d targets', size(sparse,1)));

    % --- dense profile (image-like hump of close tones)
    subplot(2,2,2);
    prof(x, y2, dense, thr2, sprintf('dense: %d targets, broad cluster', size(dense,1)));

    % --- dense block-mean histogram
    subplot(2,2,3);
    edges = linspace(0, span2, QBINS+1);
    ctr   = edges(1:end-1) + diff(edges)/2;
    bar(ctr, cnt2, 1, 'FaceColor',[0.35 0.55 0.80], 'EdgeColor','none');
    hold on;
    yl = ylim;
    plot([nf2 nf2], yl, 'r--', 'LineWidth', 1.6);
    hold off; grid on;
    xlim([0 span2]);
    xlabel('16-bin block mean (linear power)');
    ylabel('count');
    legend({'histogram','median -> mean'}, 'Location','northwest');
    title({sprintf('dense hist: median->mean = %.3g (%.2f dB)', nf2, 10*log10(nf2)), ...
           sprintf('span = %.3g, raw mean = %.3g (target-inflated)', span2, mean(bm2))});

    % --- density sweep
    subplot(2,2,4);
    nts  = [0 50 100 200 300 400];
    nfdb = zeros(size(nts));
    fill = zeros(size(nts));
    for i = 1:numel(nts)
        nacc = 0;
        facc = 0;
        for rep = 1:3
            T = dense_targets(N, nts(i), 600 + 10*i + rep);
            P = make_frame(N, w, SUMW, SUMW2, T, 800 + 10*i + rep);
            [ff, tt] = med_cfar(P, THR_DB, QBINS);
            nacc = nacc + ff;
            mm   = metrics(P, tt, T);
            facc = facc + mm.fill;
        end
        nfdb(i) = 10*log10(nacc/3);
        fill(i) = 100*facc/3;
    end

    yyaxis left;
    plot(nts, nfdb, 'o-', 'LineWidth', 1.5);
    ylabel('floor error (dB)');
    yyaxis right;
    plot(nts, fill, 's--', 'LineWidth', 1.5);
    ylabel('16-bin fill (%)');
    xlabel('dense tones per frame');
    grid on;
    legend({'floor error','fill16'}, 'Location','northwest');
    title('density sweep');

    % ---------------- save ----------------------------------------------
    try
        out = fullfile(fileparts(mfilename('fullpath')), 'hist_sim.png');
        print(gcf, '-dpng', '-r150', out);
        fprintf('figure saved to %s\n', out);
    catch
    end
end

% =====================================================================
function T = dense_targets(N, n, seed)
% Image-like dense scene: n close-frequency tones in one broad hump.
% Bins ~650..1250, Gaussian amplitude envelope centred at bin 950.
    if n == 0
        T = zeros(0,3);
        return;
    end
    rng(seed);
    kb  = 650 + rand(n,1)*600;
    env = exp(-0.5*((kb - 950)/200).^2);
    snr = 6 + 20*env + 3*(rand(n,1) - 0.5);
    ph  = 2*pi*rand(n,1);
    T   = [kb snr ph];
end

% =====================================================================
function P = make_frame(N, w, SUMW, SUMW2, targets, seed)
% Time-domain frame: complex noise + close-frequency tones, Hamming, FFT.
    rng(seed);
    noise = (randn(N,1) + 1i*randn(N,1))/sqrt(2);   % E|n|^2 = 1
    x = noise;
    idx = (0:N-1).';
    for t = 1:size(targets,1)
        k0    = targets(t,1);
        snr   = 10^(targets(t,2)/10);
        phase = targets(t,3);
        % peak bin power after window+FFT = snr * P_bin
        amp = sqrt(snr * SUMW2 / SUMW^2);
        x = x + amp*exp(1i*(2*pi*k0*idx/N + phase));
    end
    X = fft(x .* w);           % Hamming window here
    P = abs(X).^2 / SUMW2;     % per-bin noise power is 1
end

% =====================================================================
function [nf, thr, cnt, bmean, span] = med_cfar(P, thr_db, qbins)
% Kernel shape: 16-bin mean -> linear histogram -> median -> linear thr.
% The span comes from a coarse median pass, not from the mean: in a dense
% scene the mean is target-dominated and the bins become too wide at the
% floor.  The second pass is the fine histogram.
    bmean = sum(reshape(P, 16, []), 1) / 16;

    span0 = 4*mean(bmean);
    if ~(span0 > 0); span0 = 1; end
    m0 = hist_q(bmean, span0, qbins, 0.5);

    span = 4*m0;
    if ~(span > 0); span = 1; end
    [med, cnt] = hist_q(bmean, span, qbins, 0.5);

    nf  = med * 16 / gammaincinv(0.5, 16);          % median -> mean
    thr = nf * 10^(thr_db/10);
end

function [q, cnt] = hist_q(v, span, qbins, p)
% Linear histogram + interpolated quantile.
    edges = linspace(0, span, qbins+1);
    vv    = min(max(v, 0), span - eps(span));
    cnt   = histcounts(vv, edges);

    target = max(1, round(numel(v)*p));

    cum  = 0;
    bin  = 1;
    frac = 0;
    for bin = 1:qbins
        prev = cum;
        cum  = cum + cnt(bin);
        if cum >= target
            frac = (target - prev) / cnt(bin);
            break;
        end
    end
    q = ((bin-1) + frac) * (span/qbins);
end

% =====================================================================
function m = metrics(P, thr, targets)
% Detection of each target's peak bin (+-1) / mask size / 16-bin fill.
    N   = numel(P);
    msk = P > thr;

    det = 0;
    for t = 1:size(targets,1)
        k0 = round(targets(t,1));
        lo = max(1, k0-1);
        hi = min(N, k0+1);
        if any(msk(lo:hi))
            det = det + 1;
        end
    end

    nb = N/16;
    fill = 0;
    for j = 1:nb
        if any(msk((j-1)*16 + (1:16)))
            fill = fill + 1;
        end
    end

    m = struct('det', det, 'ntgt', size(targets,1), ...
               'bits', sum(msk), 'fill', fill/nb);
end

% =====================================================================
function prof(x, y, targets, thr, name)
% Range profile + true floor + threshold + detections + target markers.
    plot(x, y, 'Color', [0.16 0.42 0.70], 'LineWidth', 0.8);
    hold on;
    plot([x(1) x(end)], [0 0], 'g-', 'LineWidth', 1.4);
    plot([x(1) x(end)], 10*log10([thr thr]), 'r--', 'LineWidth', 1.6);

    yl = [-12 36];
    ylim(yl);

    idx = find(y > 10*log10(thr)) - 1;
    plot(idx, -10*ones(size(idx)), 'r.', 'MarkerSize', 2);

    for t = 1:size(targets,1)
        k0 = round(targets(t,1));
        lo = max(1, k0-3);
        hi = min(numel(y), k0+3);
        [pk, ii] = max(y(lo:hi));
        plot(lo+ii-2, min(pk, yl(2)-1), 'o', ...
             'MarkerEdgeColor', [0.85 0.45 0.10], 'MarkerSize', 4);
    end

    grid on;
    xlabel('range bin'); ylabel('dB');
    legend({'profile','true floor','threshold'}, 'Location','northeast');
    title(name);
    hold off;
end

% =====================================================================
function row(scen, nf, thr, m)
    fprintf('%-8s %4d  %8.2f  %7.2f  %3d/%-3d  %5d  %5.2f\n', ...
            scen, m.ntgt, 10*log10(nf), 10*log10(thr), ...
            m.det, m.ntgt, m.bits, m.fill);
end
