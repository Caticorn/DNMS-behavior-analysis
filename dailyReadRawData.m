%{
This code is for analyzing DNMS data
created by Zou Shimin on 13th Dec., 2017
% copy raw data to analysis folder
% read Java files and convert to matrixes
% modified by Shimin on 20th Jan. 2018, for TT-YY trials 
%}

%% set working path and other parameters
clear;
dayIndex = 3;%day of the training process
trialNoPerBlock = 12;
taskName = '*Shaping.ser';%change task name here
%rawDataPath = pwd;
rawDataPath = ('E:\Behavioral training\201803\Shaping');%change raw data saving folder here
analysisPath = ('E:\Data analysis\201803\Shaping');%change data analysis folder here
taskType = 'Shaping';
%'Shaping','DNMS','DNMS-varied delay'
%% copy JAVA files and convert JAVA data to matrix
% find raw file 
allRawPath=genpath(rawDataPath);
splitRawPath=strsplit(allRawPath,';');
splitRawPath=splitRawPath';
splitRawPath=splitRawPath(2:end-1);
% set saving path
allPath=genpath(analysisPath);
splitPath=strsplit(allPath,';');
splitedPath=splitPath';
splitedPath=splitedPath(2:end-1);

for mouseID =1:size(splitRawPath,1)
    subPath=splitRawPath{mouseID,1};
    temp=strsplit(subPath,'\');
    mouseName=temp{1,end};
    cd(subPath);
    rawFiles = dir(taskName);
    if isempty(rawFiles)==0 % make sure files existed
        %% copy file
        rawFile=rawFiles(dayIndex,1).name;
        mousePath=splitedPath{mouseID,1};
        copyfile(rawFile,mousePath);
        %% convert JAVA data to matrix
        cd(mousePath);
        rawData=ser2mat(rawFile);
        rawData=double(rawData);
        dataName = rawFile(1:end-4);
        %% extract events and other information
        switch taskType
            case {'Shaping','DNMS'}
                [ rawData,timePointMat,timeMat,trialNo,blockNo,delayDuration, dailyPerf,typePerfPerBlock,perfPerBlock,trialMat,typeDailyPerf] = readRawData_DNMS_TT_YY( rawData,trialNoPerBlock);
                save([dataName,'.mat'],'rawData','timePointMat','timeMat','trialNo','blockNo','delayDuration', 'dailyPerf','typePerfPerBlock','perfPerBlock','trialMat','typeDailyPerf');
            case {'DNMS-varied delay'}
                [ rawData,timePointMat,timeMat,trialNo,blockNo,delayDuration, dailyPerf,typePerfPerBlock,perfPerBlock,trialMat,typeDailyPerf,delayType,variedDelayTrial,variedDelayTime,variedDelayPerf,delayPerfPerBlock] = readRawData_DNMS_variedDelay( rawData,trialNoPerBlock);
                save([dataName,'.mat'],'rawData','timePointMat','timeMat','trialNo','blockNo','delayDuration', 'dailyPerf','typePerfPerBlock','perfPerBlock','trialMat','typeDailyPerf','delayType','variedDelayTrial','variedDelayTime','variedDelayPerf','delayPerfPerBlock');
        end
    end
end