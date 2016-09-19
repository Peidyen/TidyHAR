#Human Activity Recognition Using Smartphones

### Introduction

This codebook file describes the data variables and processes used.

### Data Set Description

Per the authors of the data: 
"The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.


#### Attribute Information

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.

#### Files
* 'features_info.txt': Shows information about the variables used on the feature vector.
* 'features.txt': List of all features.
* 'activity_labels.txt': Links the class labels with their activity name.
* 'train/X_train.txt': Training set.
* 'train/y_train.txt': Training labels.
* 'test/X_test.txt': Test set.
* 'test/y_test.txt': Test labels.
* 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
* 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
* 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
* 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

### Variables

From the Authors of the study:  
Feature Selection 
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag


There are a total of 561 variables referenced in the original dataset.

# Data Transformations

## Load test and training sets and the activities

###Read Test Data
```
testDataSet = read.csv("test/X_test.txt", sep="", header=FALSE)
testDataSet[,562] = read.csv("test/Y_test.txt", sep="", header=FALSE)
testDataSet[,563] = read.csv("test/subject_test.txt", sep="", header=FALSE)
```

###Read trainingDataSet Data
```
trainingDataSet = read.csv("train/X_train.txt", sep="", header=FALSE)
trainingDataSet[,562] = read.csv("train/Y_train.txt", sep="", header=FALSE)
trainingDataSet[,563] = read.csv("train/subject_train.txt", sep="", header=FALSE)
```

### Get the list of labels
```
activityLabels = read.csv("activity_labels.txt", sep="", header=FALSE)
```

### Adjust attributes
```
attributes = read.csv("features.txt", sep="", header=FALSE)
attributes[,2] = gsub('-mean', 'Mean', attributes[,2])
attributes[,2] = gsub('-std', 'Std', attributes[,2])
attributes[,2] = gsub('[-()]', '', attributes[,2])
```

### Criteria #1:  Merges the training and the test sets to create one data set.
### Merge both data sets together
```
fullData = rbind(trainingDataSet, testDataSet)
```


### Criteria# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
### Limit the data to the mean and the standard deviation.
```
desiredColumns <- grep(".*Mean.*|.*Std.*", attributes[,2])
```
### First reduce the attributes table to what we want
```
attributes <- attributes[desiredColumns,]
```

### Add columns for subject and activity
```
desiredColumns <- c(desiredColumns, 562, 563)
```

### And remove the unwanted columns from fullData
```
fullData <- fullData[,desiredColumns]
```

### Criteria #4. Appropriately labels the data set with descriptive variable names. 
### Add the column names (attributes) to fullData
```
colnames(fullData) <- c(attributes$V2, "Activity", "Subject")
colnames(fullData) <- tolower(colnames(fullData))
```

### Criteria #3. Uses descriptive activity names to name the activities in the data set
### Subset by Activity and Subject
```
currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
  fullData$activity <- gsub(currentActivity, currentActivityLabel, fullData$activity)
  currentActivity <- currentActivity + 1
}

fullData$activity <- as.factor(fullData$activity)
fullData$subject <- as.factor(fullData$subject)
```

### Criteria # 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
### Aggregate the data by variable and subject.
```
tidy = aggregate(fullData, by=list(activity = fullData$activity, subject=fullData$subject), mean)
```

### The mean of these two columns have no meaning.
```
tidy[,90] = NULL
tidy[,89] = NULL
```

###change directory to store the text file in the root working directory.
```
setwd("D://temp/TidyHAR/")
write.table(tidy, "tidy.txt", sep="\t")
```


