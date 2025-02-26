function eval=entropy_func(e1)


eval=-1*sum(sum(e1.*log2(e1+eps)));
