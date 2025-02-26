function featureout=feature_extraction_gclm(imgval)


imgval=double(imgval);
g1=graycomatrix(imgval,'NumLevels',8,'offset',[0 2]);
g2=graycomatrix(imgval,'NumLevels',8,'offset',[-2 2]);
g3=graycomatrix(imgval,'NumLevels',8,'offset',[-2 0]);
g4=graycomatrix(imgval,'NumLevels',8,'offset',[-2 -2]);

homval1=homogeneity_func(g1);
homval2=homogeneity_func(g2);
homval3=homogeneity_func(g3);
homval4=homogeneity_func(g4);
homval=mean([homval1.Homogeneity homval2.Homogeneity homval3.Homogeneity homval4.Homogeneity]);


engval1=energy_func(g1);
engval2=energy_func(g2);
engval3=energy_func(g3);
engval4=energy_func(g4);
engval=mean([engval1.Energy engval2.Energy engval3.Energy engval4.Energy]);

g1=normalize_gclm(g1);
g2=normalize_gclm(g2);
g3=normalize_gclm(g3);
g4=normalize_gclm(g4);

ctr1=contrast_func(g1);
ctr2=contrast_func(g2);
ctr3=contrast_func(g3);
ctr4=contrast_func(g4);
contrast=mean([ctr1 ctr2 ctr3 ctr4]);
featureout(1,1)=contrast;

e1=entropy_func(g1);
e2=entropy_func(g2);
e3=entropy_func(g3);
e4=entropy_func(g4);
etr=mean([e1 e2 e3 e4]);
featureout(1,2)=etr;

s1=std2(g1);
s2=std2(g2);
s3=std2(g3);
s4=std2(g4);
stdval=mean([s1 s2 s3 s4]);
featureout(1,3)=stdval;


kur1=kurtosis(kurtosis(g1));
kur2=kurtosis(kurtosis(g2));
kur3=kurtosis(kurtosis(g3));
kur4=kurtosis(kurtosis(g4));
kurval=mean([kur1 kur2 kur3 kur4]);
featureout(1,4)=kurval;


ske1=skewness(skewness(g1));
ske2=skewness(skewness(g2));
ske3=skewness(skewness(g3));
ske4=skewness(skewness(g4));
skeval=mean([ske1 ske2 ske3 ske4]);
featureout(1,5)=skeval;




featureout(1,6)=homval;


featureout(1,7)=engval;

corr1=correlation_func(g1);
corr2=correlation_func(g2);
corr3=correlation_func(g3);
corr4=correlation_func(g4);
corrval=mean([corr1 corr2 corr3 corr4]);
featureout(1,8)=corrval;
cmploc=find(isnan(featureout));
featureout(cmploc)=0.001;
featureout=repmat(featureout,[1 5]);
