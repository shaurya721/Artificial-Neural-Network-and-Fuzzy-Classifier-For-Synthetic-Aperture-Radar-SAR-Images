function Corr =correlation_process(glcm,r,c)

mr = meanidx(r,glcm);
Sr = stdidx(r,glcm,mr);


mc = meanidx(c,glcm);
Sc = stdidx(c,glcm,mc);

term1 = (r - mr) .* (c - mc) .* glcm(:);
term2 = sum(term1);

ws = warning('off','Matlab:divideByZero');
Corr = term2 / (Sr * Sc);
warning(ws);