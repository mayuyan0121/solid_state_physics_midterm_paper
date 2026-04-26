function [k, E, m] = analytic_electron_fixed(N, t, eps0, a)
%ANALYTIC_ELECTRON_FIXED Tight-binding spectrum with end nodes.
m = 1:N;
k = m * pi / ((N + 1) * a);
E = eps0 - 2 * t * cos(k * a);
end
