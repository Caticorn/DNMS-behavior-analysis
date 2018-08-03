function plotGroupedMicePerf_variedDelay(gPerf,gMean,gSD,expName, groupNo,groupName,delayType,trainingDay,ifType)
% For plotting group averaged curve
%   Created by Simin Zou on 18th Mar. 2018
    markerSize=8;
    fontSize=20;
    legendSize = 16;
    fontName=('Arial');
    lineWidth=4;

    groupColor = {[44,44,44]/255,[255,95,95]/255;[44,44,44]/255,[162 206 225]/255;[44,44,44]/255,[94 165 191]/255;[44,44,44]/255,[13 71 97]/255};
    groupInfo = cell(1,groupNo);
    
    typeName = cell(1,length(delayType));
    for delayIndex = 1: length(delayType)
        typeName{1,delayIndex} = num2str(delayType(delayIndex,1));
    end

    if ifType == 0 %all trials
        for groupID = 1:groupNo
            groupData = gPerf{1,groupID};
            miceNo = length(groupData(:,1));
            groupInfo{1,groupID} = [groupName{1,groupID} ' (n=' num2str(miceNo) ')'];
            groupMean = gMean{1,groupID}';
            groupSD = gSD{1,groupID}';
            errorbar(1:trainingDay, groupMean,groupSD,'LineWidth',lineWidth,'MarkerFaceColor',groupColor{1,groupID},'MarkerEdgeColor',groupColor{1,groupID},'MarkerSize',markerSize,'Marker','o','Color',groupColor{1,groupID});
            hold on;
        end

        ylim([0 110]);ylabel('Performance (%)','FontSize',fontSize,'FontName',fontName);
        xlim([0.6 trainingDay+0.4]); xlabel('Training days','FontSize',fontSize,'FontName',fontName);
        set(gca,'YTick',0:20:100);
        set(gca,'XTick',1:trainingDay);
        set(gca,'LineWidth',lineWidth,'FontSize',legendSize,'FontName',fontName);
        title(expName,'FontName',fontName,'FontSize',fontSize);

        legend(groupInfo,'Location','Best'); %matlab2017
        legend('boxoff');

        box('off');

    elseif ifType == 1
        for typeIndex = 1:3 % delay duration
            subplot(1,3,typeIndex);
            for groupID = 1:groupNo
                groupData = gPerf{(typeIndex+1),groupID};
                miceNo = length(groupData(:,1));
                groupInfo{1,groupID} = [groupName{1,groupID} ' (n=' num2str(miceNo) ')'];
                groupMean = gMean{(typeIndex+1),groupID}';
                groupSD = gSD{(typeIndex+1),groupID}';
                errorbar(1:trainingDay, groupMean,groupSD,'LineWidth',lineWidth,'MarkerFaceColor',groupColor{(typeIndex+1),groupID},'MarkerEdgeColor',groupColor{(typeIndex+1),groupID},'MarkerSize',markerSize,'Marker','o','Color',groupColor{(typeIndex+1),groupID});
                hold on;
            end
            ylim([0 110]);ylabel('Performance (%)','FontSize',fontSize,'FontName',fontName);
            xlim([0.6 trainingDay+0.4]); xlabel('Training days','FontSize',fontSize,'FontName',fontName);
            set(gca,'YTick',0:20:100);
            set(gca,'XTick',1:trainingDay);
            set(gca,'LineWidth',lineWidth,'FontSize',legendSize,'FontName',fontName);
            title(typeName{1,typeIndex},'FontName',fontName,'FontSize',fontSize);

            legend(groupInfo,'Location','Best'); %matlab2017
            legend('boxoff');

            box('off');
        end
    end
end

