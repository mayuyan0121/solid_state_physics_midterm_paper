function fig = plot_dispersion_sampling(params)
%PLOT_DISPERSION_SAMPLING Publication-quality dispersion and sampling plot.
fig = figure("Color", "w", "Name", "dispersion_sampling");
fig.Position(3:4) = [1050 430];
tiledlayout(fig, 1, 2, "Padding", "compact", "TileSpacing", "compact");
N = 20;
k = linspace(-pi / params.a, pi / params.a, 1600);

nexttile;
E = params.eps0 - 2 * params.t * cos(k * params.a);
plot(k * params.a, E / params.t, "k-", "LineWidth", 1.5); hold on;
[kp, Ep] = analytic_electron_pbc(N, params.t, params.eps0, params.a);
[kf, Ef] = analytic_electron_fixed(N, params.t, params.eps0, params.a);
scatter(kp * params.a, Ep / params.t, 34, "o", "filled", ...
    "MarkerFaceColor", [0.00 0.32 0.74], "MarkerEdgeColor", "w", "LineWidth", 0.4);
scatter(kf * params.a, Ef / params.t, 42, "d", ...
    "MarkerFaceColor", "w", "MarkerEdgeColor", [0.76 0.18 0.12], "LineWidth", 1.1);
xlabel("k a"); ylabel("E/t"); title("(a) Electronic band");
xlim([-pi pi]); xticks([-pi 0 pi]); xticklabels({"-\pi", "0", "\pi"});
legend("bulk", "PBC", "fixed", "Location", "southoutside", "Orientation", "horizontal");
grid on; box on; set(gca, "FontName", "Arial", "FontSize", 10.5, "LineWidth", 0.9, "TickDir", "out");

nexttile;
w = 2 * sqrt(params.C / params.M) * abs(sin(k * params.a / 2));
plot(k * params.a, w / sqrt(params.C / params.M), "k-", "LineWidth", 1.5); hold on;
[qp, Wp] = analytic_phonon_pbc(N, params.C, params.M, params.a);
[qf, Wf] = analytic_phonon_fixed(N, params.C, params.M, params.a);
scatter(qp * params.a, Wp / sqrt(params.C / params.M), 34, "o", "filled", ...
    "MarkerFaceColor", [0.00 0.32 0.74], "MarkerEdgeColor", "w", "LineWidth", 0.4);
scatter(qf * params.a, Wf / sqrt(params.C / params.M), 42, "d", ...
    "MarkerFaceColor", "w", "MarkerEdgeColor", [0.76 0.18 0.12], "LineWidth", 1.1);
xlabel("q a"); ylabel("\omega / (C/M)^{1/2}"); title("(b) Acoustic phonon");
xlim([-pi pi]); xticks([-pi 0 pi]); xticklabels({"-\pi", "0", "\pi"});
legend("bulk", "PBC", "fixed", "Location", "southoutside", "Orientation", "horizontal");
grid on; box on; set(gca, "FontName", "Arial", "FontSize", 10.5, "LineWidth", 0.9, "TickDir", "out");
end
