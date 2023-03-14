%% Compute the Demosaicking Matrix of the LMMSE method
% Input :
%   - FullDataset/MosDataset : dataset of images full resolution and mosaicked
% Output :
%   - D : demosaicking matrix
%   - y : unfolding of the non-mosaicked images by superpixel of size 4x4
%   - y1 : unfolding of the non-mosaicked images by neighborhood of size
%          100x100
%
function [DemosDataset, y1, y, D] = D_matrix(FullDataset, MosDataset, folder_path)

% -------------------------------------------------------------------------
%                    Compute the Demosaicking Matrix
% -------------------------------------------------------------------------

%% Setting parameters
% Sizes definition
height = 4;                                 % height of the superpixel
width = 4;                                 % width of the superpixel
nh = 10;                               % number of neighbors per column
nw= 10;                                % number of neighbors per line
P = 12;                                % number of color-pola channels
[rows, cols, ~] = size(FullDataset{1,2});
r_superpix = (rows/height);                % number of superpixel in a line
c_superpix = (cols/width);                % number of superpixel in a column
Len = size(FullDataset,1);                 % number of images in the database

disp('Parameters set');


%%  Compute y1 for all images of the database
y1 =  cell(Len, 2);
for d = 1:Len
    im_nbr = d
    y1{d,1}=FullDataset{d,1};
    y_per_img = zeros(P*nh*nw, r_superpix*c_superpix);
    y_per_img3(:,:,:,:)=zeros(nh*nw,P,r_superpix-2,c_superpix-2);

    % reshape image dataset for simplicity
    matrix = cat(3, FullDataset{d,2}, FullDataset{d,3}, FullDataset{d,4}, FullDataset{d,5});
    matrix = reshape(matrix, rows, cols, P);

    % Compute the column vector for each superpixel
    for i=1:P
        fun = @(x) (reshape(x.data(:),1,1,nw*nh));
        y_per_img2(:,i,:,:) = permute(blockproc(matrix(1:end,1:end,i),[4,4],fun,BorderSize=[3 3],TrimBorder=false,UseParallel =true),[3 1 2]);
    end
    y_per_img3(:,:,:,:)=y_per_img2(:,:,2:r_superpix-1,2:c_superpix-1);
    y1{d,2} =  reshape(y_per_img3,nw*nh*P,(r_superpix-2)*(c_superpix-2));
end

clear FullDataset
disp('y1 computed');

%% Compute the auto-correlation R
Y = zeros(P*nh*nw, P*nh*nw);
for b = 1:Len
    im_nbr = b
    A = y1{b,2};
    Y=Y+A*A';
end
R = Y/(Len*r_superpix*c_superpix);

clear Y A
disp('R computed');

%% Compute S1
block_16x100 = zeros( height*width, nh*nw );
block_4x4 = diag([1,1,1,1]);

s=0;
for d = 4:7
    s=s+1;
    block_16x100( (s-1)*4+1:4*s, (d-1)*10+4:(d-1)*10+7) = block_4x4;
end
S1 = blkdiag(block_16x100,block_16x100,block_16x100,block_16x100,block_16x100,block_16x100,block_16x100,block_16x100,block_16x100,block_16x100,block_16x100,block_16x100);

clear block_16x100 block_4x4 s
disp('S1 computed');

%% Compute y
y = zeros( P*height*width, (r_superpix-2)*(c_superpix-2), Len );
for f = 1:Len
    y(:,:,f) = S1*y1{f,2};
end
disp('y computed');

%% Compute M1
M1 = zeros(nh*nw, P*nh*nw);
% Define places of pixels in y1
a1 = [600, 400, 700, 300];
a2 = [600, 400];
b1 = [1000, 200, 1100, 100];
b2 = [1000, 200];
c1 = [700, 500, 800, 400];
c2 = [700, 500];
d1 = [900, 100, 1000, 0];
d2 = [900, 100];

column1 = [a1, a1, a2];
column2 = [b1, b1, b2];
column3 = [c1, c1, c2];
column4 = [d1, d1, d2];

% Don't touch y if you don't have the notes which define it
vec = [column1, column2, column3, column4, column1, column2, column3, column4, column1, column2,];

for e = 1:nh*nw
    vec(1, e) = vec(1, e)+ e;
    M1(e, vec(1,e)) = 1;
end

var = {'a1','a2', 'b1', 'b2', 'c1', 'c2', 'd1', 'd2', 'column1', 'column2', 'column3','column4', 'vec'};
clear var vec;

disp('M1 computed');

%% Compute D matrix
D = S1*R*M1'/(M1*R*M1'); % / indicate inv() function
clear M1 S1 R
disp('D computed');

% ----------------------------------------------------------------------- %
%                    Apply the Demosaicking Matrix
% ----------------------------------------------------------------------- %
for f = 1:Len
    im_nbr = f

    % loop over the dataset
    fun = @(x) (reshape(D*x.data(:),4,4,12));
    DemosImg = reshape(blockproc(MosDataset{f,2},[4,4],fun,BorderSize=[3 3],TrimBorder=false,UseParallel =true),[r_superpix*height c_superpix*width 3 4]);
    DemosDataset(f, 2:5) = {DemosImg(:,:,:,1), DemosImg(:,:,:,2), DemosImg(:,:,:,3), DemosImg(:,:,:,4)};
end
disp('Demosaicing of the dataset done computed');
end
