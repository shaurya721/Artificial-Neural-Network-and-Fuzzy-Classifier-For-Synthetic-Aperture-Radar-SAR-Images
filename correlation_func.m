function corr_val=correlation_func(g1)



s = size(g1);
[c,r] =meshgrid(1:s(1),1:s(2));
r = r(:);
c = c(:);

corr_val=correlation_process(g1,r,c);
