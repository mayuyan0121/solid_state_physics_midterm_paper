function fitinfo = compute_finite_size_scaling(obs, Nvec, obs_inf)
%COMPUTE_FINITE_SIZE_SCALING Convenience wrapper for observable errors.
err = abs(obs(:) - obs_inf);
fitinfo = fit_scaling_exponent(Nvec(:), err);
fitinfo.obs = obs(:);
fitinfo.obs_inf = obs_inf;
end
