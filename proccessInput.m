function [returnInputQ, emptyIndices] = proccessInput(InputQ, noise_std, removeDataNum)
%ProccessInput does the basic proccessing needed to adjust real data to
%acceptable test data
%   InputQ is an NxMx2 matrix where N is the number of features, M is the
%   number of frames, and the 2 is x and y image coordinates. noise_std is
%   the standard deviation of noise to use removeDataNum is the number of 
%   datamoves. returnInputQ is the amount of data to remove. inputQ with 
%   the noise and removing all unneeded rows. emptyIndices is a list of all
%   those unneeded indices.

% Remove NaNs
filler = InputQ;
filler(isnan(filler)) = 0;

% Center Data
Mean = sum(filler, "all") / (size(InputQ, 1) * size(InputQ, 2));
InputQ = InputQ - Mean;

% Adjust Scale
Max = max(InputQ(:));
Min = min(InputQ(:));
MaxDist = max([Max, -Min]);
InputQ = (InputQ .* 100) ./ MaxDist;

% Remove Data
[dem1, dem2, ~] = size(InputQ);
randomIndicies = randperm(dem1*dem2, removeDataNum);
InputQ(randomIndicies) = NaN;
InputQ(randomIndicies + dem1*dem2) = NaN;

% Noise average offset
noise_mean = 0;

% noise matrix
noise = noise_std * randn(size(InputQ)) + noise_mean;

% new matrix
returnInputQ = InputQ + noise; 

% get any indicies where the rows are all NaN
emptyIndices = find(all(isnan(InputQ(:,:,1)), 2));

% remove these rows
returnInputQ(emptyIndices, :, :) = [];

end

