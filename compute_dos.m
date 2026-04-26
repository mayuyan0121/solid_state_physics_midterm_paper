function dos = compute_dos(vals, grid, sigma)
%COMPUTE_DOS Gaussian-broadened normalized density of states.
vals = vals(:);
grid = grid(:).';
dos = zeros(size(grid));
normfac = 1 / (sqrt(2 * pi) * sigma * numel(vals));
block = 512;
for i = 1:block:numel(vals)
    j = min(i + block - 1, numel(vals));
    x = (grid - vals(i:j)) / sigma;
    dos = dos + normfac * sum(exp(-0.5 * x.^2), 1);
end
dos = dos(:);
end
