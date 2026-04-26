function checks = compare_bc_spectral_measure(results, params)
%COMPARE_BC_SPECTRAL_MEASURE Cross-check spectra, DOS normalization, and IDOS.
checks = struct();
rows = {};
for i = 1:numel(results)
    r = results(i);
    if r.kind == "electron"
        grid = params.Egrid;
        cont = analytic_electron_idos(grid, params);
    else
        grid = params.Wgrid;
        cont = analytic_phonon_idos(grid, params);
    end
    idos = compute_idos(r.vals, grid);
    dos = compute_dos(r.vals, grid, r.sigma);
    normerr = trapz(grid, dos) - 1;
    ksdist = max(abs(idos - cont));
    rows = [rows; {r.kind, r.N, char(r.bc), normerr, ksdist, r.max_abs_err}]; %#ok<AGROW>
end
checks.table = cell2table(rows, "VariableNames", ...
    ["kind", "N", "bc", "dos_norm_error", "idos_KS_distance", "analytic_numeric_max_abs_error"]);
end

function F = analytic_electron_idos(E, params)
x = (E - params.eps0) / (2 * params.t);
F = zeros(size(E(:)));
mask = x > -1 & x < 1;
F(x >= 1) = 1;
F(mask) = acos(-x(mask)) / pi;
end

function F = analytic_phonon_idos(w, params)
wmax = 2 * sqrt(params.C / params.M);
x = w(:) / wmax;
F = zeros(size(x));
mask = x > 0 & x < 1;
F(x >= 1) = 1;
F(mask) = (2 / pi) * asin(x(mask));
end
