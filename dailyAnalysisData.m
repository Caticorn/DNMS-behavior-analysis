%{
this code is for analyzing daily behavioral result.of single mouse
including performance/arm preference/time etc. (for DNMS task)

run it after converting JAVA file to matrix (dailyReadRawData).
Created by :Zou Shimin
18th Mar., 2017
Modified by :Zou Shimin
29th Mar.,2017
Modified by Zou Shimin on 18th Nov. 2017
Modified by Zou Shimin on 18th Dec. 2017
Modified by Zou Shimin on 18th May, 2018
%}

clear;
%%
dayIndex = 1;%for analyzing single day data, input day index here
analysisPath = ('E:\Data analysis\201803\DNMS');%change working path here
taskType = 'DNMS';
%'Shaping','DNMS','DNMS-varied delay','DNMS with 1 distractor','DNMS with 1 distractor-varied 2nd delay'

performanceSavePath = ('E:\Data analysis\201803\figure\DNMS\perf\');
if ~exist(performanceSavePath,'dir')
    mkdir(performanceSavePath);
end
timeSavePath = ('E:\Data analysis\201803\figure\DNMS\time\');
if ~exist(timeSavePath,'dir')
    mkdir(timeSavePath);
end
timePerfSavePath = ('E:\05 Data analysis\201803\figure\DNMS\timePerf\');
if ~exist(timePerfSavePath,'dir')
    mkdir(timePerfSavePath)
end
%analysisPath=pwd;

%%
allPath=genpath(analysisPath);
splitPath=strsplit(allPath,';');
splitedPath=splitPath';
splitedPath=splitedPath(2:end-1);

%%
for mouseID =1:size(splitedPath,1)
    mousePath=splitedPath{mouseID,1};
    temp=strsplit(mousePath,'\');
    mouseName=temp{1,end};
   %% change the directory to the file of mouseID
    cd(mousePath);
   %% read raw data
    matFiles = dir('*.mat');
    if isempty(matFiles)==0
        %for day = 1:size(matFiles,1)
            File=matFiles(dayIndex,1).name;
            dataName = File(1:end-4);
            load(matFiles(dayIndex).name);
         %% single mouse performance in each training day
            switch taskType
                case{'Shaping','DNMS'}
                    plotPerf_DNMS(perfPerBlock,typePerfPerBlock,dataName,1,0);
                    saveas(gcf,[performanceSavePath,dataName '-allTrial-Performance'],'fig');
                    saveas(gcf,[performanceSavePath,dataName '-allTrial-Performance'],'png');
                    close all;
                    plotPerf_DNMS(perfPerBlock,typePerfPerBlock,dataName,1,1);
                    saveas(gcf,[performanceSavePath,dataName '-Type-Performance'],'fig');
                    saveas(gcf,[performanceSavePath,dataName '-Type-Performance'],'png');
                    close all;
                case{'DNMS-varied delay'}
                    plotPerf_DNMS_variedDelay(perfPerBlock,typePerfPerBlock,delayPerfPerBlock,dataName,1,0);
                    saveas(gcf,[performanceSavePath,dataName '-allTrial-Performance'],'fig');
                    saveas(gcf,[performanceSavePath,dataName '-allTrial-Performance'],'png');
                    close all;
                    for typeIndex = 1:2
                        plotPerf_DNMS_variedDelay(perfPerBlock,typePerfPerBlock,delayPerfPerBlock,dataName,1,typeIndex);
                        saveas(gcf,[performanceSavePath,dataName '-Type-Performance-' num2str(typeIndex)],'fig');
                        saveas(gcf,[performanceSavePath,dataName '-Type-Performance-' num2str(typeIndex)],'png');
                        close all;
                    end
            end
         %% time for each phase & trial
            plotTime_DNMS( timeMat,dataName);
            saveas(gcf,[timeSavePath,dataName '-Time'],'fig');
            saveas(gcf,[timeSavePath,dataName '-Time'],'png');
            close all;
            [timeDistribution] = plotTimeDistribution_DNMS(timeMat);
            saveas(gcf,[timeSavePath,dataName '-Time Distribution'],'fig');
            saveas(gcf,[timeSavePath,dataName '-Time Distribution'],'png');
            close all;

    end
end