function fig = plot_cv_collapse(results, params)
%PLOT_CV_COLLAPSE Heat capacity and finite-size low-T collapse.
fig = figure("Color", "w", "Name", "cv_collapse");
fig.Position(3:4) = [1120 430];
tl = tiledlayout(fig, 1, 2, "Padding", "compact", "TileSpacing", "compact");
colors = lines(numel(params.N_required));
labels = strings(1, 2 * numel(params.N_required));

ax1 = nexttile(tl, 1); hold(ax1, "on");
for i = 1:numel(params.N_required)
    N = params.N_required(i);
    for b = 1:numel(params.bc_list)
        bc = params.bc_list(b);
        r = pick_result(results, "phonon", N, bc);
        style = "-";
        if bc == "fixed"; style = "--"; end
        semilogx(ax1, params.Tgrid, r.Cv, style, ...
            "Color", colors(i, :), "LineWidth", 1.5);
        labels(2*i - 2 + b) = sprintf("N=%d %s", N, char(bc));
    end
end
yline(ax1, 1, ":", "Color", [0.45 0.45 0.45], "LineWidth", 1.2, ...
    "HandleVisibility", "off");
xlabel(ax1, "T"); ylabel(ax1, "C_V/(N k_B)");
title(ax1, "(a) Finite-chain heat capacity", "FontWeight", "normal", "FontSize", 11.5);
ylim(ax1, [0 1.08]); xlim(ax1, [min(params.Tgrid) max(params.Tgrid)]);
grid(ax1, "on"); box(ax1, "on");

ax2 = nexttile(tl, 2); hold(ax2, "on");
h = gobjects(1, 2 * numel(params.N_required));
for i = 1:numel(params.N_required)
    N = params.N_required(i);
    for b = 1:numel(params.bc_list)
        bc = params.bc_list(b);
        r = pick_result(results, "phonon", N, bc);
        wpos = sort(r.vals(r.vals > 1e-12));
        xcollapse = params.Tgrid / wpos(1);
        style = "-";
        if bc == "fixed"; style = "--"; end
        h(2*i - 2 + b) = plot(ax2, xcollapse, r.Cv, style, ...
            "Color", colors(i, :), "LineWidth", 1.5);
    end
end
xlabel(ax2, "T/\omega_{min}"); ylabel(ax2, "C_V/(N k_B)");
title(ax2, "(b) Low-T collapse variable", "FontWeight", "normal", "FontSize", 11.5);
ylim(ax2, [0 1.08]); xlim(ax2, [0 40]);
grid(ax2, "on"); box(ax2, "on");
legend(ax2, h, labels, "Location", "eastoutside", "Box", "off", "FontSize", 9);

set(findall(fig, "Type", "axes"), "FontName", "Arial", "FontSize", 10.5, ...
    "LineWidth", 0.9, "TickDir", "out");
end
