function [imgs, InputQ, PointColors, allUnique] = InputFromRathaus()
%INPUTFROMRATHAUS Gets the hard data from Rathaus dataset and does some
%basic data manipulation to get it into a useable form
%   imgs are the set of color images/frames. InputQ is a matrix of image
%   coords for each feature in each frame. PointColors is a color for each
%   feature. allUnique is a set of all the real 3D points. 

workingDirectory = "/home/murrayde/CSC262/labs/SfM_Project";
numFrames = 4;

imgs = imread(workingDirectory+"/rathaus/rdimage.000.ppm");
imgs(:,:,:,2) = imread(workingDirectory+"/rathaus/rdimage.001.ppm");
imgs(:,:,:,3) = imread(workingDirectory+"/rathaus/rdimage.002.ppm");
imgs(:,:,:,4) = imread(workingDirectory+"/rathaus/rdimage.003.ppm");

M3Dpoints1 = readmatrix(workingDirectory+"/rathaus/rdimage.000.ppm.3Dpoints.txt");
M3Dpoints2 = readmatrix(workingDirectory+"/rathaus/rdimage.001.ppm.3Dpoints.txt");
M3Dpoints3 = readmatrix(workingDirectory+"/rathaus/rdimage.002.ppm.3Dpoints.txt");
M3Dpoints4 = readmatrix(workingDirectory+"/rathaus/rdimage.003.ppm.3Dpoints.txt");

CamInfo = readmatrix(workingDirectory+"/rathaus/rdimage.000.ppm.camera.txt");
CamInfo(:,:,2) = readmatrix(workingDirectory+"/rathaus/rdimage.001.ppm.camera.txt");
CamInfo(:,:,3) = readmatrix(workingDirectory+"/rathaus/rdimage.002.ppm.camera.txt");
CamInfo(:,:,4) = readmatrix(workingDirectory+"/rathaus/rdimage.003.ppm.camera.txt");

% Construct matrix that takes Real World Coords to Image Coords
transformationM = zeros(3,4, size(CamInfo,3));
for i = 1:size(CamInfo,3)
    K = CamInfo(1:3,:,i);
    R = CamInfo(5:7,:,i);
    t = CamInfo(8,:,i);
%     Equasion given by the dataset
    transformationM(:,:,i) = K * [R' -R' * t'];
end            col = [x, disp(y,x), y, y];


% Combine all the posible real world points
all3Dpoints = [M3Dpoints1; M3Dpoints2; M3Dpoints3; M3Dpoints4];
allUnique = unique(all3Dpoints, "rows");

% Concatinate real image points into one matrix
imageHasPoint = NaN(size(allUnique,1), 3, numFrames);
imageHasPoint(1:size(M3Dpoints1,1),:,1) = M3Dpoints1;
imageHasPoint(1:size(M3Dpoints2,1),:,2) = M3Dpoints2;
imageHasPoint(1:size(M3Dpoints3,1),:,3) = M3Dpoints3;
imageHasPoint(1:size(M3Dpoints4,1),:,4) = M3Dpoints4;

% Get constant number
numRealPoints = size(allUnique, 1);

% create the algorithm input matrix
InputQ = NaN(numRealPoints, numFrames, 2);

% Colors
PointColors = zeros(numRealPoints, 3);


% Loop though each real world point 
for i = 1:numRealPoints
    
%     get the point
    X = allUnique(i,:); 
    
%     loop thought each frame
    for j = 1: numFrames
        
%         If the real world point is in the image
        isInImage = any(ismember(imageHasPoint(:,:,j), X, "rows"));
        if isInImage
            
%             get transformation matrix
            M = transformationM(:,:,j);
%             get cooresponding image coords
            [outX, outY] = getImageCoord(M,X);
            
            % get colors
            x = round(outX);
            y = round(outY);
            color = imgs(y, x, :, j);
            PointColors(i, :) = color;
            
%             save the image coords
            InputQ(i,j,1) = outX;
            InputQ(i,j,2) = outY;
        end
    end    
end


end

