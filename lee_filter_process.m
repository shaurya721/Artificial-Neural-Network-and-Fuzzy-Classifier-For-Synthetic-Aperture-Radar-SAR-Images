function outputimage=lee_filter_process(img_in)
% apply lee filter to remove speckle noise from image
img_in = double(img_in);
outputimage=img_in;
window_size=3;
mean_of_image=imfilter(img_in, fspecial('average', window_size), 'replicate');
std_of_image=sqrt((img_in-mean_of_image).^2/window_size^2);
std_of_image=imfilter(std_of_image, fspecial('average', window_size), 'replicate');
mean_sprt_ele=(mean_of_image./std_of_image).^2;
std_value2=((mean_sprt_ele.*(std_of_image).^2) - mean_of_image.^2)./(mean_sprt_ele + 1);
final_res_image=mean_of_image + (std_value2.*(img_in-mean_of_image)./...
    (std_value2 + (mean_of_image.^2 ./mean_sprt_ele)));
outputimage(mean_of_image~=0) = final_res_image(mean_of_image~=0);

