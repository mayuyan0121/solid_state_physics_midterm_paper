function Cv = compute_cv(omega, Tvec)
%COMPUTE_CV Harmonic phonon heat capacity per site, hbar=kB=1.
N = numel(omega);
w = omega(:);
w = w(w > 1e-12);
Cv = zeros(size(Tvec(:)));
for i = 1:numel(Tvec)
    x = w / Tvec(i);
    term = zeros(size(x));
    small = x < 1e-5;
    term(small) = 1;
    xs = x(~small);
    ex = exp(min(xs, 700));
    term(~small) = (xs.^2 .* ex) ./ (ex - 1).^2;
    Cv(i) = sum(term) / N;
end
end
