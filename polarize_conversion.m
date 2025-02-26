% Read the input image
inputImage = imread('C:\5th sem\ML SAR\SYNTHETIC APERTURE RADAR (SAR)\city image.jpeg');

% Convert the image to grayscale if it's a color image
if size(inputImage, 3) == 3
    inputImage = rgb2gray(inputImage);
end

% Convert the image to double for processing
inputImage = double(inputImage);

% Define the polarizing matrices
H = [1, 1, 0; 1, -1, 0; 0, 0, 0]; % Horizontal polarization
V = [1, 0, 1; 0, 0, 0; 1, 0, -1]; % Vertical polarization
D = [1, -1, 0; 1, 1, 0; 0, 0, 2]; % Diagonal polarization

% Apply polarizing matrices to get polarized images
HH = conv2(inputImage, H, 'same');
VV = conv2(inputImage, V, 'same');
HV = conv2(inputImage, H, 'same');
VH = conv2(inputImage, V, 'same');

% Display the original and polarized images
figure;
subplot(2, 3, 1), imshow(uint8(inputImage)), title('Original Image');
subplot(2, 3, 2), imshow(uint8(HH)), title('HH Polarization');
subplot(2, 3, 3), imshow(uint8(VV)), title('VV Polarization');
subplot(2, 3, 4), imshow(uint8(HV)), title('HV Polarization');
subplot(2, 3, 5), imshow(uint8(VH)), title('VH Polarization');

% Save the polarized images as TIFF files
imwrite(uint8(HH), 'HH_polarized3.tif');
imwrite(uint8(VV), 'VV_polarized3.tif');
imwrite(uint8(HV), 'HV_polarized3.tif');
imwrite(uint8(VH), 'VH_polarized3.tif');

