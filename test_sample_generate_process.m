function finalfeature_test=test_sample_generate_process(img,blksizein,locin)

[rsize,csize]=size(img);
blksize=blksizein*3;
blkloc=floor(blksize/2);
imgin=zeros(rsize+2*blkloc,csize+2*blkloc);
[rr1 cc1]=size(imgin);
imgin(1+blkloc:rr1-blkloc,1+blkloc:cc1-blkloc)=img;
ind=1;
[rr,cc]=size(locin);
for knid=1:rr
     kr=locin(knid,1);kc=locin(knid,2);
      imgblk=imgin(kr-blkloc:kr+blkloc,kc-blkloc:kc+blkloc);
      featureout=feature_extraction_gclm(imgblk);
      finalfeat(ind,1:(length(featureout)))=[featureout];
       ind=ind+1;
        

end
finalfeature_test=finalfeat;

