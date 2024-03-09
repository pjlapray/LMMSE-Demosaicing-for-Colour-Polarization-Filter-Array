function [DemosImg] = Function_LMMSE_Demosaicing(MosImg,D)
% This function demosaic a CPFA image with pre-trained LMMSE algorithm
% References : 1-"Spote A, Lapray PJ, Thomas JB, Farup I. Joint demosaicing of
%              colour and polarisation from filter arrays.
%              In 29th Color and Imaging Conference Final Program and Proceedings 2021.
%              Society for Imaging Science and Technology."
%              2- "Dumoulin R, Lapray P.-J., Thomas J.-B., (2022), Impact of training data on
%              LMMSE demosaicing for Colour-Polarization Filter Array,  16th International Conference on Signal-Image Technology & Internet-Based Systems (SITIS),
%              2022, Dijon, France.

%% Sizes definition
height = 4;                              % height of the superpixel
width = 4;                               % width of the superpixel
nh = 10;                                 % number of neighbors per column (this code is valid only for 10x10 neighborhood, including the 4x4 initial pattern surrounded by 3 columns at left and 3 colums at right)
nw= 10;                                  % number of neighbors per line
P = 12;                                  % number of color-pola channels
[rows, cols, ~] = size(MosImg);
r_superpix = rows/height;                % number of superpixel in a line
c_superpix = cols/width;                 % number of superpixel in a column

%% Demosaicing
fun = @(x) (reshape(D*x.data(:),4,4,12));
DemosImg = reshape(blockproc(MosImg,[4,4],fun,BorderSize=[3 3],TrimBorder=false,UseParallel =true),[r_superpix*height c_superpix*width 3 4]);
end

