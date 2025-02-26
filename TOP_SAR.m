clc
close all;
warning off;

disp('<strong>----------------------------------</strong>');
disp('<strong>SHAURYA-1BG21EC083</strong>');
disp('<strong>SURAJ-1BG21EC095</strong>');
disp('<strong>----------------------------------</strong>');
pause(1);
disp('<strong>**************************************************************************************************</strong>');
disp('<strong>ARTIFICIAL NEURAL NETWORK AND FUZZY CLASSIFIER FOR SYNTHETIC APERTURE RADAR (SAR) IMAGE</strong>');
disp('<strong>**************************************************************************************************</strong>');
pause(2);

imghh = imread('C:\5th sem\ML SAR\SYNTHETIC APERTURE RADAR (SAR)\imagery_HH.tif');
imghv = imread('C:\5th sem\ML SAR\SYNTHETIC APERTURE RADAR (SAR)\imagery_HV.tif');
imgvh = imread('C:\5th sem\ML SAR\SYNTHETIC APERTURE RADAR (SAR)\imagery_VH.tif');
imgvv = imread('C:\5th sem\ML SAR\SYNTHETIC APERTURE RADAR (SAR)\imagery_VV.tif');

% Apply lee filter to remove noise from all bands  
imghh = uint16(imghh); imghv = uint16(imghv);
imgvh = uint16(imgvh); imgvv = uint16(imgvv);
imghh(:,:,1) = lee_filter_process((imghh(:,:,1)));
imghh(:,:,2) = lee_filter_process((imghh(:,:,2)));
imghv(:,:,1) = lee_filter_process((imghv(:,:,1)));
imghv(:,:,2) = lee_filter_process((imghv(:,:,2)));
imgvh(:,:,1) = lee_filter_process((imgvh(:,:,1)));
imgvh(:,:,2) = lee_filter_process((imgvh(:,:,2)));
imgvv(:,:,1) = lee_filter_process((imgvv(:,:,1)));
imgvv(:,:,2) = lee_filter_process((imgvv(:,:,2)));

% Pauli decomposition apply to get RGB image and gray image
% Convert uint8 datatype
imghh1 = abs(imghh(:,:,2) + imghh(:,:,1)) / 2;
imgvh1 = abs(imgvh(:,:,2) + imgvh(:,:,1)) / 2;
imghv1 = abs(imghv(:,:,2) + imghv(:,:,1)) / 2;
imgvv1 = abs(imgvv(:,:,2) + imgvv(:,:,1)) / 2;

% Create RGB layers
redimg = (1/sqrt(2)) * (imghh1 + imgvv1); % Red layer
greenimg = (1/sqrt(2)) * (2 * imghv1); % Green layer
blueimg = (1/sqrt(2)) * (imgvv1 - imghh1); % Blue layer

% Combine RGB layers to form an RGB image
img(:,:,1) = redimg; img(:,:,2) = greenimg; img(:,:,3) = blueimg;

% RGB to gray conversion 
resize_range = 512;
img = rgb2gray(img);
img = imresize(img, [resize_range resize_range]);
[rsize, csize] = size(img);

% Display the input image
figure;
imagesc(uint8(img)), colormap('gray');
axis off;
title('Input Image');
pause(0.1);

% Apply Feature Extraction Process to Get Texture Feature from the Image
blksize = 5;

% Generate training samples and features
[finalfeature_train, finalfeatloc_train, img_clust_out] = train_sample_generate_process(img, blksize);

% Generate test samples and features
finalfeature_test = test_sample_generate_process(img, blksize, finalfeatloc_train);

% Train feature test feature pass to ANN classifier 
% 1-Urban % 2-Vegetation % 3-Water 
res_str{1} = 'Urban';
res_str{2} = 'Vegetation';
res_str{3} = 'Water';
colormapvalue = [255 0 0; 0 0 255; 0 255 0] / 255;
% Apply ANN classifier
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

% Calculate confusion matrix
confusion_matrix_ann = confusionmat(train_class, result_ann);

% Calculate and display ANN accuracy
ann_accuracy = sum(diag(confusion_matrix_ann)) / sum(confusion_matrix_ann(:));
%fprintf('ANN Classifier error: %.2f%%\n', ann_accuracy * 100);

% Add legend for ANN
legend(res_str, 'Location', 'EastOutside', 'Orientation', 'vertical');

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

% Calculate and display fuzzy classifier accuracy
fuzzy_accuracy = sum(diag(confusionmat(train_class, result_fuzzy_after_ann))) / sum(confusionmat(train_class, result_fuzzy_after_ann), 'all');
%fprintf('Fuzzy Classifier error: %.2f%%\n', fuzzy_accuracy * 100);

% Add legend for fuzzy classifier
legend(res_str, 'Location', 'EastOutside', 'Orientation', 'vertical');
%% 

% Display confusion matrices




% Confusion Matrix - Overall
subplot(1, 3, 3);
confusion_matrix_overall = confusionmat(train_class', result_fuzzy_after_ann);
confusion_chart(confusion_matrix_overall, res_str, 'Overall Classifier');
title('Confusion Matrix - Overall Classifier');





%% 




% Assuming 'finalfeature_train' contains the training features
% and 'finalfeature_test' contains the test features

% Concatenate training and test features for clustering
all_features = [finalfeature_train(:, 1:end-1); finalfeature_test];

% Number of clusters (assuming 3 for Urban, Vegetation, and Water)
num_clusters = 3;

% Apply k-means clustering
[idx, centers] = kmeans(all_features, num_clusters);

% Assign cluster labels to training and test samples
train_cluster_labels = idx(1:size(finalfeature_train, 1));
test_cluster_labels = idx(size(finalfeature_train, 1)+1:end);

% Display the clustered graph
figure;

% Plot Urban cluster
subplot(1, 3, 1);
urban_indices = find(train_cluster_labels == 1);
scatter3(all_features(urban_indices, 1), all_features(urban_indices, 2), all_features(urban_indices, 3), 50, 'r', 'filled');
hold on;
scatter3(centers(1, 1), centers(1, 2), centers(1, 3), 200, 'kx', 'LineWidth', 2);
title('Urban Cluster');
xlabel('Feature 1');
ylabel('Feature 2');
zlabel('Feature 3');
hold off;

% Plot Vegetation cluster
subplot(1, 3, 2);
vegetation_indices = find(train_cluster_labels == 2);
scatter3(all_features(vegetation_indices, 1), all_features(vegetation_indices, 2), all_features(vegetation_indices, 3), 50, 'g', 'filled');
hold on;
scatter3(centers(2, 1), centers(2, 2), centers(2, 3), 200, 'kx', 'LineWidth', 2);
title('Vegetation Cluster');
xlabel('Feature 1');
ylabel('Feature 2');
zlabel('Feature 3');
hold off;

% Plot Water cluster
subplot(1, 3, 3);
water_indices = find(train_cluster_labels == 3);
scatter3(all_features(water_indices, 1), all_features(water_indices, 2), all_features(water_indices, 3), 50, 'b', 'filled');
hold on;
scatter3(centers(3, 1), centers(3, 2), centers(3, 3), 200, 'kx', 'LineWidth', 2);
title('Water Cluster');
xlabel('Feature 1');
ylabel('Feature 2');
zlabel('Feature 3');
hold off;

sgtitle('Clustered Graph for Urban, Vegetation, and Water');

function confusion_chart(conf_matrix, labels, classifier_name)
    figure;
    colormap(parula); % You can choose a different colormap based on your preference

    imagesc(conf_matrix);
    colorbar;

    % Display text
    textStrings = num2str(conf_matrix(:), '%d');
    textStrings = strtrim(cellstr(textStrings));
    [x, y] = meshgrid(1:size(conf_matrix, 1), 1:size(conf_matrix, 2));
    hStrings = text(x(:), y(:), textStrings(:), 'HorizontalAlignment', 'center');
    midValue = mean(get(gca, 'CLim'));
    textColors = repmat(conf_matrix(:) > midValue, 1, 3);
    set(hStrings, {'Color'}, num2cell(textColors, 2));

    % Label the plot
    set(gca, 'XTick', 1:length(labels), 'XTickLabel', labels, 'YTick', 1:length(labels), 'YTickLabel', labels);
    xlabel('Predicted Class');
    ylabel('Actual Class');
    title(['Confusion Matrix - ' classifier_name]);
end
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

% Calculate and display fuzzy classifier accuracy
fuzzy_accuracy = sum(diag(confusionmat(train_class, result_fuzzy_after_ann))) / sum(confusionmat(train_class, result_fuzzy_after_ann), 'all');
%fprintf('Fuzzy Classifier error: %.2f%%\n', fuzzy_accuracy * 100);

% Add legend for fuzzy classifier
legend(res_str, 'Location', 'EastOutside', 'Orientation', 'vertical');
%% 

% Display confusion matrices




% Confusion Matrix - Overall
subplot(1, 3, 3);
confusion_matrix_overall = confusionmat(train_class', result_fuzzy_after_ann);
confusion_chart(confusion_matrix_overall, res_str, 'Overall Classifier');
title('Confusion Matrix - Overall Classifier');





%% 




% Assuming 'finalfeature_train' contains the training features
% and 'finalfeature_test' contains the test features

% Concatenate training and test features for clustering
all_features = [finalfeature_train(:, 1:end-1); finalfeature_test];

% Number of clusters (assuming 3 for Urban, Vegetation, and Water)
num_clusters = 3;

% Apply k-means clustering
[idx, centers] = kmeans(all_features, num_clusters);

% Assign cluster labels to training and test samples
train_cluster_labels = idx(1:size(finalfeature_train, 1));
test_cluster_labels = idx(size(finalfeature_train, 1)+1:end);

% Display the clustered graph
figure;

% Plot Urban cluster
subplot(1, 3, 1);
urban_indices = find(train_cluster_labels == 1);
scatter3(all_features(urban_indices, 1), all_features(urban_indices, 2), all_features(urban_indices, 3), 50, 'r', 'filled');
hold on;
scatter3(centers(1, 1), centers(1, 2), centers(1, 3), 200, 'kx', 'LineWidth', 2);
title('Urban Cluster');
xlabel('Feature 1');
ylabel('Feature 2');
zlabel('Feature 3');
hold off;

% Plot Vegetation cluster
subplot(1, 3, 2);
vegetation_indices = find(train_cluster_labels == 2);
scatter3(all_features(vegetation_indices, 1), all_features(vegetation_indices, 2), all_features(vegetation_indices, 3), 50, 'g', 'filled');
hold on;
scatter3(centers(2, 1), centers(2, 2), centers(2, 3), 200, 'kx', 'LineWidth', 2);
title('Vegetation Cluster');
xlabel('Feature 1');
ylabel('Feature 2');
zlabel('Feature 3');
hold off;

% Plot Water cluster
subplot(1, 3, 3);
water_indices = find(train_cluster_labels == 3);
scatter3(all_features(water_indices, 1), all_features(water_indices, 2), all_features(water_indices, 3), 50, 'b', 'filled');
hold on;
scatter3(centers(3, 1), centers(3, 2), centers(3, 3), 200, 'kx', 'LineWidth', 2);
title('Water Cluster');
xlabel('Feature 1');
ylabel('Feature 2');
zlabel('Feature 3');
hold off;

sgtitle('Clustered Graph for Urban, Vegetation, and Water');


function confusion_chart(conf_matrix, labels, classifier_name)
    figure;
    colormap(parula); % You can choose a different colormap based on your preference

    imagesc(conf_matrix);
    colorbar;

    % Display text
    textStrings = num2str(conf_matrix(:), '%d');
    textStrings = strtrim(cellstr(textStrings));
    [x, y] = meshgrid(1:size(conf_matrix, 1), 1:size(conf_matrix, 2));
    hStrings = text(x(:), y(:), textStrings(:), 'HorizontalAlignment', 'center');
    midValue = mean(get(gca, 'CLim'));
    textColors = repmat(conf_matrix(:) > midValue, 1, 3);
    set(hStrings, {'Color'}, num2cell(textColors, 2));

    % Label the plot
    set(gca, 'XTick', 1:length(labels), 'XTickLabel', labels, 'YTick', 1:length(labels), 'YTickLabel', labels);
    xlabel('Predicted Class');
    ylabel('Actual Class');
    title(['Confusion Matrix - ' classifier_name]);
end







      