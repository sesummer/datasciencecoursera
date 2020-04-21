---
title: "Getting and Cleaning Data Assignment Week 4"
output: html_document
---

## Variable Names
This file contains the names of the variables, and we'll be extracting just the
mean and standard deviation variables.
```
variableNames <- read.table("~/Downloads/UCI HAR Dataset/features.txt")
filteredVariableIdx <- sapply(variableNames[,2],FUN=str_detect,pattern="mean\\(|std\\(")
```

## Data Sets
These data sets include accelerometer readings from 32 subjects performing
6 different activites in the form of a training and test sets.
```
TrainSet <- read.table("~/Downloads/UCI HAR Dataset/train/X_train.txt")
TrainSubjects <- read.table("~/Downloads/UCI HAR Dataset/train/subject_train.txt")
TrainLabels <- read.table("~/Downloads/UCI HAR Dataset/train/Y_train.txt")

TestSet <- read.table("~/Downloads/UCI HAR Dataset/test/X_test.txt")
TestSubjects <- read.table("~/Downloads/UCI HAR Dataset/test/subject_test.txt")
TestLabels <- read.table("~/Downloads/UCI HAR Dataset/test/Y_test.txt")
```

## Combining the Data Sets
This part assigns the variable names to the measurements.
```
names(TestSet) <- variableNames[,2]
TestSet <- TestSet[,filteredVariableIdx]
names(TrainSet) <- variableNames[,2]
TrainSet <- TrainSet[,filteredVariableIdx]
```
This cleans combines the test and training sets then makes the variables names
a little easier to read.
```
overallData <- rbind(TrainSet,TestSet)

names(overallData) <- sapply(names(overallData),str_replace,"\\(\\)","")
names(overallData) <- sapply(names(overallData),str_replace,"fBody","Freq-")
names(overallData) <- sapply(names(overallData),str_replace,"tBody","Time-")
```
This appends the activity label and subject number to the measurements.
```
overallData$ActivityLabel <- rbind(TrainLabels,TestLabels)
overallData$Subject <- rbind(TrainSubjects,TestSubjects)[,1]
```
This will convert the activity index to the actual name of the activity performed.
```
activityFactor = read.table("~/Downloads/UCI HAR Dataset/activity_labels.txt")
activityFactor <- activityFactor[,2]
```

## Tidying the data set
This will take a mean for all of the variables for each subject and activity, 
then write the tidy data set to a new file.
```
tidyOverall = data.table(overallData)[, lapply(.SD, mean), by=c("ActivityLabel","Subject")]
write.table(tidyOverall,"tidy_dataset.txt",row.name=FALSE)
```