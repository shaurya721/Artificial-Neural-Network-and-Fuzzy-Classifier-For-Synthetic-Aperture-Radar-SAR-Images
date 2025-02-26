function FINAL_RES_DISPLAY(targetval,outputval,res_str,case_name)

confin_ori=full(ind2vec(targetval.'));
confin_res=full(ind2vec(outputval.'));

% for kw=1:length(targetval)
%     ori_val{kw}=res_str{targetval(kw)};
% end
% for kw=1:length(outputval)
%     res_val{kw}=res_str{outputval(kw)};
% end
% 
% %%
% for kw=1:length(targetval)
%     confin_ori(kw,1:length(res_str))=ismember(res_str,ori_val{kw});
% end
% for kw=1:length(outputval)
%     confin_res(kw,1:length(res_str))=ismember(res_str,res_val{kw});
% end

[C,MAT_CONFUSION,IND,per_val]=confusion(double(confin_ori),double(confin_res));
case_nameout=[case_name ,' ',' 1- ',res_str{1},' 2- ',res_str{2},' ',' 3- ',res_str{3}];
figure,
plotconfusion(double(confin_ori),double(confin_res),[case_nameout]);






