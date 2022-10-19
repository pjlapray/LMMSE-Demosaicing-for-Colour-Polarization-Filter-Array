%% Compute the Demosaicking Matrix of the LMMSE method

% This code is constructed using the informations in the article from :
% P.Amba, J.Dias, D.Alleysson , "Random CFAs are better than regular ones".
% Journal of Imaging Science and Technology, Society for Imaging Science
% and Technology, 2016. hal-01398196

% The notation used in this code respect that one of this article

% Input :
%   - Dataset : dataset of images not yet mosaicked

% Output :
%   - D : demosaicking matrix
%   - y : unfolding of the non-mosaicked images by superpixel of size 4x4
%   - y1 : unfolding of the non-mosaicked images by neighborhood of size
%          100x100


function [DemosDataset] = LMMSE_demosaicing(D, test_img)
% -------------------------------------------------------------------------
%                    Compute the Demosaicking Matrix
% -------------------------------------------------------------------------


%% Setting parameters
%numb_img_pack = 10;
% Sizes definition
height = 4;                                 % height of the superpixel
width = 4;                                 % width of the superpixel
nh = 10;                               % number of neighbors per column
nw= 10;                                % number of neighbors per line
P = 12;                                % number of color-pola channels

% Number of superpixel used ( < total number of superpixel )
[rows, cols, ~] = size(test_img);
r_superpix = (rows/height)-2;               % number of superpixel in a line
c_superpix = (cols/width)-2;                % number of superpixel in a column

disp('Parameters ok');

% ----------------------------------------------------------------------- %
%                    Apply the Demosaicking Matrix
% ----------------------------------------------------------------------- %


%% Compute x1
x1 = zeros(nh*nw, r_superpix*c_superpix, 1);

matrix = test_img;
s=0;
for n = 1:c_superpix              % loop over superpixel column
    for p = 1:r_superpix          % loop over superpixel line
        s=s+1;
        x1(:, s, 1) = Neighborhood(matrix, 4*p+1, 4*n+1 , nh, nw);
    end
end
disp('x1 computed');

%% compute y_estimate
y_estimate = zeros(P*height*width, r_superpix*c_superpix, 1);
for q = 1:size(x1,3)
    y_estimate(:,:,q) = D*x1(:,:,q);
end

clear x1

disp('y_estmate computed');
% ----------------------------------------------------------------------- %
%                          Reconstruct images
% ----------------------------------------------------------------------- %

for u = 1:P
    % Reconstruction of demosaicked images
    y_P = y_estimate(height*width*(u-1)+1:height*width*u,:);
    img_estimate(:,:,u) = col2im(y_P, [height width], [r_superpix*height c_superpix*width],'distinct');

end
img_estimate = reshape(img_estimate,[r_superpix*height c_superpix*width 3 4]);
DemosDataset = cat(4,img_estimate(:,:,:,1), img_estimate(:,:,:,2), img_estimate(:,:,:,3), img_estimate(:,:,:,4));

clear y_estimate
disp('end Demosaicing');
end



