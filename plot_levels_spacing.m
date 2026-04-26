function fig = plot_levels_spacing(results, params)
%PLOT_LEVELS_SPACING Grouped spectra and probability-normalized spacings.
fig = figure("Color", "w", "Name", "levels_spacing");
fig.Position(3:4) = [1050 740];
tiledlayout(fig, 2, 2, "Padding", "compact", "TileSpacing", "compact");
colors = lines(numel(params.N_required));
labels = strings(1, 2 * numel(params.N_required));
for i = 1:numel(params.N_required)
    labels(2*i - 1) = sprintf("%d PBC", params.N_required(i));
    labels(2*i) = sprintf("%d fixed", params.N_required(i));
end

nexttile; hold on;
for i = 1:numel(params.N_required)
    N = params.N_required(i);
    for b = 1:numel(params.bc_list)
        bc = params.bc_list(b);
        r = pick_result(results, "electron", N, bc);
        x = 2*i - 2 + b;
        if bc == "pbc"
            scatter(x * ones(size(r.vals)), sort(r.vals) / params.t, 24, "o", "filled", ...
                "MarkerFaceColor", colors(i, :), "MarkerEdgeColor", "none", "MarkerFaceAlpha", 0.85);
        else
            scatter(x * ones(size(r.vals)), sort(r.vals) / params.t, 34, "d", ...
                "MarkerFaceColor", "w", "MarkerEdgeColor", colors(i, :), "LineWidth", 0.9);
        end
    end
end
xlim([0.4, 2*numel(params.N_required)+0.6]); xticks(1:numel(labels)); xticklabels(labels); xtickangle(30);
ylabel("E/t"); title("(a) Electronic levels");
grid on; box on; set(gca, "FontName", "Arial", "FontSize", 10.5, "LineWidth", 0.9, "TickDir", "out");

nexttile; hold on;
for i = 1:numel(params.N_required)
    N = params.N_required(i);
    for b = 1:numel(params.bc_list)
        bc = params.bc_list(b);
        r = pick_result(results, "phonon", N, bc);
        x = 2*i - 2 + b;
        if bc == "pbc"
            scatter(x * ones(size(r.vals)), sort(r.vals), 24, "o", "filled", ...
                "MarkerFaceColor", colors(i, :), "MarkerEdgeColor", "none", "MarkerFaceAlpha", 0.85);
        else
            scatter(x * ones(size(r.vals)), sort(r.vals), 34, "d", ...
                "MarkerFaceColor", "w", "MarkerEdgeColor", colors(i, :), "LineWidth", 0.9);
        end
    end
end
xlim([0.4, 2*numel(params.N_required)+0.6]); xticks(1:numel(labels)); xticklabels(labels); xtickangle(30);
ylabel("\omega"); title("(b) Phonon frequencies");
grid on; box on; set(gca, "FontName", "Arial", "FontSize", 10.5, "LineWidth", 0.9, "TickDir", "out");

nexttile; hold on;
for bc = params.bc_list
    allsp = [];
    for N = params.N_required
        r = pick_result(results, "electron", N, bc);
        allsp = [allsp; compute_level_spacing(r.vals)]; %#ok<AGROW>
    end
    histogram(allsp / params.t, 38, "Normalization", "probability", ...
        "DisplayStyle", "stairs", "LineWidth", 1.5);
end
xlabel("\Delta E/t"); ylabel("probability"); title("(c) Electronic spacing");
xline(0, "k:", "LineWidth", 1.1);
yl = ylim; xl = xlim;
text(max(0.03, xl(2)*0.05), yl(1) + 0.82*(yl(2)-yl(1)), ...
    "degenerate pairs", "FontSize", 9, "BackgroundColor", "w", "Margin", 1.2);
legend("PBC", "fixed", "Location", "northeast", "Box", "off"); grid on; box on;
set(gca, "FontName", "Arial", "FontSize", 10.5, "LineWidth", 0.9, "TickDir", "out");

nexttile; hold on;
for bc = params.bc_list
    allsp = [];
    for N = params.N_required
        r = pick_result(results, "phonon", N, bc);
        allsp = [allsp; compute_level_spacing(r.vals)]; %#ok<AGROW>
    end
    histogram(allsp, 38, "Normalization", "probability", ...
        "DisplayStyle", "stairs", "LineWidth", 1.5);
end
xlabel("\Delta \omega"); ylabel("probability"); title("(d) Phonon spacing");
xline(0, "k:", "LineWidth", 1.1);
yl = ylim; xl = xlim;
text(max(0.015, xl(2)*0.05), yl(1) + 0.82*(yl(2)-yl(1)), ...
    "degenerate pairs", "FontSize", 9, "BackgroundColor", "w", "Margin", 1.2);
legend("PBC", "fixed", "Location", "northeast", "Box", "off"); grid on; box on;
set(gca, "FontName", "Arial", "FontSize", 10.5, "LineWidth", 0.9, "TickDir", "out");
end
