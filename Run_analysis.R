
#comments are given in readme file. 
run_analysis<-function(){
  library("plyr")
  wd<-getwd()
  xtrain<-paste0(getwd(),"/train/X_train.txt")
  activitylabelsfile<-paste0(getwd(),"/activity_labels.txt")
  subjecttrainfile<-paste0(getwd(),"/train/subject_train.txt")
  trainactivitylabelsfile<-paste0(getwd(),"/train/y_train.txt")
  
  
  featurestrain<-read.table(xtrain)

  activitylabels<-read.table("activity_labels.txt")

  featurelabels<-read.table("features.txt")
 
  
  names(featurestrain)<-featurelabels[,2]
  
  
  category<-rep("train",nrow(featurestrain))
  featurestrain$category<-category[1:length(category)]
  subjecttrain<-read.table(subjecttrainfile)
                           
  featurestrain$subject<-subjecttrain[,1]
  
  trainactivitylabels<-read.table(trainactivitylabelsfile)
  trainactivitylabels[,1]<-as.factor(trainactivitylabels[,1])
 
    levels(trainactivitylabels[,1])<-activitylabels[,2]
  
  featurestrain$activitylabel<-trainactivitylabels[,1]
  
  
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
 
}