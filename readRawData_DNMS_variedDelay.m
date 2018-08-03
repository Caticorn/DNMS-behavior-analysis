function [ rawData,timePointMat,timeMat,trialNo,blockNo,delayDuration, dailyPerf,typePerfPerBlock,perfPerBlock,trialMat,typeDailyPerf,delayType,variedDelayTrial,variedDelayTime,variedDelayPerf,delayPerfPerBlock] = readRawData_DNMS_variedDelay( rawData,trialNoPerBlock)
% construct daily data of DNMS task
% extract events and other information: sample & choice, performance, time
% modified by Shimin on 8th May 2018, in this version, only TT or YY
    %{
    Defination of Serial ports
     SpLick                0
     SpCome                1
     SpFalseAlarm          4
     SpCorrectRejection    5
     SpMiss                6
     SpHit                 7
     SpDelay   9         
     SpDelay2  10 
     SpDelay3  11      
     SpDelay4  64
     SpStepN               51// rule information
     SpTrialType           58// rule information here

     SpSample  12 ///1 2 3 4 till n
     SpChoice  13 ///1 2 3 4 till n
     SpDistractor  14
     SpCatchTrial  15 ///1 for catch trial, 0 for blank Trial
     SpTrialLaser  16 
     SpPariedArm  17
     SpNonPairedArm  18

     SpITI       59// 1 start 0 end
     SpTrain     62// 1 start 0 end
     SpSess      61// 1 start 0 end
     Splaser     65// 1 laser on, 0 laser off

     SpSamplePhase   20 //1 start 0 end//S1S1
     SpChoicePhase   21 //1 start 0 end//S1S2
     SpTrial   22 //1 start 0 end     //S1S3
     SpHome   23 //1 out 0 in         //S1S4
     SpDistractorPhase   24 //1 start 0 end //S1S5
     SpChoiceArm   25 //1 out 0 in    //S2S1
     SpSamplePhase2   26              //S2S2
     SpChoicePhase2   27              //S2S3
     SpSample2   28                   //S2S4
     SpChoice2  29                    //S2S5
     SpSampleEntered   30             //S3S1
     SpChoiceEntered   31             //S3S2
    %}
    %% Read out trial info (sample choice result)
    rawData(:,1) = rawData(:,1) - rawData(1,1);%reference start time
    %trialNo =  length(rawData(rawData(:,3) == 59&rawData(:,4)==0,3)); %ITI
    trialNo = length(rawData(rawData(:,3) == 7&rawData(:,4)==1,3))+length(rawData(rawData(:,3) == 4&rawData(:,4)==1,3));% hit and false
    blockNo = length(rawData(rawData(:,3) == 61,3))/2;
    trialPerf = rawData(rawData(:,3)==7|rawData(:,3)==4,:);%(:,4)==1 1st DNMS;(:,4)==2 2nd DNMS (dual-task)
    %% trialMat
    trialMat = zeros(trialNo,3);% S1,C1,R1
    sampleArm = rawData(rawData(:,3) == 12,4);
    choiceArm = rawData(rawData(:,3) == 13,4);
    trialMat(:,1) = sampleArm(1:trialNo,1);%sample
    trialMat(:,2) = choiceArm(1:trialNo,1);%choice
    trialMat(:,3) = trialPerf(1:trialNo,3);%result 4 for false, 7 for hit
    %4th column: 1 is default value; 2 for inner task in nested dual-task
    %% Read out time point info
    timePointMat = zeros(trialNo,6);
        %% sample phase
        temp1 = rawData (rawData(:,3)==20&rawData(:,4)==1,1);%first DNMS sample phase
        temp2 = rawData (rawData(:,3)==20&rawData(:,4)==2,1);
        temp3 = rawData (rawData(:,3)==20&rawData(:,4)==0,1);
        timePointMat(:,1:3) = [temp1(1:trialNo,:),temp2(1:trialNo,:),temp3(1:trialNo,:)];
       %% choice phase
        temp4 = rawData (rawData(:,3)==21&rawData(:,4)==1,1);%first DNMS choice phase
        timePointMat(:,4) = temp4(1:trialNo,:);
        temp5 = trialPerf(trialPerf(:,4)==1,1);
        timePointMat(:,5) = temp5(1:trialNo,1);
        temp6 = rawData (rawData(:,3)==21&rawData(:,4)==0,1);
        if length(temp6)<trialNo
            temp6 = [temp6;rawData(end,1)];
        end    
        timePointMat(:,4:6) = [temp4(1:trialNo,:),temp5(1:trialNo,:),temp6(1:trialNo,:)];
    %% calculate timeMat and contruct
    timeMat = zeros(trialNo,5);% entire trial, sample, delay ,choice(befor decision),choice(after decision)
    timeMat(:,1) = timePointMat(:,6)-timePointMat(:,1); % entire trial
    timeMat(:,2) = timePointMat(:,3)-timePointMat(:,1); % sample phase
    timeMat(:,3) = timePointMat(:,4)-timePointMat(:,3); % delay duration
    timeMat(:,4) = timePointMat(:,5)-timePointMat(:,4); % choice (before decision)
    timeMat(:,5) = timePointMat(:,6)-timePointMat(:,5); % choice (after decision)
    timeMat = timeMat/1000;
    
    %% varied delay
    %{
    delayDuration = rawData(rawData(:,3)== 9,4);
    delayDuration = delayDuration(1:trialNo,:)*5;
    %}
    delayDuration = round(timeMat(:,3));
    delayType = unique(delayDuration);% delay durations
    delayNo = length(delayType);% number of delay durations
    variedDelayTrial = cell(delayNo,1);%use cell instead of matrix (in case training uncompleted ? dimension error) 
    variedDelayTime = cell(delayNo,1);
    variedDelayPerf = zeros(delayNo,1);
    for delayTypeIndex = 1:delayNo
        variedDelayTrial{delayTypeIndex,1} = trialMat(delayDuration(:,1)==delayType(delayTypeIndex,1),:);
        variedDelayTime{delayTypeIndex,1} = timeMat(delayDuration(:,1)==delayType(delayTypeIndex,1),:);
        variedDelayPerf(delayTypeIndex,1) = calculatePerformance(variedDelayTrial{delayTypeIndex,1});% performance
    end
    %% performance calculation
    % daily perf
    dailyPerf = 100*length(find(trialMat(:,3)==7))/length(trialMat(:,1));
    % trial type
    typeDailyPerf = zeros(1,2);
    type1 = trialMat(trialMat(:,1)<3,:);%TT:1-4, YY:2-3
    type2 = trialMat(trialMat(:,1)>2,:);%TT:4-1, YY:3-2
    typeDailyPerf(1,1) = 100*length(find(type1(:,3)==7))/length(type1(:,1));
    typeDailyPerf(1,2) = 100*length(find(type2(:,3)==7))/length(type2(:,1));  
    % block perf
    perfPerBlock = zeros(ceil(blockNo),1);
    typePerfPerBlock = zeros(ceil(blockNo),2);
    delayPerfPerBlock = zeros(ceil(blockNo),delayNo);
    for blockIndex = 1:ceil(blockNo)
        if blockIndex == ceil(blockNo)% in case the last block was not completed
           blockMat = trialMat(((blockIndex - 1)*trialNoPerBlock+1):end,:); 
           durationBlock = delayDuration(((blockIndex - 1)*trialNoPerBlock+1):end,:);
        else
           blockMat = trialMat(((blockIndex - 1)*trialNoPerBlock+1):blockIndex*trialNoPerBlock,:);
           durationBlock = delayDuration(((blockIndex - 1)*trialNoPerBlock+1):blockIndex*trialNoPerBlock,:);
        end
        perfPerBlock(blockIndex,1) = calculatePerformance(blockMat);
        % type
        type1Block = blockMat(blockMat(:,1)<3,:);%TT:1-4, YY:2-3
        type2Block = blockMat(blockMat(:,1)>2,:);%TT:4-1, YY:3-2
        typePerfPerBlock(blockIndex,1) = calculatePerformance(type1Block);
        typePerfPerBlock(blockIndex,2) = calculatePerformance(type2Block);
        % varied delay
        for delayIndex = 1: delayNo 
            delayBlock = blockMat(durationBlock(:,1)==delayType(delayIndex,1),:);
            delayPerfPerBlock(blockIndex,delayIndex) = calculatePerformance(delayBlock);
        end
    end 

end

