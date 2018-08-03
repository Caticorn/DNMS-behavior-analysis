function plotMouseArmTypePerf_DNMS_variedDelay( mouseDelayS1DailyPerf, mouseDelayS4DailyPerf,trainingDay, dataName)
%Arm bias analysis
%   To check performance difference between 1-4 and 4-1 trials
%   created by Shimin Zou on 30th May, 2018
    %% change format parameters here
    markerSize=8;
    fontSize=20;
    axisSize = 14;
    legendSize = 16;
    fontName=('Arial');
    lineWidth=4;
    figName=strrep(dataName,'_','\_');

    typeColor = {[162 206 225]/255,[94 165 191]/255,[13 71 97]/255};
    typeName = {'5s','30s','60s'};

    %% first subplot: Arm1-Arm4
    ax1 = subplot(1,2,1);
    for iter = 1:3
         plot(mouseDelayS1DailyPerf(iter,:),'LineWidth',lineWidth,'MarkerFaceColor',typeColor{iter},'MarkerEdgeColor',typeColor{iter},'MarkerSize',markerSize,'Marker','o','Color',typeColor{iter});
         hold on;
    end
    title(ax1, 'Arm1-Arm4');
    % ax1.FontSize = axisSize;
    % ax1.LineWidth = lineWidth;
    xlabel('Training (day)','FontName',fontName,'FontSize',axisSize);
    ylabel('Performance (%)','FontName',fontName,'FontSize',axisSize);
    set(gca,'YTick',0:20:100);
    axis([0.6 trainingDay+0.4 0 110]);
    lgd = legend(typeName,'Location','SouthEast'); 
    title(lgd,'Delay Duration'); 
    legend('boxoff');
    %box off;
    %% second subplot: Arm4-Arm1
    ax2 = subplot(1,2,2);
    for iter = 1:3
         plot(mouseDelayS4DailyPerf(iter,:),'LineWidth',lineWidth,'MarkerFaceColor',typeColor{iter},'MarkerEdgeColor',typeColor{iter},'MarkerSize',markerSize,'Marker','o','Color',typeColor{iter});
         hold on;
    end
    title(ax2, 'Arm4-Arm1');
    xlabel('Training (day)','FontName',fontName,'FontSize',axisSize);
    ylabel('Performance (%)','FontName',fontName,'FontSize',axisSize);
    set(gca,'YTick',0:20:100);
    axis([0.6 trainingDay+0.4 0 110]);
    lgd = legend(typeName,'Location','SouthEast'); 
    title(lgd,'Delay Duration'); 
    legend('boxoff');
    set(gcf,'unit','centimeters','position',[10 5 14 10]);
end

