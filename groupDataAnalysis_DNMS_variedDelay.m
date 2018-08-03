%{
For analyzing GROUPED cross day performance
Created by : Shimin on 18th Mar. 2018
%}
clear;

%% path info
expName='ChR2 Mice-mPFC-DNMS-variedDelay ';
analysisPath=('E:\Unicorn\05 Data analysis\201803_mPFC\DNMS_VariedDelay');%change data analysis folder here
%analysisPath=pwd;
typeNum = 3;%3 delay deuration
%typeNo = length(typeIndexMat);
groupPerfSavePath = ('E:\Unicorn\05 Data analysis\201803_mPFC\figure\DNMS_VariedDelay\group\');
if ~exist(groupPerfSavePath,'dir')
    mkdir(groupPerfSavePath);
end
%% group info
groupNo=2;
groupName = {'WT','VGAT-ChR2'};
if groupNo==0
   groupID=0;
elseif groupNo~=0%input group info here
   % grouped according to genotype
   group1={'M01','M04','M09','M12','M14','M18','M21','M26'};
   group2={'M05','M11','M17','M20','M22','M23'};
   groupMice = {group1, group2};
end
gPerf = cell(typeNum+1,groupNo); 
%%
allPath=genpath(analysisPath);
splitPath=strsplit(allPath,';');
splitedPath=splitPath';
savePath=splitedPath{1};
splitedPath=splitedPath(2:end-1);
miceNo=size(splitedPath,1);
for mouseID=1:miceNo
    mousePath=splitedPath{mouseID,1};
    temp=strsplit(mousePath,'\');
    mouseName=temp{1,end};
    %% get group ID 
    if groupNo ~= 0
      if ismember(mouseName,group1)
          groupID=1;
      elseif ismember(mouseName,group2)
          groupID=2;
      end
    end
    %% change the directory to the file of mouseID
    cd(mousePath);
    fileNameList=dir('*.mat');
    trainingDay=size(dir('*mat'),1);
    %% created matrix for each mouse
    mouseDailyPerf = zeros(1,trainingDay);
    mouseTypeDailyPerf = zeros(trainingDay,typeNum);
    %mouseTrialMat = [];
   for day=1:trainingDay
        load(fileNameList(day).name);
        mouseDailyPerf(1,day)=dailyPerf;
        mouseTypeDailyPerf(day,:) = variedDelayPerf;
        %mouseTrialMat = [mouseTrialMat;trialMat];
   end 
   %% group data 
   mouseTypeDailyPerf = mouseTypeDailyPerf';
   gPerf{1,groupID} = [gPerf{1,groupID};mouseDailyPerf]; % all trials
   for typeIndex = 1:typeNum % three delay durations
       gPerf{(typeIndex+1),groupID} = [gPerf{(typeIndex+1),groupID};mouseTypeDailyPerf(typeIndex,:)];
   end
end 

%% calculate mean and SD
gMean = cell(typeNum+1,groupNo);
gSD = cell(typeNum+1,groupNo);
for groupID = 1:groupNo
    for typeIndex = 1:typeNum+1
        [gMean{typeIndex,groupID},gSD{typeIndex,groupID}] = calculateMeanAndSD( gPerf{typeIndex,groupID} );%each column: day
    end
end
 cd(groupPerfSavePath);
 plotGroupedMicePerf_variedDelay(gPerf,gMean,gSD,expName, groupNo,groupName,delayType,trainingDay,0);
 saveas(gcf,[groupPerfSavePath,expName '-All-Group'],'fig');
 saveas(gcf,[groupPerfSavePath,expName '-All-Group'],'png');
 close all;
 plotGroupedMicePerf_variedDelay(gPerf,gMean,gSD,expName, groupNo,groupName,delayType,trainingDay,1);
 saveas(gcf,[groupPerfSavePath,expName '-variedDelay-Group'],'fig');
 saveas(gcf,[groupPerfSavePath,expName '-variedDelay-Group'],'png');
 close all;
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
groupST = cell(typeNum+1,2);%checkNormality,pValue
for iter = 1:(typeNum+1)
    [ groupST{iter,1},groupST{iter,2} ] = typeStatisticAnalysis( gPerf{iter,1},gPerf{iter,2},trainingDay);
end

%% save matrixes
 cd(groupPerfSavePath);
 save ([expName,'-Group.mat'],'gPerf','gMean','gSD','groupST');   