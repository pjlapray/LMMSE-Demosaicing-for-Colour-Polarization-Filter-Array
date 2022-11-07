% Function that converts the input dataset in an output which is used in
% main to mosaiced the images.
%%
function Dataset = Load_Dataset(Save, folder)

% ---------------------------------------------------------------------
% All images are load as double.
% This code is adapted to read and extract data from
% DataQiuLaprayResizedVariable.mat and Monno dataset.
% ---------------------------------------------------------------------
% The return dataset contains images like :
% name  RGB_img_0  RGB_img_45  RGB_img_90  RGB_img_135
% ---------------------------------------------------------------------

path = [folder];
filename = dir(path);
Dataset = cell((length(filename)-2), 5);
filenames = natsortfiles(filename);
for k = 2:length(filename)-1
    img_0 = im2double(imread([path, filenames(k).name,'/0_' num2str(k-1) '.png']));
    img_45 = im2double(imread([path, filenames(k).name,'/45_' num2str(k-1) '.png']));
    img_90 = im2double(imread([path, filenames(k).name,'/90_' num2str(k-1) '.png']));
    img_135 = im2double(imread([path, filenames(k).name,'/135_' num2str(k-1) '.png']));

    Dataset(k-1, 1:5) = {filenames(k).name, img_0, img_45, img_90, img_135};
end
if Save == true
    save(['Data/FullDataset.mat'], 'Dataset', '-v7.3');
end

disp('Dataset loaded');
disp('---------------------------------------------------');
end
