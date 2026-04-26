function make_animation_Nlimit_A(params)
%MAKE_ANIMATION_NLIMIT_A Animate IDOS convergence as N increases.
if ~exist(params.outdir, "dir"); mkdir(params.outdir); end
v = VideoWriter(fullfile(params.outdir, "N_limit_IDOS_A.mp4"), "MPEG-4");
v.FrameRate = 12;
open(v);
fig = figure("Color", "w", "Name", "N_limit_animation");
E = params.Egrid(:);
F = analytic_electron_idos(E, params);
for N = [10:10:100 125:25:500]
    clf(fig); hold on;
    [~, Ep] = analytic_electron_pbc(N, params.t, params.eps0, params.a);
    [~, Ef] = analytic_electron_fixed(N, params.t, params.eps0, params.a);
    plot(E, F, "k-", "LineWidth", 1.5);
    stairs(E, compute_idos(Ep, E), "LineWidth", 1.0);
    stairs(E, compute_idos(Ef, E), "LineWidth", 1.0);
    xlabel("E/t"); ylabel("N(E)"); ylim([0 1]);
    title(sprintf("Integrated DOS convergence, N=%d", N));
    legend("bulk", "PBC", "fixed", "Location", "southeast");
    grid on; box on; drawnow;
    writeVideo(v, getframe(fig));
end
close(v);
close(fig);
end

function F = analytic_electron_idos(E, params)
x = (E - params.eps0) / (2 * params.t);
F = zeros(size(E));
mask = x > -1 & x < 1;
F(x >= 1) = 1;
F(mask) = acos(-x(mask)) / pi;
end
