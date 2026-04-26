function D = build_dynamical_matrix(N, C, M, bc)
%BUILD_DYNAMICAL_MATRIX Sparse dynamical matrix for a monatomic chain.
main = 2 * (C / M) * ones(N, 1);
off = -(C / M) * ones(N, 1);
D = spdiags([off main off], -1:1, N, N);
if string(bc) == "pbc" && N > 2
    D(1, N) = -(C / M);
    D(N, 1) = -(C / M);
elseif string(bc) ~= "fixed" && string(bc) ~= "pbc"
    error("Unknown boundary condition: %s", string(bc));
end
end
