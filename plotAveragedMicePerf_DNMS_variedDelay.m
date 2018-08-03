function plotAveragedMicePerf_DNMS_variedDelay( meanPerf, sdPerf,trainingDay,expName,miceNo,delayType,ifType)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%% format info
markerSize=8;
fontSize=20;
legendSize = 16;
fontName=('Arial');
lineWidth=4;
name =[expName '(n=' num2str(miceNo) ')'];
typeColor = {[0 0 0],[29 127 140]/255,[195 103 66]/255,[162 206 225]/255,[94 165 191]/255,[13 71 97]/255};

%% performance of all trial& trial types
typeName = cell(1,length(delayType));
for delayIndex = 1: length(delayType)
    typeName{1,delayIndex} = num2str(delayType(delayIndex,1));
end
note = 'Delay Duration (s)';
   
%% plot
switch ifType
    case 0 % all trials
        i = 1;
        errorbar(1:trainingDay, meanPerf(i,:),sdPerf(i,:),'LineWidth',lineWidth,'MarkerFaceColor',typeColor{i},'MarkerEdgeColor',typeColor{i},'MarkerSize',markerSize,'Marker','o','Color',typeColor{i});
        hold on;
    case 1 % arm1-arm4, arm4-arm1
        for i = 2:3
            errorbar(1:trainingDay, meanPerf(i,:),sdPerf(i,:),'LineWidth',lineWidth,'MarkerFaceColor',typeColor{i},'MarkerEdgeColor',typeColor{i},'MarkerSize',markerSize,'Marker','o','Color',typeColor{i});
            hold on;
        end
        lgd = legend({'arm1-arm4','arm4-arm1'},'Location','best'); 
        title(lgd,'Sample-Choice'); %matlab2017
        legend('boxoff');
    case 2 % delay duration
        for i = 4:6
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

