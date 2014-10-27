%global variables - numEigen,resizeDim ,......
%getTrainData
%getTestData
%classify

function [] = Yale_verification()
global reSizeDim listOfExternalLabelFileNames listOfExternalImageFileNames trainData weightVector testData numEigen weightVectorTrain eigenSet meanImage avgWeightVector finalEigen eigenSet numImages actualTestData actualTestLabel testDataFile testLabelFile score lab count total;
count = 0;
total = 0;
validation();
size(score);
%return;
verification4('TestData2','TestLabel2',1);
%return;
verification4('TestData3','TestLabel3',2);
'Accuracy for Verification comes out to be'
Accuracy = (count/total)*100
end


%---------------------------------------------------------------------------------------------------------------%
function [] = validation()

global reSizeDim listOfExternalLabelFileNames listOfExternalImageFileNames trainData weightVector testData numEigen weightVectorTrain eigenSet meanImage avgWeightVector finalEigen eigenSet numImages actualTestData actualTestLabel testDataFile testLabelFile score lab threshold;
sumAccuracy=0;
reSizeDim= 80;
numEigen = 40;
numImages = 10;
listOfExternalImageFileNames  = {'ValidData'};
listOfExternalLabelFileNames  = {'ValidLabel'};
for i=1:1    
    [trainData trainLabels ] = getTrainTestData();    
   % return;
    'Data Generated!'            
    weightVector = getWeightVectorTrain();
    size(weightVector)
    %avgWeightVector = getAverageWeight()
	getAverageWeight();
	'Main'
	%size(score)
	%size(lab)
	%return;
	%lab
	%return;
end

 [x, y, t, k, opt] = perfcurve(lab,score,1);
 'x'
 size(x)
'y'
size(y)
't'
size(t)
opt
for i = 1:size(x,1)
	if opt(1,1) == x(i,1) && opt(1,2) == y(i,1)
	i
	break;
	end
end
threshold = t(i,1)

plot(x,y)
k
%find(y,opt(2))

end
function [] = verification4(filenm,labelnm,flag)
%%---------Global Variables------------------------------------------------
global reSizeDim listOfExternalLabelFileNames listOfExternalImageFileNames trainData weightVector testData numEigen weightVectorTrain eigenSet meanImage avgWeightVector finalEigen eigenSet numImages actualTestData actualTestLabel testDataFile testLabelFile score lab count total threshold;

testDataFile = filenm;
testLabelFile = labelnm;
actualImageNames = importdata(char(testDataFile));
%size(actualImageNames,2)
actualLabelNames = importdata(char(testLabelFile));    
%count = 0;
count2=0;
tic;
for k=1:size(actualImageNames,1)
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
'avg'
size(avg)
%return;
size(eigenSet);
'k'
k
kNN=0;
	for i = 1:size(avg,2)
	%'sss'
	%size(avgWeightVector)
	%return;
	if(avg(1,i)<=threshold)
	kNN=kNN+1;
	if(kNN==1)
	if(flag==1)
	count=count+1;
	end
	count2=count2+1;
	break;
	end
	end
end
end
'count2'
count2
if(flag==2)
	count2=size(actualImageNames,1)-count2;
	count = count + count2;
	end
total = total+size(actualImageNames,1)
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
%size(listOfExternalImageFileNames,2);        
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
size(meanSubtractedImages)
size(eVectors)
eigenSet = zeros(6400,numEigen,'double');
for i=1:numEigen
    eigenSet(:,i) = meanSubtractedImages*eVectors(:,indices(i));
end

eigenSet = normc(eigenSet);
weightVector = (eigenSet'*meanSubtractedImages)';
'Weight';
size(weightVector);
end

%%------------------------------------------------------------------------

function getAverageWeight()
		global weightVector numImages score lab;
		score = [];
		lab = [];
	for k = 1:38
		temp = pdist(weightVector(numImages*k-(numImages-1):k*numImages,:));
		'temp'
		size(temp)
		temp2 = sort(temp,'descend');
		%return;
		score = [score temp2(1:39)];
		'score'
		size(score)
		%return;
		for j = 1:39
		lab = [ lab 1];
		end
	end
	'score main'
	score
	%return;
	size(score)
	size(lab)
	%return;
	for k = 1:10:371
	temp2 = [];
	for j = 1:10:371
	if(j~=k)
	temp2 = [ temp2 ; weightVector(j,:)];
	lab = [ lab 0];
	end
	end
	size(weightVector(k,:))
	size(temp2(1:size(temp2),:))
	temp = []
	for j=1:size(temp2,1)
		temp = [temp norm(weightVector(k)-temp2(j))]
	end
	%if(size(temp2,1)~=0)
	%temp = pdist2(weightVector(k,:),temp2(1:size(temp2,1),:))
	tmp = sort(temp,'descend');
	score = [ score tmp];
	end
	end



			
%end
