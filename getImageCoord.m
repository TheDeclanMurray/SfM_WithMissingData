function [x_coord, y_coord] = getImageCoord(M, X)
%getO,ageCoords get the image coords corresponding to a real world coord
%   M is a 3x4 matrix that takes a set of real world coords to image
%   coords. X is the 1x3 set of real world coords. the return values are
%   the resulting x and y image coords. 

% padd the real world coord
paddedX = [X 1];

% matrix multiply
result = M * paddedX';

% extract relevent info
u = result(1);
v = result(2);
w = result(3);

% return the x and y coords
x_coord = u/w;
y_coord = v/w;

end

