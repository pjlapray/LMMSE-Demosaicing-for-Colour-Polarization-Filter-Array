%% This script load, and demosaic with LMMSE the data from the selected image
clc
close all
clear all

%% Global parameter
D_Matrix_name = 'D_Matrix.mat';
Save=false; %true to save the demosaiced image
Save_name = 'DemosImg.mat';

%% Add path to Matlab for access
addpath(genpath('Function/'))

%% Define input folder
path=pwd();
folder_path = strcat(path, '/Data/');

%% Define output folder
folder_path1 = strcat(path, '/Result/');

%% Load mosaiced image
MosImg=im2double(imread([folder_path 'im.tif']));
figure;imshow(MosImg);

%% Load D_Matrix
D=load([folder_path D_Matrix_name]).D;

%% Demosaicing
DemosImg = LMMSE_demosaicing(D, MosImg(:,:,1));

%% Show result
figure;
subplot(2,2,1),imshow(DemosImg(:,:,:,1)),title('RGB image for polarization of 0°')
subplot(2,2,2),imshow(DemosImg(:,:,:,2)),title('RGB image for polarization of 45°')
subplot(2,2,3),imshow(DemosImg(:,:,:,3)),title('RGB image for polarization of 90°')
subplot(2,2,4),imshow(DemosImg(:,:,:,4)),title('RGB image for polarization of 135°')

%% Save result
if Save == true
    save([folder_path1 Save_name],'DemosImg','-v7.3');
end

