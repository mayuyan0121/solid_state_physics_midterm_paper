function fitinfo = fit_scaling_exponent(Nvec, err)
%FIT_SCALING_EXPONENT Fit err ~= A*N^(-alpha).
Nvec = Nvec(:);
err = abs(err(:));
mask = isfinite(err) & err > 0 & isfinite(Nvec) & Nvec > 0;
coef = polyfit(log(Nvec(mask)), log(err(mask)), 1);
pred = polyval(coef, log(Nvec(mask)));
ss_res = sum((log(err(mask)) - pred).^2);
ss_tot = sum((log(err(mask)) - mean(log(err(mask)))).^2);
fitinfo.alpha = -coef(1);
fitinfo.A = exp(coef(2));
fitinfo.poly = coef;
fitinfo.R2 = 1 - ss_res / max(ss_tot, eps);
fitinfo.N = Nvec(mask);
fitinfo.err = err(mask);
fitinfo.pred = exp(pred);
end
