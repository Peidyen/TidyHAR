### 1. Merges the training and the test sets to create one data set.
### 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
### 3. Uses descriptive activity names to name the activities in the data set
### 4. Appropriately labels the data set with descriptive variable names. 
### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


setwd("D://temp/TidyHAR/data/")

###Read Test Data
testDataSet = read.csv("test/X_test.txt", sep="", header=FALSE)
testDataSet[,562] = read.csv("test/Y_test.txt", sep="", header=FALSE)
testDataSet[,563] = read.csv("test/subject_test.txt", sep="", header=FALSE)

###Read trainingDataSet Data
trainingDataSet = read.csv("train/X_train.txt", sep="", header=FALSE)
trainingDataSet[,562] = read.csv("train/Y_train.txt", sep="", header=FALSE)
trainingDataSet[,563] = read.csv("train/subject_train.txt", sep="", header=FALSE)


### Get the list of labels
activityLabels = read.csv("activity_labels.txt", sep="", header=FALSE)

### Adjust attributes
attributes = read.csv("features.txt", sep="", header=FALSE)
attributes[,2] = gsub('-mean', 'Mean', attributes[,2])
attributes[,2] = gsub('-std', 'Std', attributes[,2])
attributes[,2] = gsub('[-()]', '', attributes[,2])

# Merge both data sets together
fullData = rbind(trainingDataSet, testDataSet)

# Limit the data to the mean and the standard deviation.
desiredColumns <- grep(".*Mean.*|.*Std.*", attributes[,2])

# First reduce the attributes table to what we want
attributes <- attributes[desiredColumns,]

# Add columns for subject and activity
desiredColumns <- c(desiredColumns, 562, 563)

# And remove the unwanted columns from fullData
fullData <- fullData[,desiredColumns]

# Add the column names (attributes) to fullData
colnames(fullData) <- c(attributes$V2, "Activity", "Subject")
colnames(fullData) <- tolower(colnames(fullData))

currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
  fullData$activity <- gsub(currentActivity, currentActivityLabel, fullData$activity)
  currentActivity <- currentActivity + 1
}

fullData$activity <- as.factor(fullData$activity)
fullData$subject <- as.factor(fullData$subject)

tidy = aggregate(fullData, by=list(activity = fullData$activity, subject=fullData$subject), mean)
# The mean of these two columns have no meaning.
tidy[,90] = NULL
tidy[,89] = NULL


#change directory to store the text file in the root working directory.
setwd("D://temp/TidyHAR/")
write.table(tidy, "tidy.txt", sep="\t")


