variableNames <- read.table("~/Downloads/UCI HAR Dataset/features.txt")
filteredVariableIdx <- sapply(variableNames[,2],FUN=str_detect,pattern="mean\\(|std\\(")

TrainSet <- read.table("~/Downloads/UCI HAR Dataset/train/X_train.txt")
names(TrainSet) <- variableNames[,2]
TrainSet <- TrainSet[,filteredVariableIdx]
TrainSubjects <- read.table("~/Downloads/UCI HAR Dataset/train/subject_train.txt")
TrainLabels <- read.table("~/Downloads/UCI HAR Dataset/train/Y_train.txt")

TestSet <- read.table("~/Downloads/UCI HAR Dataset/test/X_test.txt")
names(TestSet) <- variableNames[,2]
TestSet <- TestSet[,filteredVariableIdx]
TestSubjects <- read.table("~/Downloads/UCI HAR Dataset/test/subject_test.txt")
TestLabels <- read.table("~/Downloads/UCI HAR Dataset/test/Y_test.txt")

overallData <- rbind(TrainSet,TestSet)

names(overallData) <- sapply(names(overallData),str_replace,"\\(\\)","")
names(overallData) <- sapply(names(overallData),str_replace,"fBody","Freq-")
names(overallData) <- sapply(names(overallData),str_replace,"tBody","Time-")

overallData$ActivityLabel <- rbind(TrainLabels,TestLabels)
overallData$Subject <- rbind(TrainSubjects,TestSubjects)[,1]

activityFactor = read.table("~/Downloads/UCI HAR Dataset/activity_labels.txt")
activityFactor <- activityFactor[,2]

overallData$ActivityLabel <- mapply(function(x) activityFactor[x],overallData$ActivityLabel)

tidyOverall = data.table(overallData)[, lapply(.SD, mean), by=c("ActivityLabel","Subject")]

write.table(tidyOverall,"tidy_dataset.txt",row.name=FALSE)