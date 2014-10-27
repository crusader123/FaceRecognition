%global variables - numEigen,resizeDim ,......
%getTrainData
%getTestData
%classify
function [] = verification6()
global reSizeDim listOfExternalLabelFileNames listOfExternalImageFileNames trainData weightVector testData numEigen weightVectorTrain eigenSet meanImage avgWeightVector finalEigen eigenSet numImages actualTestData actualTestLabel testDataFile testLabelFile score lab count total;
count = 0;
total = 0;
validation();
%return;
size(score);
%return;
verification4();
'Accuracy for Verification comes out to be'
Accuracy = (count/total)*100
end


%---------------------------------------------------------------------------------------------------------------%
function [] = validation()

global reSizeDim listOfExternalLabelFileNames listOfExternalImageFileNames trainData weightVector testData numEigen weightVectorTrain eigenSet meanImage avgWeightVector finalEigen eigenSet numImages actualTestData actualTestLabel testDataFile testLabelFile score lab threshold;
sumAccuracy=0;
reSizeDim= 32;
numEigen = 40;
numImages = 20;
listOfExternalImageFileNames  = {'ValidData'};
listOfExternalLabelFileNames  = {'ValidLabel'};
for i=1:1    
    [trainData trainLabels ] = getTrainTestData();
    size(trainData)
    size(trainLabels)	
    %trainLabels
%	return;
    'Data Generated!'            
    weightVector = getWeightVectorTrain();
    size(weightVector)
	%return;
    %avgWeightVector = getAverageWeight()
	getAverageWeight();
	'Main'
	size(score)
	size(lab)
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
function [] = verification4()
%%---------Global Variables------------------------------------------------
global reSizeDim listOfExternalLabelFileNames listOfExternalImageFileNames trainData weightVector testData numEigen weightVectorTrain eigenSet meanImage avgWeightVector finalEigen eigenSet numImages actualTestData actualTestLabel testDataFile testLabelFile score lab count total threshold CMU;
testData =[];
testLabel = [];
b = [];
%testDataFile = filenm;
j=0;
for k=1:size(CMU,2)        
%	for i=1:size(imageNames,1)% reading each image  ,reSizing and reShaping
	if(j>=20 && j<30)
		b=[b CMU(1,k)];
	end
	j=j+1;
	if(j==42)
	j=0;
	end
end
for k=1:size(b,2)
		testData(:,k) = double ((b(k).pixels)');
		testLabels(k)=b(k).label;
end


b = [];
%testDataFile = filenm;
j=0;
for k=1:size(CMU,2)        
%	for i=1:size(imageNames,1)% reading each image  ,reSizing and reShaping
	if(j>=30 && j<40)
		b=[b CMU(1,k)];
	end
	j=j+1;
	if(j==42)
	j=0;
	end
end
for k=1:size(b,2)
		testData(:,k) = double ((b(k).pixels)');
		testLabels(k)=1;
end
%testLabelFile = labelnm;
%actualImageNames = importdata(char(testDataFile));
%size(actualImageNames,2)
%actualLabelNames = importdata(char(testLabelFile));    
%count = 0;
count2=0;
tic;
for k=1:size(testData,2)
%testImage = actualImageNames(k);
testMat = double (testData(:,k));
size(testMat)
size(meanImage)
testMat = testMat - meanImage;
'testMat'
givenLabel = testLabels(k);
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
	if(k>=1 && k<=690)
	count=count+1;
	else
	count2=count2+1;
	end
	break;
	end
	end
end
end
'count'
count
'count2'
count2
%if(flag==2)
%	count2=size(actualImageNames,1)-count2;
%	count = count + count2;
%	end
total = 1360
'count'
count
return;
mean(avg);
avgWeightVector(givenLabel);
end
%%-------------------------------------------------------------------------

%%---------Computes Train Data------------------------------------
function [trainData trainLabels ] = getTrainTestData()
global reSizeDim listOfExternalImageFileNames listOfExternalLabelFileNames CMU;
cou=1;cou1=1;
trainLabels =[];
trainData = [];
load CMUPIEData;
CMU = CMUPIEData;
b=[];
%size(listOfExternalImageFileNames,2);        
j=0;
for k=1:size(CMUPIEData,2)        
%	for i=1:size(imageNames,1)% reading each image  ,reSizing and reShaping
	if(j<20)
		b=[b CMUPIEData(1,k)];
	end
	j=j+1;
	if(j==42)
	j=0;
	end
end
for k=1:size(b,2)
		trainData(:,k) = double ((b(k).pixels)');
		trainLabels(k)=b(k).label;
end
end
%end
%%-------------------------------------------------------------------------

%%--------------Computes weightVector for Train Data-----------------------

function weightVector=getWeightVectorTrain()
%function getWeightVectorTrain()
weightVector = [];
global trainData numEigen eigenSet meanImage finalEigen numImages reSizeDim;
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
for i=1:numImages*68
    eValues(i) = eVal(i,i);
end

[value indices] = sort(eValues,'descend');
'Value';
size(value)
size(meanSubtractedImages)
size(eVectors)
eigenSet = zeros(reSizeDim*reSizeDim,numEigen,'double');
for i=1:numEigen
    eigenSet(:,i) = meanSubtractedImages*eVectors(:,indices(i));
end

eigenSet = normc(eigenSet);
weightVector = (eigenSet'*meanSubtractedImages)';
'Weight';
size(weightVector)
end

%%------------------------------------------------------------------------

function getAverageWeight()
		global weightVector numImages score lab;
		score = [];
		lab = [];
	for k = 1:68
		temp = pdist(weightVector(numImages*k-(numImages-1):k*numImages,:));
		'temp'
		size(temp)
		temp2 = sort(temp,'descend');
		%return;
		score = [score temp2(1:10)];
		'score'
		size(score)
		%return;
		for j = 1:10
		lab = [ lab 1];
		end
	end
	'score main'
	score
	%return;
	size(score)
	size(lab)
	%return;
	for k = 1:20:1341
	temp2 = [];
	for j = 1:20:1341
	if(j~=k)
	temp2 = [ temp2 ; weightVector(j,:)];
	%lab = [ lab 0];
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
	score = [ score tmp(1:10)];
	for j = 1:10
	lab = [lab 0];
	end
	end
	end



			
%end
