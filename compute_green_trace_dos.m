function dos_green = compute_green_trace_dos(H, Egrid, eta)
%COMPUTE_GREEN_TRACE_DOS DOS from the resolvent trace.
N = size(H, 1);
I = speye(N);
dos_green = zeros(numel(Egrid), 1);
for i = 1:numel(Egrid)
    z = Egrid(i) + 1i * eta;
    G = (z * I - H) \ I;
    dos_green(i) = -imag(trace(G)) / (pi * N);
end
end
