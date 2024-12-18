function L = aproxL(InputQ)
%APROXL aproximate a best fitting 4D subspace of InputQ
%   InputQ is a NxMx2 matrix where N is the number of features, M is the
%   number of frames, and 2 is x and y image coords. L is the best fitting
%   subspace of InputQ that is 4D. 

% get sizes
[numFeatures, numFrames, dimentions] = size(InputQ);

% initialize variables
N = nan(numFeatures,1);
N_i = 1;

for i = 1:numFrames
 for j = (i+1):numFrames
%      disp("Frame " + int2str(i) + " and " + int2str(j));
    
%      Get the two frames to combine
    frameI = InputQ(:,i,:);
    frameJ = InputQ(:,j,:);
    
%     reshape them to remove unneeded dimention
    frameI = reshape(frameI, [numFeatures dimentions]);
    frameJ = reshape(frameJ, [numFeatures dimentions]);
    
%     only select rows that have no NaN entries
    validRowsI = ~isnan(frameI(:,1));
    validRowsJ = ~isnan(frameJ(:,1));
    validRows = 1:numFeatures;
    validRows = validRows .* validRowsI' .* validRowsJ';
    validRows = find(validRows);
    
%     get these rows from both frames
    frameI = frameI(validRows, :);
    frameJ = frameJ(validRows, :);
    
%     combine frames with offset for translation 
    offset = ones(size(frameI, 1), 1);
    combinedFrames = [offset frameI frameJ];

%     Check for sufficient data
    if size(combinedFrames, 1) <= 4
       continue; 
    end
    
%     Force to rank 4
    [U, W, V] = svd(combinedFrames);
    W(5,5) = 0;
    combinedFrames = U * W * V';
    
%     get the complementary subspace of Combined Frames
    nullSpace = null(combinedFrames');
    
%     Padd with the missing data
    paddedN = zeros(numFeatures, size(nullSpace, 2));
    for fillPad = 1:size(combinedFrames, 1)
        insertionRow = validRows(fillPad);
        paddedN(insertionRow, :) = nullSpace(fillPad, :);
    end
    
%     add to N
    for k = 1:size(paddedN,2)
        N(:, N_i) = paddedN(:, k);
        N_i = N_i + 1;
    end
    
 end
end

% Get the Orthonormal Complement of N, which is the Null Space of N
% transposed
[~, ~, V] = svd(N');

% get the last 4 columns of V representing the 4D null space. 
L = V(:, end-3:end);
% lastCol = L(:, 4);
% L = L ./ lastCol;

end

