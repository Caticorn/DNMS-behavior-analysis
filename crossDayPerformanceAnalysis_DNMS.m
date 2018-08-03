%{
this code is for plot learning curve
created by: Zou Shimin
1st Apr. 2017
updated: 23th Nov. 2017 (plot performance of each block)
updated: 26th Jan. 2018 by Zou Shimin (TT&YY trials)
%}
clear;

%% path info
expName='DNMS ';
analysisPath=('E:\Data analysis\201803\DNMS');%change data analysis folder here
%analysisPath=pwd;
typeNum = 2;%1-4,or 4-1
averagedPerfSavePath = ('E:\Data analysis\201803\figure\DNMS\crossDay\');
if ~exist(averagedPerfSavePath,'dir')
    mkdir(averagedPerfSavePath);
end
performanceSavePath = ('E:\Data analysis\201803\figure\DNMS\crossDay\perf\');
if ~exist(performanceSavePath,'dir')
    mkdir(performanceSavePath);
end
timeSavePath = ('E:\Data analysis\201803\figure\DNMS\crossDay\time\');
if ~exist(timeSavePath,'dir')% if the folder is not existed
    mkdir(timeSavePath);%creat one
end
timePerfSavePath = ('E:\Data analysis\201803\figure\DNMS\crossDay\timePerf\');
if ~exist(timePerfSavePath,'dir')% if the folder is not existed
   mkdir(timePerfSavePath);%creat one
end

allPath=genpath(analysisPath);
splitPath=strsplit(allPath,';');
splitedPath=splitPath';
savePath=splitedPath{1};
splitedPath=splitedPath(2:end-1);
miceNo=size(splitedPath,1);

allPerf=[];
allTypePerf = cell(1,typeNum);
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
    mouseTypeDailyPerf = zeros(trainingDay,typeNum);
    mouseTimeMat = [];
    mouseTrialMat = [];
   for day=1:trainingDay
        load(fileNameList(day).name);
        mouseDailyPerf(day,1)=dailyPerf;
        mouseTypeDailyPerf(day,:) = typeDailyPerf;%1-4 /4-1
        mouseTimeMat = [mouseTimeMat;timeMat];
        mouseTrialMat = [mouseTrialMat;trialMat];           
   end 
   %% plot single mouse perf cross day 
    plotPerf_DNMS(mouseDailyPerf,mouseTypeDailyPerf,mouseName,0,0);
    saveas(gcf,[performanceSavePath,mouseName '-allTrial'],'fig');
    saveas(gcf,[performanceSavePath,mouseName '-allTrial'],'png');
    close all;
    plotPerf_DNMS(mouseDailyPerf,mouseTypeDailyPerf,mouseName,0,1);
    saveas(gcf,[performanceSavePath,mouseName '-arm'],'fig');
    saveas(gcf,[performanceSavePath,mouseName '-arm'],'png');
    close all;
   %% integrated data of all mice
   mouseDailyPerf = mouseDailyPerf';
   allPerf=[allPerf;mouseDailyPerf];
   allTimeMat = [allTimeMat;mouseTimeMat];
   allTrialMat = [allTrialMat;mouseTrialMat];
   mouseTypeDailyPerf = mouseTypeDailyPerf';
   for iType = 1:typeNum
       allTypePerf{1,iType} = [allTypePerf{1,iType};mouseTypeDailyPerf(iType,:)];
   end
  
end    

 %% calculate mean and SD
 meanPerf = zeros((typeNum+1),trainingDay);
 sdPerf = zeros((typeNum+1),trainingDay);
[ meanPerf(1,:),sdPerf(1,:) ] = calculateMeanAndSD( allPerf );%each column: day
for iType = 1:typeNum %all, 1-4, 4-1
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
typeResults = cell(1,2);%checkNormality,pValue
[ typeResults{1,1},typeResults{1,2} ] = typeStatisticAnalysis( allTypePerf{1},allTypePerf{2},trainingDay);%TT & YY

%% save matrixes
cd(averagedPerfSavePath);
save ([expName,'-statisticAnalysis.mat'],'allPerf','allTimeMat','allTrialMat','allTypePerf','meanPerf','sdPerf','typeResults');


%% plot averaged learning curve
plotAveragedMicePerf_DNMS( meanPerf, sdPerf,trainingDay,expName,miceNo,0);
saveas(gcf,[averagedPerfSavePath,expName '-Averaged Learning Curve-all'],'fig');
saveas(gcf,[averagedPerfSavePath,expName '-Averaged Learning Curve-all'],'png');
close all;
plotAveragedMicePerf_DNMS( meanPerf, sdPerf,trainingDay,expName,miceNo,1);
saveas(gcf,[averagedPerfSavePath,expName '-Averaged Learning Curve-Type'],'fig');
saveas(gcf,[averagedPerfSavePath,expName '-Averaged Learning Curve-Type'],'png');
close all;
