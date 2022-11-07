%% Filtering using Spectro-polarimetric Quad Bayer filter

function [SPQBf2] = Filter(images)

    [rows, columns, ~] = size(images);

    %% Creation of the spectro-pola quad bayer filter
    pattern = [[1 4 ; 10 7] [2 5; 11 8] ; [2 5; 11 8] [3 6 ; 12 9]];
    [x, y] = size(pattern);
    n = length(unique(pattern));
    mosaic = repmat(pattern, rows/x, columns/y);
    
    mask = zeros(rows, columns, n);
    for i = 1:n
        mask(:,:,i) = (mosaic==i);
    end
    
    %% Filtering
    B = zeros(rows,columns,12);
    for i=1:12
        B(1:rows, 1:columns, i) = images(1:rows, 1:columns, i).*mask(1:rows, 1:columns, i);
    end
    
    SPQBf2 = double(sum(B, 3));

    % The resulting image has one dimension : 1024 x 1024 x 1 with pattern
    % R0    R45  G0    G45
    % R135  R90  G135  G90
    % G0    G45  B0    B45
    % G135  G90  B135  B90
end