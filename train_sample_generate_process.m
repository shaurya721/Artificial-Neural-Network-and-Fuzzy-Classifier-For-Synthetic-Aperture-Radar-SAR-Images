function [finalfeature_train,...
    finalfeatloc_train,img_clust_out]=train_sample_generate_process(img,blksizein)
% train sample generate
[rsize,csize]=size(img);
no_of_cluster=3;
img_in1=double(img(:));
img_in=img_in1/max(img_in1);
meanval=2.0;term_thr = 0.00001;
eta=2.0;max_iter = 100;
init_segdata=[10;100;250];
[group_val,cluster_index]=fuzzy_process(img_in,...
    no_of_cluster,[meanval; eta; max_iter; term_thr;1],...
    init_segdata);
% 1-urban
% 2-vegtation
% 3-water
img_clust_out=zeros(rsize,csize);
loc1=find(cluster_index(1,:)==max(cluster_index));
img_clust_out(loc1)=1;
loc2=find(cluster_index(2,:)==max(cluster_index));
img_clust_out(loc2)=2;
loc3=find(cluster_index(3,:)==max(cluster_index));
img_clust_out(loc3)=3;
% figure,imshow(uint8(img_out_res))
%% extract texture features from image
blksize=blksizein*3;
blkloc=floor(blksize/2);
imgin=zeros(rsize+2*blkloc,csize+2*blkloc);
[rr1 cc1]=size(imgin);
imgin(1+blkloc:rr1-blkloc,1+blkloc:cc1-blkloc)=img;
ind=1;
for kmind=1:3
    
    [locr,locc]=find(img_clust_out==kmind);
      
    for kr1=1:30:length(locr)
        kr=locr(kr1);kc=locc(kr1);
        classlabel=img_clust_out(kr,kc);
        if((kr> (1+blkloc)) && (kr < rr1-(2*blkloc))...
                && (kc> (1+blkloc)) && (kc < cc1-(2*blkloc)))
            
            imgblk=imgin(kr-blkloc:kr+blkloc,kc-blkloc:kc+blkloc);
            featureout=feature_extraction_gclm(imgblk);
            
            
            finalfeat(ind,1:(length(featureout)+1))=[featureout classlabel];
            finalfeatloc(ind,1:2)=[kr kc];
            ind=ind+1;
        end
        
        
    end
    
end
finalfeature_train=finalfeat;
finalfeatloc_train=finalfeatloc;

