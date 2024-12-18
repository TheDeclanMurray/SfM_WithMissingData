function shapeMatrix = SfM(Q, colors)
%SfM construct the shape matrix using the structure from motion algorithm 
% and display a point cloud of the created data.
%   Q is an NxMx2 matrix where N is the number of features, M is the number
%   of frames, and 2 is the x and y coords. Colors is a Nx3 matrix of the
%   color of each feature.

% reformat Q
[height, width, length] = size(Q);
sizeQ = [height, width*length];
framePoints = ones(sizeQ);
framePoints(:, 1:width) = Q(:,:,1);
framePoints(:, width+1:end) = Q(:,:,2);
framePoints = framePoints';

% mean for the centroid
mean = sum(framePoints, 2) / size(framePoints, 2);
centroid = framePoints - mean;

% break into components 
[~, W, V] = svd(centroid, "econ");

% get the shape matrix
numImportantValues = 3;
W3 = W(1:numImportantValues, 1:numImportantValues);
V3 = V(:, 1:numImportantValues);
shapeMatrix = W3*V3';

% reformat the shape matrix
shapeMatrix = shapeMatrix';

% remove outliars 
dists = shapeMatrix .^ 2;
dists = abs(sum(dists, 2));
sorted = sort(dists);
quad3 = round(size(sorted, 1) * (7/8));
thresh = sorted(quad3,1);
indices = dists >= thresh;
shapeMatrix(indices, :) = [];
colors(indices, :) = [];
indices = dists <= -thresh;
shapeMatrix(indices, :) = [];
colors(indices, :) = [];

% Rescale the data
new_min_bounds = [-100 -100 -100];
new_max_bounds = [100 100 100];
min_vals = min(shapeMatrix);
max_vals = max(shapeMatrix);
rescaled_data = rescale(shapeMatrix, new_min_bounds, new_max_bounds, 'InputMin', min_vals, "InputMax", max_vals);

% display the shape matrix data
figure;
pt = pointCloud(rescaled_data);
pt.Color = uint8(colors);
pcshow(pt, "MarkerSize", 40);
title("SfM Reconstruction");
xlabel("x");
ylabel("y");
zlabel("z");

end

