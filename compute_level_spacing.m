function spacing = compute_level_spacing(vals)
%COMPUTE_LEVEL_SPACING Adjacent spacings, including exact degeneracies.
spacing = diff(sort(real(vals(:))));
end
