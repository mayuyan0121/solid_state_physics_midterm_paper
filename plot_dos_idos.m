function fig = plot_dos_idos(results, params)
%PLOT_DOS_IDOS Three-panel DOS, IDOS, and IDOS convergence figure.
fig = figure("Color", "w", "Name", "dos_idos");
fig.Position(3:4) = [1280 430];
tl = tiledlayout(fig, 1, 3, "Padding", "compact", "TileSpacing", "compact");
N = 50;
E = params.Egrid(:);
rho = analytic_electron_dos(E, params);
F = analytic_electron_idos(E, params);
colP = [0.00 0.32 0.74];
colF = [0.76 0.18 0.12];

ax1 = nexttile(tl, 1); hold(ax1, "on");
rho_clip = min(rho, 1.65);
plot(ax1, E / params.t, rho_clip * params.t, "k--", "LineWidth", 1.7);
rP = pick_result(results, "electron", N, "pbc");
rF = pick_result(results, "electron", N, "fixed");
plot(ax1, E / params.t, compute_dos(rP.vals, E, params.sigmaE) * params.t, ...
    "-", "Color", colP, "LineWidth", 1.7);
plot(ax1, E / params.t, compute_dos(rF.vals, E, params.sigmaE) * params.t, ...
    "-", "Color", colF, "LineWidth", 1.7);
xlabel(ax1, "E/t"); ylabel(ax1, "t \rho(E)");
title(ax1, "(a) Broadened DOS", "FontWeight", "normal");
legend(ax1, "bulk, clipped", "PBC", "fixed", ...
    "Location", "northeast", "Box", "off", "FontSize", 9);
ylim(ax1, [0 1.78]); xlim(ax1, [-2.25 2.25]);
grid(ax1, "on"); box(ax1, "on");

ax2 = nexttile(tl, 2); hold(ax2, "on");
plot(ax2, E / params.t, F, "k-", "LineWidth", 1.8);
stairs(ax2, E / params.t, compute_idos(rP.vals, E), "-", "Color", colP, "LineWidth", 1.35);
stairs(ax2, E / params.t, compute_idos(rF.vals, E), "-", "Color", colF, "LineWidth", 1.35);
xlabel(ax2, "E/t"); ylabel(ax2, "IDOS");
title(ax2, "(b) Integrated DOS", "FontWeight", "normal");
legend(ax2, "bulk", "PBC", "fixed", ...
    "Location", "southeast", "Box", "off", "FontSize", 9);
xlim(ax2, [-2.25 2.25]); ylim(ax2, [0 1]);
grid(ax2, "on"); box(ax2, "on");

ax3 = nexttile(tl, 3); hold(ax3, "on");
for bc = params.bc_list
    DN = zeros(size(params.N_scale));
    for i = 1:numel(params.N_scale)
        r = pick_result(results, "electron", params.N_scale(i), bc);
        DN(i) = max(abs(compute_idos(r.vals, E) - F));
    end
    if bc == "pbc"
        loglog(ax3, params.N_scale, DN, "o-", "Color", colP, ...
            "LineWidth", 1.7, "MarkerSize", 6, "MarkerFaceColor", colP);
    else
        loglog(ax3, params.N_scale, DN, "d-", "Color", colF, ...
            "LineWidth", 1.7, "MarkerSize", 6, "MarkerFaceColor", "w");
    end
end
xlabel(ax3, "N"); ylabel(ax3, "D_N");
title(ax3, "(c) IDOS convergence", "FontWeight", "normal");
legend(ax3, "PBC", "fixed", "Location", "southwest", "Box", "off", "FontSize", 9);
grid(ax3, "on"); box(ax3, "on");

set(findall(fig, "Type", "axes"), "FontName", "Arial", "FontSize", 10.5, ...
    "LineWidth", 0.9, "TickDir", "out");
end

function rho = analytic_electron_dos(E, params)
x = E - params.eps0;
rho = zeros(size(E));
mask = abs(x) < 2 * params.t;
rho(mask) = 1 ./ (pi * sqrt((2 * params.t)^2 - x(mask).^2));
end

function F = analytic_electron_idos(E, params)
x = (E - params.eps0) / (2 * params.t);
F = zeros(size(E));
mask = x > -1 & x < 1;
F(x >= 1) = 1;
F(mask) = acos(-x(mask)) / pi;
end
