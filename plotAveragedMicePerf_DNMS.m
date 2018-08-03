function plotAveragedMicePerf_DNMS( meanPerf, sdPerf,trainingDay,expName,miceNo,ifType)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%% format info
markerSize=8;
fontSize=20;
legendSize = 16;
fontName=('Arial');
lineWidth=4;
name =[expName '(n=' num2str(miceNo) ')'];
typeColor = {[0 0 0],[29 127 140]/255,[195 103 66]/255};

%% performance of all trial& trial types

typeName = {'1-4','4-1'};
note = 'Sample-Choice';
   
%% plot
if ifType == 0
    i = 1;
    errorbar(1:trainingDay, meanPerf(i,:),sdPerf(i,:),'LineWidth',lineWidth,'MarkerFaceColor',typeColor{i},'MarkerEdgeColor',typeColor{i},'MarkerSize',markerSize,'Marker','o','Color',typeColor{i});
    hold on;
elseif ifType == 1
    for i = 2:length(meanPerf(:,1))
        errorbar(1:trainingDay, meanPerf(i,:),sdPerf(i,:),'LineWidth',lineWidth,'MarkerFaceColor',typeColor{i},'MarkerEdgeColor',typeColor{i},'MarkerSize',markerSize,'Marker','o','Color',typeColor{i});
        hold on;
    end
    lgd = legend(typeName,'Location','best'); %matlab2017
    title(lgd,note); %matlab2017
    legend('boxoff');
end
hold on;
ylim([0 110]);ylabel('Performance (%)','FontSize',fontSize,'FontName',fontName);
xlim([0.6 trainingDay+0.4]); xlabel('Training days','FontSize',fontSize,'FontName',fontName);
set(gca,'YTick',0:20:100);
set(gca,'XTick',1:trainingDay);
set(gca,'LineWidth',lineWidth,'FontSize',legendSize,'FontName',fontName);
title(name,'FontName',fontName,'FontSize',fontSize);



box('off');
set(gcf,'unit','centimeters','position',[10 5 14 10]);
end

