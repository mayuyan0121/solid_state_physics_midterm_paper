function fig = plot_green_spectral_map(results, params)
%PLOT_GREEN_SPECTRAL_MAP Resolvent-trace DOS for log-spaced eta values.
fig = figure("Color", "w", "Name", "green_spectral_map");
fig.Position(3:4) = [740 500];
N = 50;
r = pick_result(results, "electron", N, "fixed");
M = zeros(numel(params.eta_list), numel(params.Egrid));
for i = 1:numel(params.eta_list)
    eta = params.eta_list(i);
    M(i, :) = mean((eta / pi) ./ ((params.Egrid(:).' - r.vals).^2 + eta^2), 1);
end
imagesc(params.Egrid / params.t, log10(params.eta_list / params.t), M * params.t);
set(gca, "YDir", "normal", ...
    "FontName", "Arial", "FontSize", 10.5, "LineWidth", 0.9, "TickDir", "out");
xlabel("E/t"); ylabel("\eta/t");
title("Green-function reconstruction of broadened DOS", ...
    "FontWeight", "normal", "FontSize", 11.5);
cb = colorbar; cb.Label.String = "\rho(E;\eta)t";
cb.Label.FontSize = 10.5;
clim([0 2]);
yticks(log10([1e-3 1e-2 1e-1 0.2]));
yticklabels({"10^{-3}", "10^{-2}", "10^{-1}", "0.2"});
box on; xlim([-2.25 2.25]);
ax = gca;
ax.Position = [0.12 0.14 0.68 0.65];
cb.Position = [0.84 0.14 0.035 0.65];
end
