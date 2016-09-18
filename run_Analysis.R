# 1.Merges the training and the test sets to create one data set.
# 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3.Uses descriptive activity names to name the ActsObject in the data set
# 4.Appropriately labels the data set with descriptive variable names. 
# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Ensure we have proper libraries:
library(data.table)

# 1.Merges the training and the test sets to create one data set.

#      start by downloading the files
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileUrl, destfile = "Dataset.zip")

unzip("Dataset.zip")

testSet <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
testSetActivities <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
testSetSub <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
trainSet <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
trainSetActivities <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
trainSetSub <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)


# 3.Uses descriptive activity names to name the ActsObject in the data set
ActsObject <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")
testSetActivities$V1 <- factor(testSetActivities$V1,levels=ActsObject$V1,labels=ActsObject$V2)
trainSetActivities$V1 <- factor(trainSetActivities$V1,levels=ActsObject$V1,labels=ActsObject$V2)


# 4.Appropriately labels the data set with descriptive variable names. 
features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")
colnames(testSet)<-features$V2
colnames(trainSet)<-features$V2
colnames(testSetActivities)<-c("Activity")
colnames(trainSetActivities)<-c("Activity")
colnames(testSetSub)<-c("Subject")
colnames(trainSetSub)<-c("Subject")

#1.  Merges the training and the test sets to create one data set.
testSet<-cbind(testSet,testSetActivities)
testSet<-cbind(testSet,testSetSub)
trainSet<-cbind(trainSet,trainSetActivities)
trainSet<-cbind(trainSet,trainSetSub)
aggregateData<-rbind(testSet,trainSet)

# 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
aggregateDataMean<-sapply(aggregateData,mean,na.rm=TRUE)
aggregateDataStandardDeviation<-sapply(aggregateData,sd,na.rm=TRUE)



# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
DT <- data.table(aggregateData)
tidy<-DT[,lapply(.SD,mean),by="Activity,Subject"]
write.table(tidy,file="tidy.csv",sep=",",col.names = NA)
