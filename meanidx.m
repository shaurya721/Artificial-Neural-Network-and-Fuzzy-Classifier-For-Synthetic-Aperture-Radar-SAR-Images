function M = meanidx(index,glcm)

M = index .* glcm(:);
M = sum(M);
