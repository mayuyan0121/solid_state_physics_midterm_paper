function params = init_params_A_deep()
%INIT_PARAMS_A_DEEP Dimensionless parameters for the midterm project.

params.a = 1;
params.hbar = 1;
params.kB = 1;
params.eps0 = 0;
params.t = 1;
params.M = 1;
params.C = 1;

params.N_required = [10 20 50];
params.N_scale = [10 20 50 100 200 500 1000];
params.N_list = unique([params.N_required params.N_scale]);
params.bc_list = ["pbc", "fixed"];

params.Egrid = linspace(-2.4, 2.4, 2401);
params.Wgrid = linspace(-0.2, 2.2, 2401);
params.Kgrid = linspace(-pi / params.a, pi / params.a, 2000);
params.Tgrid = logspace(log10(0.005), log10(5), 360);

params.sigma_rel_list = [0.005 0.01 0.02 0.05];
params.sigma_rel = 0.02;
params.sigmaE = params.sigma_rel * (4 * params.t);
params.sigmaW = params.sigma_rel * (2 * sqrt(params.C / params.M));
params.eta = params.sigmaE;
params.eta_list = logspace(-3, log10(0.2), 80) * params.t;

params.outdir = fullfile(pwd, "figures_A_deep");
params.datadir = fullfile(pwd, "data_A_deep");
params.export_pdf = true;
params.export_png = true;
params.png_dpi = 600;
end
