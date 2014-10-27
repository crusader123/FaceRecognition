%global variables - numEigen,resizeDim ,......
%getTrainData
%getTestData
%classify


function [] = ExtraFeature()
%%---------Global Variables------------------------------------------------
global reSizeDim listOfExternalLabelFileNames listOfExternalImageFileNames trainData weightVector testData numEigen weightVectorTrain eigenSet meanImage avgWeightVector finalEigen eigenSet numImages actualTestData actualTestLabel testDataFile testLabelFile;
testDataFile = 'TestData2';
testLabelFile = 'TestLabel2';
sumAccuracy=0;
reSizeDim= 80;
numEigen = 40;
numImages = 10;
listOfExternalImageFileNames  = {'ValidData'};
listOfExternalLabelFileNames  = {'ValidLabel'};
actualImageNames = importdata(char(testDataFile));
%size(actualImageNames,2)
actualLabelNames = importdata(char(testLabelFile));    
for i=1:1    
    [trainData trainLabels ] = getTrainTestData();    
   % return;
    'Data Generated!'            
    weightVector = getWeightVectorTrain();
    size(weightVector)
    avgWeightVector = getAverageWeight()
end

count = 0;
tic;
for k=1:size(actualImageNames)
%testImage = actualImageNames(k);
testMat = double (reshape(imresize(imread(char(actualImageNames(k))),[reSizeDim reSizeDim]),reSizeDim*reSizeDim,1));
testMat = testMat - meanImage;
'testMat'
givenLabel = actualLabelNames(k);
if givenLabel >= 15
	givenLabel = givenLabel - 1;
	end
checkWeight = (eigenSet'*testMat)';
avg = pdist2(checkWeight,weightVector(givenLabel*numImages - (numImages-1):givenLabel*numImages,:));
size(testMat);
size(eigenSet);
'k'
k
kNN=0;
	for i = 1:size(avg,2)
	if(avg(1,i)<=avgWeightVector(givenLabel))
	kNN=kNN+1;
	if(kNN==3)
	count=count+1;
	break;
	end
	end
end
end
'count'
count
return;
mean(avg);
avgWeightVector(givenLabel);
end
%%-------------------------------------------------------------------------

%%---------Computes Train Data------------------------------------
function [trainData trainLabels ] = getTrainTestData()
global reSizeDim listOfExternalImageFileNames listOfExternalLabelFileNames;
cou=1;cou1=1;
%trainLabels =[];
size(listOfExternalImageFileNames,2);        
for k=1:size(listOfExternalImageFileNames,2)        
    imageNames = importdata(char(listOfExternalImageFileNames(k)));
    size(imageNames);
    labelNames = importdata(char(listOfExternalLabelFileNames(k)));    
        trainLabels = labelNames;
	ind = 1;
	indz=0;
        for i=1:size(imageNames,1)% reading each image  ,reSizing and reShaping 
		trainData(:,i) = double (reshape(imresize(imread(char(imageNames(i))),[reSizeDim reSizeDim]),reSizeDim*reSizeDim,1));
	end
end
end
%%-------------------------------------------------------------------------

%%--------------Computes weightVector for Train Data-----------------------

function weightVector=getWeightVectorTrain()
%function getWeightVectorTrain()
weightVector = [];
global trainData numEigen eigenSet meanImage finalEigen numImages;
finalEigen = []
meanImage = mean(trainData')';
size(meanImage);
%return;
for i=1:size(trainData,2)            
    meanSubtractedImages(:,i) = trainData(:,i) - meanImage;
end
'B Matrxx';
size(meanSubtractedImages);
%return;
covarianceMat = meanSubtractedImages'*meanSubtractedImages;
' Covariance';
size(covarianceMat);
[eVectors eVal] = eig(covarianceMat);
'EVector';
size(eVectors);
%return;
for i=1:numImages*38
    eValues(i) = eVal(i,i);
end

[value indices] = sort(eValues,'descend');
'Value';
size(value);
for i=1:numEigen
    eigenSet(:,i) = meanSubtractedImages*eVectors(:,indices(i));
end

eigenSet = normc(eigenSet);
weightVector = (eigenSet'*meanSubtractedImages)';
'Weight';
size(weightVector);
end

%%------------------------------------------------------------------------

function avgWeight = getAverageWeight()
	global weightVector numImages;
	for k = 1:38
		avgWeight(k)=mean(pdist(weightVector(numImages*k-(numImages-1):k*numImages,:)));
	end
			
end
