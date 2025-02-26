
%% ANN CLASSIFIER
case_name = 'ANN Classifier';
resoutann = img_clust_out;
train_data = finalfeature_train(:, 1:end-1);
train_class = finalfeature_train(:, end) / 100;
test_data = finalfeature_test(:, 1:end);
result_ann = ann_process(train_data, train_class, test_data);

% Update classified results on the image
for km = 1:length(result_ann)
    locout = finalfeatloc_train(km, 1:2);
    rloc = locout(1); cloc = locout(2);
    resoutann(rloc, cloc) = result_ann(km);
end

% Convert classified image to label image
resimg_ann = rgb2label_conversion(resoutann, colormapvalue);

% Display classified image after ANN
figure;
imagesc(resimg_ann);
colormap(colormapvalue);
axis off;
title('Classified Image - ANN Classifier');
colorbar('Ticks', 1:3, 'TickLabels', res_str);
legend(res_str, 'Location', 'EastOutside', 'Orientation', 'vertical');

% Confusion matrix for ANN
confmat_ann = confusionmat(train_class, result_ann);
disp('Confusion Matrix - ANN Classifier:');
disp(confmat_ann);

% Apply fuzzy classifier to the ANN result
resoutfuzzy_after_ann = resoutann; % Copy ANN result to use in fuzzy classifier
result_fuzzy_after_ann = fuzzy_classifier(train_data, train_class, test_data);

% Update classified results on the image after fuzzy classifier
for km = 1:length(result_fuzzy_after_ann)
    locout = finalfeatloc_train(km, 1:2);
    rloc = locout(1); cloc = locout(2);
    resoutfuzzy_after_ann(rloc, cloc) = result_fuzzy_after_ann(km);
end

% Convert classified image to label image after fuzzy classifier
resimg_fuzzy_after_ann = rgb2label_conversion(resoutfuzzy_after_ann, colormapvalue);

% Display classified image after fuzzy classifier
figure;
imagesc(resimg_fuzzy_after_ann);
colormap(colormapvalue);
axis off;
title('Classified Image - Fuzzy Classifier (After ANN)');
colorbar('Ticks', 1:3, 'TickLabels', res_str);
legend(res_str, 'Location', 'EastOutside', 'Orientation', 'vertical');

% Confusion matrix for Fuzzy Classifier
confmat_fuzzy = confusionmat(train_class, result_fuzzy_after_ann);
disp('Confusion Matrix - Fuzzy Classifier (After ANN):');
disp(confmat_fuzzy);


%{
%%  ANN CLASSIFIER
case_name='ANN Classifier';
resoutann=img_clust_out;
train_data=finalfeature_train(:,1:end-1);
train_class=finalfeature_train(:,end)/100;
test_data=finalfeature_test(:,1:end);
result_ann=ann_process(train_data,train_class,test_data);

% Update classified results on the image
for km=1:length(result_ann)
    locout=finalfeatloc_train(km,1:2);
    rloc=locout(1);cloc=locout(2);
    resoutann(rloc,cloc)=result_ann(km);
end

% Convert classified image to label image
resimg=rgb2label_conversion(resoutann,colormapvalue);

% display classified image
PLOT

%%  FUZZY CLASSIFIER
case_name='FUZZY Classifier';
resoutfuzzy=img_clust_out;
train_data=finalfeature_train(:,1:end-1);
train_class=finalfeature_train(:,end)/100;
test_data=finalfeature_test(:,1:end);
result_fuzzy=fuzzy_classifier(train_data,train_class,test_data);

% Update classified results on the image
for km=1:length(result_fuzzy)
    locout=finalfeatloc_train(km,1:2);
    rloc=locout(1);cloc=locout(2);
    resoutfuzzy(rloc,cloc)=result_fuzzy(km);
end

% Convert classified image to label image
resimg=rgb2label_conversion(resoutfuzzy,colormapvalue);

% display classified image
%PLOTS
%}
