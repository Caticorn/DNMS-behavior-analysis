function [ performance ] = calculatePerformance( trialMat )
%Calculate performance
%   created by Shimin on 7th May, 2018
performance = 100*length(find(trialMat(:,3)==7))/length(trialMat(:,1));

end

