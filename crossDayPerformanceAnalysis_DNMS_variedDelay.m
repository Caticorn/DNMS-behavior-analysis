%{
this code is for plot learning curve
created by: Zou Shimin
1st Apr. 2017
updated: 23th Nov. 2017 (plot performance of each block)
updated: 26th Jan. 2018 by Zou Shimin (TT&YY, congruent&incongruent trials)
%}
clear;

%% path info
plotEachMousePerf = 0;

expName='DNMS-variedDelay ';
analysisPath=('E:\Data analysis\201803\DNMS_VariedDelay');%change data analysis folder here
%analysisPath=pwd;
%typeNo = length(typeIndexMat);
averagedPerfSavePath = ('E:\Data analysis\201803\figure\DNMS_VariedDelay\crossDay\');
if ~exist(averagedPerfSavePath,'dir')
    mkdir(averagedPerfSavePath);
end
performanceSavePath = ('E:\Data analysis\201803\figure\DNMS_VariedDelay\crossDay\perf\');
if ~exist(performanceSavePath,'dir')
    mkdir(performanceSavePath);
end


allPath=genpath(analysisPath);
splitPath=strsplit(allPath,';');
splitedPath=splitPath';
savePath=splitedPath{1};
splitedPath=splitedPath(2:end-1);
miceNo=size(splitedPath,1);

allPerf=[];
allTypePerf = cell(1,5);
allTimeMat = [];
allTrialMat = [];
%mouseNameList= cell(miceNo,1);

for mouseID=1:miceNo
    mousePath=splitedPath{mouseID,1};
    temp=strsplit(mousePath,'\');
    mouseName=temp{1,end};
    % mouseNameList{mouseID,1} = mouseName;
    %% change the directory to the file of mouseID
    cd(mousePath);
    fileNameList=dir('*.mat');
    trainingDay=size(dir('*mat'),1);
    %% created matrix for each mouse
    mouseDailyPerf = zeros(trainingDay,1);
    mouseTypeDailyPerf = zeros(trainingDay,2);%change number here 
    mouseDelayDailyPerf = zeros(trainingDay,3);
    mouseTimeMat = [];
    mouseTrialMat = [];
   for day=1:trainingDay
        load(fileNameList(day).name);
        mouseDailyPerf(day,1)=dailyPerf;
        mouseTypeDailyPerf(day,:) = typeDailyPerf;%arm1-4, arm4-1
        mouseDelayDailyPerf(day,:) = variedDelayPerf;%5s 30s 60s
        mouseTimeMat = [mouseTimeMat;timeMat];
        mouseTrialMat = [mouseTrialMat;trialMat];           
   end 
   %% plot single mouse perf cross day 
        plotPerf_DNMS_variedDelay(mouseDailyPerf,mouseTypeDailyPerf,mouseDelayDailyPerf,mouseName,0,0);
        saveas(gcf,[performanceSavePath,mouseName '-allTrial'],'fig');
        saveas(gcf,[performanceSavePath,mouseName '-allTrial'],'png');
        close all;
        for typeIndex = 1:2
            plotPerf_DNMS_variedDelay(mouseDailyPerf,mouseTypeDailyPerf,mouseDelayDailyPerf,mouseName,0,typeIndex);
            saveas(gcf,[performanceSavePath,mouseName '-type-' num2str(typeIndex)],'fig');
            saveas(gcf,[performanceSavePath,mouseName '-type-' num2str(typeIndex)],'png');
            close all;
        end       

   %% integrated data of all mice
   mouseDailyPerf = mouseDailyPerf';
   allPerf=[allPerf;mouseDailyPerf];
   allTimeMat = [allTimeMat;mouseTimeMat];
   allTrialMat = [allTrialMat;mouseTrialMat];
   mouseTypePerf = [mouseTypeDailyPerf,mouseDelayDailyPerf];
   mouseTypePerf = mouseTypePerf';
   for iType = 1:5
       allTypePerf{1,iType} = [allTypePerf{1,iType};mouseTypePerf(iType,:)];
   end
  
end    
   
 %% calculate mean and SD
 meanPerf = zeros(6,trainingDay);
 sdPerf = zeros(6,trainingDay);
[ meanPerf(1,:),sdPerf(1,:) ] = calculateMeanAndSD( allPerf );%each column: day
for iType = 1:5 %all, 1-4, 4-1,5s, 30s, 60s
    [ meanPerf((iType+1),:),sdPerf((iType+1),:) ] = calculateMeanAndSD( allTypePerf{1,iType});
end
%% statistic analysis
%{
checkNormality:
0 for Null Hypothesis (X is normally distributed with unspecified mean
and standard deviation.)
1 for Alternative Hypothesis (X is not normally distributed.)
pValue: 
1st row:rankSum (all,day1,day2,...)
2nd row:ttest (all,day1,day2,...)
%}
typeResults = cell(4,2);%checkNormality,pValue
[ typeResults{1,1},typeResults{1,2} ] = typeStatisticAnalysis( allTypePerf{1},allTypePerf{2},trainingDay);%arm1-arm4, arm4-arm1
[ typeResults{2,1},typeResults{2,2} ] = typeStatisticAnalysis( allTypePerf{3},allTypePerf{4},trainingDay);%5s 30s
[ typeResults{3,1},typeResults{3,2} ] = typeStatisticAnalysis( allTypePerf{4},allTypePerf{5},trainingDay);%30s 60s
[ typeResults{4,1},typeResults{4,2} ] = typeStatisticAnalysis( allTypePerf{3},allTypePerf{5},trainingDay);%5s 60s
%% save matrixes
cd(averagedPerfSavePath);
save ([expName,'-statisticAnalysis.mat'],'allPerf','allTimeMat','allTrialMat','allTypePerf','meanPerf','sdPerf','typeResults');


%% plot averaged learning curve
plotAveragedMicePerf_DNMS_variedDelay( meanPerf, sdPerf,trainingDay,expName,miceNo,delayType,0);
saveas(gcf,[averagedPerfSavePath,expName '-Averaged Learning Curve-all'],'fig');
saveas(gcf,[averagedPerfSavePath,expName '-Averaged Learning Curve-all'],'png');
close all;
for typeIndex = 1:2
    plotAveragedMicePerf_DNMS_variedDelay( meanPerf, sdPerf,trainingDay,expName,miceNo,delayType,typeIndex);
    saveas(gcf,[averagedPerfSavePath,expName '-Averaged Learning Curve-Type-' num2str(typeIndex)],'fig');
    saveas(gcf,[averagedPerfSavePath,expName '-Averaged Learning Curve-Type-' num2str(typeIndex)],'png');
    close all;
end
