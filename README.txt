Face Recognition
	-By
		Shubham Sangal ( 201101008 )
		J N Venkatesh ( 201102007 )

The Folder contains basically 4 important folders:

---------------------------------------------------------------------------------------
Warning: You need Yale Dataset for Part A and Part C. Students Dataset as well for bonus.
These are not included here

PartA+D:
	contains codes for:
		1) Identification of yale dataset (Yale.m) - give command " Yale(<no of eigenvectors>)"
		2) Verification of yale dataset (Yale_Verification.m) - give command "Yale_Verification"
		3) Reconstruction of Images ( Reconstruct_Yale.m ) - give command "Reconstruct_Yale(1) for image reconstrution from dataset"	or " Reconstruct_Yale(2) for image reconstrution of obama.jpg " or " Reconstruct_Yale(1) for image reconstrution of res.jpg" 
	
	Caution : The folder doesnot contain Yale Dataset " CroppedYale" since it is very big. So put folder CroppedYale first in this folder and then run these commands else they wont work.  

PartB:
	contains codes for:
		1) Identification of CMU dataset (cmu.m) - give command "cmu(<no of eigenvectors>)"
		2) Verification of CMU dataset (CMUverify.m) - give command "CMUverify"
		
		CMUPIEData.mat is the dataset file containing information of all images in a struct datastructue.

PartC:
	contains codes for:
		1) Identification of Yale dataset using libsvm. ( SVM.m)
		2) make.m , svmpredict.mexa64 , svmtrain.mexa64 are libsvm library files downloaded from net. Without these SVM.m won't work.
		
		Exexute Instruction:
			Step 1: make
			Step 2: SVM 
		"This will work only with Linux"
		If it dont work this way...install libsvm.. then it has a subfolder matlab.. put SVM.m in it.. then do make and then try running it.

		Caution : The folder doesnot contain Yale Dataset " CroppedYale" since it is very big. So put folder CroppedYale first in this folder and then run these commands else they wont work.

StudentsDataSet:
		contains codes for:
			Identification of Students batch 2013 (sd1.m)
			Also contains images of students.
		Execute Instructions:
			sd1(<no of eigenvectors>)

--------------------------------------------------------------------------------------------------------------------  
 
