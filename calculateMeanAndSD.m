function [ meanPerf,sdPerf ] = calculateMeanAndSD( allPerf )
%to calculate mean and STE
%   Detailed explanation goes here
 meanPerf=mean(allPerf);
 sdPerf=std(allPerf)/sqrt(length(allPerf));
 meanPerf=meanPerf';
 sdPerf=sdPerf';

end

