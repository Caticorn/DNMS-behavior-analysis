function plotPerf_DNMS_variedDelay(perfPerBlock,typePerfPerBlock,delayPerfPerBlock,dataName,ifDaily,ifType)
%for daily performance analysis
% change typeColor and typeName when trial types modified
%created by Zou Shimin on 18 Dec. 2017
%modified by Zou Shimin on 18 May 2018
%% change format parameters here
markerSize=8;
fontSize=20;
legendSize = 16;
fontName=('Arial');
lineWidth=4;
figName=strrep(dataName,'_','\_');
if ifDaily == 1
    xLabelName = 'Training ( Block )';
elseif ifDaily == 0
    xLabelName = 'Training ( Day )';
end
%% performance of all trial& trial types

blockMat = [perfPerBlock,typePerfPerBlock,delayPerfPerBlock];
blockMat = blockMat';
typeColor = {[0 0 0],[29 127 140]/255,[195 103 66]/255,[162 206 225]/255,[94 165 191]/255,[13 71 97]/255};
blockNumber = length(perfPerBlock);
typeName = {'arm1-arm4','arm4-arm1','5s','30s','60s'};
%note = 'Delay Duration';

%% plot daily learning curve
switch ifType
    case 0 % all trials
       iter = 1;
       plot(blockMat(iter,:),'LineWidth',lineWidth,'MarkerFaceColor',typeColor{iter},'MarkerEdgeColor',typeColor{iter},'MarkerSize',markerSize,'Marker','o','Color',typeColor{iter});
       hold on;
    case 1 % arm1-arm4, arm4-arm1
       for iter = 2:3
           plot(blockMat(iter,:),'LineWidth',lineWidth,'MarkerFaceColor',typeColor{iter},'MarkerEdgeColor',typeColor{iter},'MarkerSize',markerSize,'Marker','o','Color',typeColor{iter});
           hold on;
       end 
       lgd = legend(typeName{1,1:2},'Location','Best'); %matlab2017
       title(lgd,'Sample-Choice'); %matlab2017
       legend('boxoff');
    case 2 %varied delay: 5s, 30s, 60s
       for iter = 4:6
           plot(blockMat(iter,:),'LineWidth',lineWidth,'MarkerFaceColor',typeColor{iter},'MarkerEdgeColor',typeColor{iter},'MarkerSize',markerSize,'Marker','o','Color',typeColor{iter});
           hold on;
       end 
       lgd = legend(typeName{1,3:5},'Location','Best'); %matlab2017
       title(lgd,'Delay Duration'); %matlab2017
       legend('boxoff'); 
end

ylim([0 110]);ylabel('Performance (%)','FontName',fontName,'FontSize',fontSize);
xlim([0.6 blockNumber+0.4]);
xlabel(xLabelName,'FontName',fontName,'FontSize',fontSize);

set(gca,'YTick',0:20:100);
set(gca,'XTick',1:blockNumber);

set(gca,'LineWidth',lineWidth,'FontSize',legendSize,'FontName',fontName);

title(figName,'FontName',fontName,'FontSize',fontSize);
box('off');
set(gcf,'unit','centimeters','position',[10 5 14 10]);
end

