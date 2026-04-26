function [k, E, m] = analytic_electron_pbc(N, t, eps0, a)
%ANALYTIC_ELECTRON_PBC Tight-binding spectrum on a periodic ring.
m = 0:N-1;
kraw = 2 * pi * m / (N * a);
k = mod(kraw + pi / a, 2 * pi / a) - pi / a;
E = eps0 - 2 * t * cos(k * a);
[k, order] = sort(k);
E = E(order);
m = m(order);
end
