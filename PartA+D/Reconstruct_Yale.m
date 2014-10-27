%global variables - numEigen,resizeDim ,......
%getTrainData
%getTestData
%classify


function Reconstruct_Yale(index)
global flag;
flag=index;
%%---------Global Variables------------------------------------------------
tic;
%clc
sumAccuracy=0;
global reSizeDim listOfExternalLabelFileNames listOfExternalImageFileNames trainData testData numEigen weightVectorTrain eigenSet meanImage
reSizeDim= 80;
numEigen = 400;
listOfExternalImageFileNames  = {'fileNames_1' 'fileNames_2' 'fileNames_3' 'fileNames_4'};
listOfExternalLabelFileNames  = {'Labels_1' 'Labels_2' 'Labels_3' 'Labels_4'};

%%--------Four Fold Classification ----------------------------------------
[trainData trainLabels testData testLabels ] = getTrainTestData(1);    
'Data Generated!'        
weightVectorTrain = getWeightVectorTrain();        
weightVectorTest = getWeightVectorTest(); 
reConstruct()
%{
for i=1:4    
    [trainData trainLabels testData testLabels ] = getTrainTestData(i);    
    'Data Generated!'        
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
        if char(predictedLabels(j))==char(testLabels(j))
            c=c+1;
        end
    end    
    (c/190)*100
    sumAccuracy = sumAccuracy+((c/190)*100);      
   % clearvars -global eigenSet 
end
'Average Accuracy '
(sumAccuracy/4)
%}
toc;
end

%%-------------------------------------------------------------------------

%%---------Computes Train and Test Data------------------------------------
function [trainData trainLabels testData testLabels ] = getTrainTestData(testFileNum)
global reSizeDim listOfExternalImageFileNames listOfExternalLabelFileNames;
trainData = zeros(reSizeDim*reSizeDim,570,'double');
testData = zeros(reSizeDim*reSizeDim,190,'double');
%trainLabels = zeros(570,1,'double');
%testLabels = zeros(190,1,'double');
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
'Line 89';
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
global weightVector eigenSet reSizeDim meanImage image flag;
image_name={'CroppedYale/yaleB06/yaleB06_P00A-010E+00.pgm','barack.jpg','res.jpg'};
if(flag==1)
image = double (reshape(imresize(imread(char(image_name(flag))),[reSizeDim reSizeDim]),reSizeDim*reSizeDim,1));
else
readim = imread(char(image_name(flag)));
%size(readim)
I = rgb2gray(readim);
%size(I)

image = double(reshape(imresize(I,[reSizeDim reSizeDim]),reSizeDim*reSizeDim,1));
end
weightVectorp = (image-meanImage)'*eigenSet;
image = weightVectorp*eigenSet';
image = image + meanImage';
newImage = reshape(image,[reSizeDim reSizeDim]);
size(newImage);
imagesc(newImage);
colormap(gray);    

end
