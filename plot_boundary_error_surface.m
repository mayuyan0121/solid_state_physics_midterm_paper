function fig = plot_boundary_error_surface(params)
%PLOT_BOUNDARY_ERROR_SURFACE Difference between sorted PBC and fixed spectra.
rgrid = linspace(0.01, 0.99, 160);
Z = zeros(numel(params.N_scale), numel(rgrid));
for i = 1:numel(params.N_scale)
    N = params.N_scale(i);
    [~, Ep] = analytic_electron_pbc(N, params.t, params.eps0, params.a);
    [~, Ef] = analytic_electron_fixed(N, params.t, params.eps0, params.a);
    x = ((1:N) - 0.5) / N;
    Z(i, :) = abs(interp1(x, sort(Ef), rgrid, "linear") - interp1(x, sort(Ep), rgrid, "linear"));
end
[R, NN] = meshgrid(rgrid, params.N_scale);
fig = figure("Color", "w", "Name", "boundary_error_surface");
surf(R, NN, Z, "EdgeColor", "none");
xlabel("normalized level index"); ylabel("N"); zlabel("|E_F-E_P|");
title("Boundary-induced sorted-level difference");
view(45, 28); colorbar; box on; grid on;
end
