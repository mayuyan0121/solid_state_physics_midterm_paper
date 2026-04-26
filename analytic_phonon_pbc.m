function [q, omega, m] = analytic_phonon_pbc(N, C, M, a)
%ANALYTIC_PHONON_PBC Acoustic phonons on a periodic ring.
m = 0:N-1;
qraw = 2 * pi * m / (N * a);
q = mod(qraw + pi / a, 2 * pi / a) - pi / a;
omega = 2 * sqrt(C / M) * abs(sin(q * a / 2));
[q, order] = sort(q);
omega = omega(order);
m = m(order);
end
