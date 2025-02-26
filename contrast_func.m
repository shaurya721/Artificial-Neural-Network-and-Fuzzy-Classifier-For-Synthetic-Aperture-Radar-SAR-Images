function ctr1=contrast_func(g1)

s = size(g1);
[c,r] =meshgrid(1:s(1),1:s(2));
r = r(:);
c = c(:);
term1 = abs(r - c).^2;
term2 =g1;
term = term1 .* term2(:);
ctr1=sum(term);

