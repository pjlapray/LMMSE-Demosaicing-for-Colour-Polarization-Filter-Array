%% This script load, and demosaic with LMMSE the data from the selected image
% References : 1-"Spote A, Lapray PJ, Thomas JB, Farup I. Joint demosaicing of
%              colour and polarisation from filter arrays. 
%              In 29th Color and Imaging Conference Final Program and Proceedings 2021. 
%              Society for Imaging Science and Technology."
%              2- "Dumoulin R., Lapray P.-J., Thomas J.-B., Farup I., Impact of
%              training data on LMMSE demosaicing for Colour-Polarization Filter Array,
%              submitted to SITIS conference, 2022. (update when published).
clc
close all
clear all

%% Global parameter
D_Matrix_name = 'D_Matrix.mat';
Save = false; % true to save the demosaiced image

%% Add path to Matlab for access
addpath(genpath('Function/'))

%% Load mosaiced image
MosImg=im2double(imread(['Data/im.tif'])); % (The scene has a polarizer sheet in background)
figure;imshow(MosImg);title('Mosaiced image');

%% Sizes definition
height = 4;                                 % height of the superpixel
width = 4;                                 % width of the superpixel
nh = 10;                               % number of neighbors per column (this code is valid only for 10x10 neighborhood)
nw= 10;                                % number of neighbors per line
P = 12;                                % number of color-pola channels
[rows, cols, ~] = size(MosImg);
r_superpix = rows/height;               % number of superpixel in a line
c_superpix = cols/width;                % number of superpixel in a column

%% Load D_Matrix
D=load(['Data/D_matrix.mat']).D;

%% Demosaicing
fun = @(x) (reshape(x.data(:),1,1,nh*nw));
x1 = permute(blockproc(MosImg,[4,4],fun,BorderSize=[3 3],TrimBorder=false,UseParallel =true),[3 1 2]);
y_estimate = D*reshape(x1,nh*nw,r_superpix*c_superpix);

%% Reconstruction of demosaicked images
img_estimate = zeros(rows, cols, P);
for u = 1:P
    img_estimate(:,:,u) = col2im(y_estimate(height*width*(u-1)+1:height*width*u,:), [height width], [r_superpix*height c_superpix*width],'distinct');
end
DemosImg = reshape(img_estimate,[r_superpix*height c_superpix*width 3 4]);

%% Show result
figure;
subplot(2,2,1),imshow(DemosImg(:,:,:,1)),title('Demosaiced image for 0° polarization')
subplot(2,2,2),imshow(DemosImg(:,:,:,2)),title('Demosaiced image for 45° polarization')
subplot(2,2,3),imshow(DemosImg(:,:,:,3)),title('Demosaiced image for 90° polarization')
subplot(2,2,4),imshow(DemosImg(:,:,:,4)),title('Demosaiced image for 135° polarization')

%% Save result
if Save == true
    save(['DemosImg.mat'],'DemosImg','-v7.3');
end
