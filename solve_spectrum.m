function [eigvals, eigvecs] = solve_spectrum(A, solver_mode)
%SOLVE_SPECTRUM Sorted eigenpairs for the small and medium chains used here.
if nargin < 2
    solver_mode = "full";
end

if string(solver_mode) == "full" || size(A, 1) <= 1500
    [V, D] = eig(full(A), "vector");
else
    k = min(80, size(A, 1) - 2);
    [V, Dmat] = eigs(A, k, "smallestreal");
    D = diag(Dmat);
end

[eigvals, order] = sort(real(D(:)));
eigvecs = V(:, order);
end
