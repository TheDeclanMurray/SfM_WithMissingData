function OutputQ = aproxOutputQ(InputQ, L)
%APROXOUTPUTQ returns an aproximate Q which replaces each column of InputQ 
%and finds the nearest point in L space to it.
%   InputQ is an NxMx2 matrix where N is the number of features M is the 
%   number of frames, and the 2 represents x and y image coord values. L is
%   an Nx4 matrix that is the smallest rank 4 subspace of InputQ. OutputQ
%   is the best fitting point of L space to each column of InputQ.

% Create the OutputQ variable of appropriate sie 
OutputQ = nan(size(InputQ));

% Loop though each frame
for i = 1:size(InputQ, 2)
   
   % get the x and y coord for each frame
   for j = 1:2
       
      % get the column of inputQ
      Q_i = InputQ(:,i,j);
      
      % get all known rows of Q_i
      [row, ~] = find(~isnan(Q_i));
      p = unique(row);
      QiP = Q_i(p);
      
      % Get the matching rows of L
      LP = L(p, :);
      
      % Psudo inverse L
      LPinv = pinv(LP);
   
      % get the clostest match and save it
      output = L * ( LPinv * QiP );
      OutputQ(:,i,j) = output;
   end
   
end


end

