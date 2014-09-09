Getting and Cleaning Data Course Project Read Me File
========================================================
Problem Statement can be found in this link: https://class.coursera.org/getdata-007/human_grading/view/courses/972585/assessments/3/submissions

*run_analysis function* reads multiple data files from Samsung Dataset, merges those files into a single file and outputs a smaller tidy data file in the working directory.

Th output file is called _"TidyDataSet.txt"_

You need to install **plyr** package

There are 2 other files submitted 
Run_analysis.R script file
Code Book


This code block reads training files, feature labels and activity label files into their data sets.
Working directory is set as UCI HAR Dataset folder and it gets the wd by using getwd.


```r
  library("plyr")

  xtrain<-paste0(getwd(),"/train/X_train.txt")
  activitylabelsfile<-paste0(getwd(),"/activity_labels.txt")
  subjecttrainfile<-paste0(getwd(),"/train/subject_train.txt")
  trainactivitylabelsfile<-paste0(getwd(),"/train/y_train.txt")
  
  
  featurestrain<-read.table(xtrain)

  activitylabels<-read.table("activity_labels.txt")

  featurelabels<-read.table("features.txt")
```

This part assigns feature data set , appropriate varible names which are kept in featurelabels dataset.
It merges subjects (subject train dataset) and assigns activity labels listed in y_train.txt file with featurestrain data set.



```r
names(featurestrain)<-featurelabels[,2]
  
  
  category<-rep("train",nrow(featurestrain))
  featurestrain$category<-category[1:length(category)]
  subjecttrain<-read.table(subjecttrainfile)
                           
  featurestrain$subject<-subjecttrain[,1]
  
  trainactivitylabels<-read.table(trainactivitylabelsfile)
  trainactivitylabels[,1]<-as.factor(trainactivitylabels[,1])
 
    levels(trainactivitylabels[,1])<-activitylabels[,2]
  
  featurestrain$activitylabel<-trainactivitylabels[,1]
```
This code block does the equivalent things for test data.



```r
  featurestestfile<-paste0(getwd(),"/test/X_test.txt")
  subjecttestfile<-paste0(getwd(),"/test/subject_test.txt")
  testactivitylabelsfile<-paste0(getwd(),"/test/y_test.txt")
  
  featurestest<-read.table(featurestestfile)

  
  names(featurestest)<-featurelabels[,2]
  
  
  categorytest<-rep("test",nrow(featurestest))
  featurestest$category<-categorytest[1:length(categorytest)]
  subjecttest<-read.table(subjecttestfile)
  featurestest$subject<-subjecttest[,1]
  
  testactivitylabels<-read.table(testactivitylabelsfile)
  testactivitylabels[,1]<-as.factor(testactivitylabels[,1])
  
 
  levels(testactivitylabels[,1])<-activitylabels[,2]
  
  featurestest$activitylabel<-testactivitylabels[,1]
```

This part merges training and test data sets into a single dataset called *mergedTable*.
It greps standard deviation and mean measurement variables from mergedTable.
It stores captured variables, activity labels and subject columns in *TT* dataset.
It applies *ddply* function to calculate averages of all columns per activity label per subject.
The calculated means are stored in *tidy* dataset.
tidy dataset is saved to *TidyDataSet.txt* file.

```r
table(names(featurestrain)==names(featurestest))
  mergedTable<-rbind(featurestrain,featurestest)
  
  
  index<-grep("mean|std",names(mergedTable),ignore.case=TRUE)
  TT<-mergedTable[,index]
  TT<-cbind(TT,subject=mergedTable$subject)
  TT<-cbind(TT,activity=mergedTable$activitylabel)
 
  TT$subject<-as.factor(TT$subject)
  TT$activity<-as.factor(TT$activity)
 tidy<-ddply(TT,.(subject,activity),colwise(mean))
 write.table(tidy,"TidyDataSet.txt",row.names=FALSE)
```
