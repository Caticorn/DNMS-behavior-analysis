function plotTime_DNMS_1_distractor( timeMat,dataName)
% visualize time mat
% only for DNMS task 
% created by Zou Shimin on 18th Dec. 2017
%% set the format
fontSize=20;
legendSize = 16;
fontName=('Arial');
lineWidth=2;
figName=strrep(dataName,'_','\_');

phaseColor = {[160 159 158]/255,[255 201 0]/255,[94 165 191]/255,[255 201 0]/255,[102 101 108]/255,[68 68 70]/255};
phaseMat = timeMat(:,2:7);
phaseName = {'Sample phase','1st Delay duration','Distractor phase','2nd Delay duration','Choice phase (before decision)','Choice phase (after decision)'};

%% phase analysis of each trial
timeBar = bar(phaseMat,'stacked','EdgeColor','none');
barCh = get(timeBar,'children');
for i = 1:length(phaseMat(1,:))
    timeBar(i).FaceColor = phaseColor{i}; %matlab2017
    %set(barCh{i},'facecolor',phaseColor{i},'EdgeColor',phaseColor{i});%matlab2014a
end
ylabel('Time(s)','FontName',fontName,'FontSize',fontSize);
xlabel('Trials','FontName',fontName,'FontSize',fontSize);
xlim([0.6 length(phaseMat(:,1))+0.4]);
legend([barCh{1} barCh{2} barCh{3} barCh{4} barCh{5} barCh{6}],phaseName,'Location','Best');
legend('boxoff');
title(figName,'FontName',fontName,'FontSize',fontSize);
box('off');

set(gca,'LineWidth',lineWidth,'FontSize',legendSize,'FontName',fontName);

end

