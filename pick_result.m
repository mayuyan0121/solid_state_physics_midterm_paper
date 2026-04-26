function r = pick_result(results, kind, N, bc)
%PICK_RESULT Select one result record.
mask = arrayfun(@(x) x.kind == string(kind) && x.N == N && x.bc == string(bc), results);
idx = find(mask, 1);
if isempty(idx)
    error("Result not found: kind=%s N=%d bc=%s", string(kind), N, string(bc));
end
r = results(idx);
end
