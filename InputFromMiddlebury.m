function [imgs, realQ, pointColors] = InputFromMiddlebury()
%InputFromMiddlebury takes in the middlebury stereo dataset and gets the
%real values for Q
%   realQ is an NxMx2 matrix where N is the number of features M is the 
%   number of frames, and the 2 represents x and y image coord values. imgs
%   are the frames. pointColors is an Nx3 matrix of colors for each
%   feature.

% Get the colors and images
im1Color = imread("/home/weinman/courses/CSC262/images/view1.png");
im1 = im2double(im2gray(imread("/home/weinman/courses/CSC262/images/view1.png")));
im2 = im2double(im2gray(imread("/home/weinman/courses/CSC262/images/view5.png")));

% Get the groud truth disparities 
disp = double(imread("/home/weinman/courses/CSC262/images/truedisp.png"));

% Downsample By a factor of
downSampleBy = 4;

% downsample images and disparities 
im1Color = im1Color(1:downSampleBy:end, 1:downSampleBy:end, :);
imgs = im1(1:downSampleBy:end, 1:downSampleBy:end);
imgs(:,:,2) = im2(1:downSampleBy:end, 1:downSampleBy:end);
disp = disp(1:downSampleBy:end, 1:downSampleBy:end);

% set disparities to NaN
disp(disp == 0) = NaN;

% Initialize variables
realQ = zeros(1, 2, 2);
colors = zeros(3,1);
featureNum = 1;
[height, width] = size(disp);

% loop though each row
for x = 1:width
    % loop though each column
    for y = 1:height
        
        % If there is a feature match
        if ~(isnan(disp(y,x)))
            
            % save the two x components
            realQ(featureNum, :, 1) = [x disp(y,x)];
            
            % save the two y components
            realQ(featureNum, :, 2) = [y y];
            
            % save the color
            colors(:,featureNum) = im1Color(y,x,:);
            
            % increment feature number
            featureNum = featureNum + 1;
        end
    end
end

% transpose colors
pointColors = colors';

end