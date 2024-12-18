
if exist("InputQ", "var") == 0
    % [imgs,realQ, pointColors, all3Dpoints] = InputFromRathaus();
    [imgs, realQ, pointColors] = InputFromMiddlebury();
            
    % add noise
    noise_std = 0.0;
    
    % Remove Data
    removeDataNum = 0;
    
    % Proccess Input
    [InputQ, emptyIndices] = proccessInput(realQ, noise_std, removeDataNum);
    pointColors(emptyIndices, :) = [];  % Remove Colors
    % all3Dpoints(emptyIndices, :) = []; % Remove 3D points
    
    % aproximate L, the subspace we mapping InputQ into
    L = aproxL(InputQ);
    
    % aproximate Q using L
    OutputQ = aproxOutputQ(InputQ, L);
end


shapeMatrix = SfM(OutputQ, pointColors);

% Get RMSE

% controledReal = (all3Dpoints / median(all3Dpoints(:)));
% controledSM = (shapeMatrix / median(shapeMatrix(:)));

% diff =  controledReal - controledSM;
% root = diff .* diff;
% total = sum(root, "all");
% RMSE = sqrt(total);
