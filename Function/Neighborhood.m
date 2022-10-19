% Extract a constant neighborhood of 10x10 pixels into a column vector of superpixel
% at coordinates (i,j) for all the P channels.

% Input :
%   - matrix : The matrix in which you want to take the neighbors:
%   - i,j : The coordinates of the first left top pixel inside the
%   superpixel;
%   - nh, nw : The number of pixel in a row, column of the constant neighborhood.

%  /!\ Only created for square superpixels


function a2 = Neighborhood( matrix, i, j, nh ,nw)

[~,~, P] = size(matrix);
a2 = zeros(nh*nw*P,1);

if P > 1
    for q = 1:P % loop over all color/pola channels
        voisin = matrix( i-3:i+6 , j-3:j+6, q);
        a2(nh*nw*(q-1)+1:nh*nw*q, 1)= im2col(voisin,[nh nw],'distinct');
    end
elseif P == 1
    voisins = matrix( i-3:i+6 , j-3:j+6);
    a2 = im2col(voisins, [nh,nw]);
end
end
