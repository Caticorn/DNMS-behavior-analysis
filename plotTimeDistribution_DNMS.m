function  [timeDistribution] = plotTimeDistribution_DNMS(timeMat)
% only for DNMS task 
% created by Zou Shimin on 18th Dec. 2017
%% set the format
fontSize=12;
fontName=('Arial');
%lineWidth=2;
% figName=strrep(dataName,'_','\_');

phaseMat = [timeMat(:,2),(timeMat(:,4) + timeMat(:,5)),timeMat(:,1)];%sample,choice,entire trial
phaseName = {'Sample phase','Choice phase','Entire trial'};

color = {[160 159 158]/255,[102 101 108]/255,[68 68 70]/255};
timeDistribution = zeros(3,3);
for iter = 1:3
    phase = phaseMat(:,iter);
    if iter < 3
        subplot(2,2,iter);
        hist(phase,1000);
        title(phaseName{iter},'FontSize',fontSize,'FontName',fontName);
        h = findobj(gca,'Type','Patch');
        set(h,'FaceColor',color{iter},'EdgeColor',color{iter});
        ylabel('Number of Trials','FontSize',fontSize,'FontName',fontName);
        xlabel('Time(s)','FontSize',fontSize,'FontName',fontName);
    elseif iter == 3
        subplot(2,2,[3,4]);
        hist(phase,1000);
        title(phaseName{iter},'FontSize',fontSize,'FontName',fontName);
        h = findobj(gca,'Type','Patch');
        set(h,'FaceColor',color{iter},'EdgeColor',color{iter});
        ylabel('Number of Trials','FontSize',fontSize,'FontName',fontName);
        xlabel('Time(s)','FontSize',fontSize,'FontName',fontName);
    end
end
[frequency,val]=hist(phase,1000);
[maxFre,peakIndex] = max(frequency);
timeDistribution(1,iter) = val(1,peakIndex);% peak
sortedPhase = sort(phase(:,1),'ascend');
timeDistribution(2,iter) = sortedPhase(floor(0.7*(length(sortedPhase))),1); % 1st row, the threshold of top 70%
timeDistribution(3,iter) = sortedPhase(floor(0.8*(length(sortedPhase))),1);% 2nd row, the threshold of top 80%

end

