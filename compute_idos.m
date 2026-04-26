function idos = compute_idos(vals, grid)
%COMPUTE_IDOS Normalized integrated density of states.
vals = sort(vals(:));
grid = grid(:);
idos = zeros(size(grid));
j = 0;
for i = 1:numel(grid)
    while j < numel(vals) && vals(j + 1) <= grid(i)
        j = j + 1;
    end
    idos(i) = j / numel(vals);
end
end
