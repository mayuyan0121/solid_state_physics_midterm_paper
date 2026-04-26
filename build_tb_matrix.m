function H = build_tb_matrix(N, t, eps0, bc)
%BUILD_TB_MATRIX Sparse nearest-neighbor tight-binding Hamiltonian.
main = eps0 * ones(N, 1);
off = -t * ones(N, 1);
H = spdiags([off main off], -1:1, N, N);
if string(bc) == "pbc" && N > 2
    H(1, N) = -t;
    H(N, 1) = -t;
elseif string(bc) ~= "fixed" && string(bc) ~= "pbc"
    error("Unknown boundary condition: %s", string(bc));
end
end
