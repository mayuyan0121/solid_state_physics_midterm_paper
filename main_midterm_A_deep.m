% MAIN_MIDTERM_A_DEEP
% Reproducible numerical workflow for the 1D monatomic-chain midterm paper.

clear; clc; close all;
params = init_params_A_deep();
if ~exist(params.outdir, "dir"); mkdir(params.outdir); end
if ~exist(params.datadir, "dir"); mkdir(params.datadir); end

results = struct("kind", string.empty, "N", [], "bc", string.empty, ...
    "matrix", [], "vals", [], "eigvecs", [], "analytic_vals", [], ...
    "max_abs_err", [], "sigma", [], "Cv", [], "spacing", []);

idx = 0;
for N = params.N_list
    for bc = params.bc_list
        H = build_tb_matrix(N, params.t, params.eps0, bc);
        [E_num, V_e] = solve_spectrum(H, "full");
        if bc == "pbc"
            [~, E_ana] = analytic_electron_pbc(N, params.t, params.eps0, params.a);
        else
            [~, E_ana] = analytic_electron_fixed(N, params.t, params.eps0, params.a);
        end
        idx = idx + 1;
        results(idx) = make_record("electron", N, bc, H, E_num, V_e, ...
            sort(E_ana(:)), params.sigmaE, [], compute_level_spacing(E_num));

        D = build_dynamical_matrix(N, params.C, params.M, bc);
        [lam_num, V_p] = solve_spectrum(D, "full");
        lam_num(abs(lam_num) < 1e-12) = 0;
        omega_num = sqrt(max(lam_num, 0));
        if bc == "pbc"
            [~, W_ana] = analytic_phonon_pbc(N, params.C, params.M, params.a);
        else
            [~, W_ana] = analytic_phonon_fixed(N, params.C, params.M, params.a);
        end
        idx = idx + 1;
        results(idx) = make_record("phonon", N, bc, D, sort(omega_num(:)), V_p, ...
            sort(W_ana(:)), params.sigmaW, compute_cv(omega_num, params.Tgrid), ...
            compute_level_spacing(omega_num));
    end
end

checks = compare_bc_spectral_measure(results, params);
surface_example = compute_surface_state_example(params);
scaling = run_scaling_analysis(params);

figs = struct();
figs.Fig1_dispersion_sampling = plot_dispersion_sampling(params);
figs.Fig2_levels_spacing = plot_levels_spacing(results, params);
figs.Fig3_dos_idos = plot_dos_idos(results, params);
figs.Fig4_cv_collapse = plot_cv_collapse(results, params);
figs.Fig5_green_map = plot_green_spectral_map(results, params);
figs.Supp_boundary_error_surface = plot_boundary_error_surface(params);

export_all_figures_A_deep(figs, params);
make_animation_Nlimit_A(params);

save(fullfile(params.datadir, "midterm_A_deep_results.mat"), ...
    "params", "results", "checks", "surface_example", "scaling");
writetable(checks.table, fullfile(params.datadir, "spectral_measure_checks.csv"));
writetable(surface_example, fullfile(params.datadir, "surface_state_example.csv"));

disp(checks.table);
disp(surface_example);
disp(scaling);

function rec = make_record(kind, N, bc, A, vals, vecs, analytic_vals, sigma, Cv, spacing)
rec.kind = string(kind);
rec.N = N;
rec.bc = string(bc);
rec.matrix = A;
rec.vals = sort(real(vals(:)));
rec.eigvecs = vecs;
rec.analytic_vals = sort(real(analytic_vals(:)));
rec.max_abs_err = max(abs(rec.vals - rec.analytic_vals));
rec.sigma = sigma;
rec.Cv = Cv;
rec.spacing = spacing;
end

function surface_example = compute_surface_state_example(params)
% Semi-infinite Tamm-like bound state verified by a large finite open chain.
Nsurf = 100;
Delta = 2 * params.t;
lambda = -params.t / Delta;
E_analytic = params.eps0 + Delta + params.t^2 / Delta;
xi = -params.a / log(abs(lambda));

H = build_tb_matrix(Nsurf, params.t, params.eps0, "fixed");
H(1, 1) = params.eps0 + Delta;
[evals, evecs] = solve_spectrum(H, "full");
[E_numeric, idx] = max(evals);
psi = evecs(:, idx);
psi = psi / norm(psi);
boundary_weight = max(abs(psi([1, Nsurf])).^2);

surface_example = table("semi-infinite Tamm-like chain, finite N=100 check", ...
    Delta / params.t, E_analytic / params.t, E_numeric / params.t, ...
    abs(lambda), xi / params.a, boundary_weight, ...
    'VariableNames', {'model', 'Delta_over_t', 'analytic_Eb_over_t', ...
    'numerical_Eb_over_t', 'abs_lambda', 'xi_over_a', 'boundary_weight'});
end

function scaling = run_scaling_analysis(params)
% Half-filled spinless electronic ground-state energy per site.
Nvec = params.N_scale(:);
obsP = zeros(size(Nvec));
obsF = zeros(size(Nvec));
for i = 1:numel(Nvec)
    N = Nvec(i);
    [~, Ep] = analytic_electron_pbc(N, params.t, params.eps0, params.a);
    [~, Ef] = analytic_electron_fixed(N, params.t, params.eps0, params.a);
    nfill = floor(N / 2);
    Ep = sort(Ep, "ascend");
    Ef = sort(Ef, "ascend");
    obsP(i) = sum(Ep(1:nfill)) / N;
    obsF(i) = sum(Ef(1:nfill)) / N;
end
obs_inf = -2 * params.t / pi;
fitP = compute_finite_size_scaling(obsP, Nvec, obs_inf);
fitF = compute_finite_size_scaling(obsF, Nvec, obs_inf);
scaling = struct("N", Nvec, "half_filling_PBC", obsP, ...
    "half_filling_fixed", obsF, "infinite", obs_inf, ...
    "fit_PBC", fitP, "fit_fixed", fitF);
end
