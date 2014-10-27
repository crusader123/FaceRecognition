%global variables - numEigen,resizeDim ,......
%getTrainData
%getTestData
%classify


function cmu(n)
%%---------Global Variables------------------------------------------------
tic;
%clc
sumAccuracy=0;

global reSizeDim  trainData testData numEigen weightVectorTrain eigenSet meanImage sizeFold CMUPIEData testLabels trainLabels
load CMUPIEData.mat
sizeFold = (size(CMUPIEData,2))/4;
reSizeDim= 32;
numEigen = n;

%%--------Four Fold Classification ----------------------------------------
for i=1:4        
    [trainData trainLabels testData testLabels ] = getTrainTestData(i);    
    'Data Generated!';              
    weightVectorTrain = getWeightVectorTrain();        
    weightVectorTest = getWeightVectorTest(); 
    'knn';
    size(trainData);
    size(testData);
    size(testLabels);
    size(trainLabels);
    size(weightVectorTrain);
    mdl = ClassificationKNN.fit(weightVectorTrain,trainLabels,'NumNeighbors',5);
    [ predictedLabels prob ] =predict(mdl,weightVectorTest);           
    c=0;        
    for j=1:size(predictedLabels,1)
        if predictedLabels(j)==testLabels(j,1)
            c=c+1;
        end
    end        
    (c*100)/816
    sumAccuracy = sumAccuracy + ( (c*100)/816 );   
    %clearvars -global eigenSet
    %break
end
'Average Accuracy '
(sumAccuracy/4)
toc;
end
%%-------------------------------------------------------------------------

%%---------Computes Train and Test Data------------------------------------
function [trainData trainLabels testData testLabels ] = getTrainTestData(foldNum)
global sizeFold CMUPIEData reSizeDim
trainData = zeros(reSizeDim*reSizeDim,2040,'double');
testData = zeros(reSizeDim*reSizeDim,816,'double');
trainLabels = zeros(2040,1,'double');
testLabels = zeros(816,1,'double');
trainCount=1;
testCount=1;
for i=1:68   % images of 68 different persons are there
    cou=1;
    index=(i-1)*42;    
    for j=1:42
        imageSamplesOfPerson(:,j) = reshape( (CMUPIEData(index+j).pixels),reSizeDim*reSizeDim,1 );
        labelSamplesOfPerson(j,1) = (CMUPIEData(index+j).label);
    end
    for k=1:4
        if k~=foldNum                        
            for j=1:10             % reading each image  ,reSizing and reShaping it                           
                trainData(:,trainCount) = imageSamplesOfPerson(:,cou);
                trainLabels(trainCount,1) = labelSamplesOfPerson(cou,1);
                cou=cou+1;
                trainCount =trainCount+1;
            end
        else
            for j=1:12             % reading each image  ,reSizing and reShaping it                
                testData(:,testCount) = imageSamplesOfPerson(:,cou);
                testLabels(testCount,1) = labelSamplesOfPerson(cou,1);
                cou=cou+1;
                testCount =testCount+1;
            end
        end
    end
end
end
%%-------------------------------------------------------------------------

%%--------------Computes weightVector for Train Data-----------------------

function weightVector=getWeightVectorTrain()
global trainData numEigen eigenSet meanImage reSizeDim;
numImages = size(trainData,2);
meanImage = (mean(trainData'))';

for i=1:numImages            
    meanSubtractedImages(:,i) = trainData(:,i) - meanImage;
end

covarianceMat = meanSubtractedImages'*meanSubtractedImages;
[eVectors eVal] = eig(covarianceMat);
for i=1:numImages
    eValues(i) = eVal(i,i);
end

[value indices] = sort(eValues,'descend');
eigenSet = zeros(reSizeDim*reSizeDim,numEigen,'double');
for i=1:numEigen
    eigenSet(:,i) = meanSubtractedImages*eVectors(:,indices(i));
end

eigenSet = normc(eigenSet);
weightVector = (eigenSet'*meanSubtractedImages)';
end
%%-------------------------------------------------------------------------

%%--------------Computes weightVector for Test Data------------------------
function weightVect=getWeightVectorTest()
global testData eigenSet meanImage
size(testData);
for i=1:size(testData,2)    
    weightVect(i,:)=(testData(:,i)-meanImage)'*eigenSet;    
end
end
%%-------------------------------------------------------------------------