function [q, omega, m] = analytic_phonon_fixed(N, C, M, a)
%ANALYTIC_PHONON_FIXED Acoustic phonons with fixed end nodes.
m = 1:N;
q = m * pi / ((N + 1) * a);
omega = 2 * sqrt(C / M) * sin(q * a / 2);
end
