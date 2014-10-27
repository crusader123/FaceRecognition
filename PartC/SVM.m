%global variables - numEigen,resizeDim ,......
%getTrainData
%getTestData
%classify


function myPCA
%%---------Global Variables------------------------------------------------
tic;
clc
sumAccuracy=0;
global reSizeDim listOfExternalLabelFileNames listOfExternalImageFileNames trainData testData numEigen weightVectorTrain eigenSet meanImage
reSizeDim= 80;
numEigen = 25;
listOfExternalImageFileNames  = {'fileNames_0' 'fileNames_1' 'fileNames_2' 'fileNames_3'};
listOfExternalLabelFileNames  = {'Labels_0' 'Labels_1' 'Labels_2' 'Labels_3'};

%%--------Four Fold Classification ----------------------------------------
for i=1:4    
    [trainData trainLabels testData testLabels ] = getTrainTestData(i);    
    'Data Generated!'            
    weightVectorTrain = getWeightVectorTrain();        
    weightVectorTest = getWeightVectorTest();

    %normalising Train and Test Data
    minimums = min(weightVectorTrain, [], 1);
    ranges = max(weightVectorTrain, [], 1) - minimums;
    weightVectorTrain = (weightVectorTrain - repmat(minimums, size(weightVectorTrain, 1), 1)) ./ repmat(ranges, size(weightVectorTrain, 1), 1);
    minimums = min(weightVectorTest, [], 1);
    ranges = max(weightVectorTest, [], 1) - minimums;
    weightVectorTest = (weightVectorTest - repmat(minimums, size(weightVectorTest, 1), 1)) ./ repmat(ranges, size(weightVectorTest, 1), 1);
	%souce : http://stackoverflow.com/questions/10055396/scaling-the-testing-data-for-libsvm-matlab-implementation
   model = svmtrain(trainLabels,weightVectorTrain);
   [predicted_label, accuracy, decision_values] = svmpredict(testLabels,weightVectorTest,model);
   accuracy(1,1)
   %size(accuracy)
   sumAccuracy = sumAccuracy + accuracy(1,1);
end
'Average Accuracy '
(sumAccuracy/4)
toc;
end
%%-------------------------------------------------------------------------

%%---------Computes Train and Test Data------------------------------------
function [trainData trainLabels testData testLabels ] = getTrainTestData(testFileNum)
global reSizeDim listOfExternalImageFileNames listOfExternalLabelFileNames;
cou=1;cou1=1;
trainLabels =[];
for k=1:size(listOfExternalImageFileNames,2)        
    imageNames = importdata(char(listOfExternalImageFileNames(k)));
    labelNames = importdata(char(listOfExternalLabelFileNames(k)));    
    if k~=testFileNum                
        trainLabels = cat(1,trainLabels,labelNames);
        for i=1:size(imageNames,1)             % reading each image  ,reSizing and reShaping it            
            trainData(:,cou) = double (reshape(imresize(imread(char(imageNames(i))),[reSizeDim reSizeDim]),reSizeDim*reSizeDim,1));                        
            cou=cou+1;
        end
    else
        testLabels = labelNames;
        for i=1:size(imageNames,1)             % reading each image  ,reSizing and reShaping it            
            testData(:,cou1) = double (reshape(imresize(imread(char(imageNames(i))),[reSizeDim reSizeDim]),reSizeDim*reSizeDim,1));                        
            cou1=cou1+1;
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
for i=1:size(testData,2)    
    weightVect(i,:)=(testData(:,i)-meanImage)'*eigenSet;    
end
end
%%-------------------------------------------------------------------------

%%--------------Reconstructs Image-----------------------------------------
function reConstruct()
global weightVector eigenSet reSizeDim meanImage
size(weightVector)
size(eigenSet')
image = weightVector*eigenSet';
image = image + meanImage';
newImage = reshape(image,[reSizeDim reSizeDim]);
size(newImage);
imagesc(newImage);
colormap(gray);    
end
