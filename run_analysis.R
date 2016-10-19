download.file(
  "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
  destfile = "UCI_HAR_Dataset.zip",
  method = "curl"
)
unzip("UCI_HAR_Dataset.zip")


#features filter and name "cleaning"
features <- read.table("UCI HAR Dataset/features.txt")
featuresMeanStd <- grepl("mean|std", features[, 2])
featuresNames <- features[, 2]
featuresNames <- gsub("[()]", "", featuresNames)
featuresNames <- gsub("Acc", "Acceleration", featuresNames)
featuresNames <- gsub("Mag", "Magnitude", featuresNames)
featuresNames <- gsub("mean", "Mean", featuresNames)
featuresNames <- gsub("std", "STD", featuresNames)
featuresNames <- gsub("Freq", "Frequency", featuresNames)
featuresMeanStd.names <- featuresNames
remove(features, featuresNames)

# load training datasets
trainingFeatures <- read.table("UCI HAR Dataset/train/X_train.txt")
trainingFeatures <- trainingFeatures[featuresMeanStd]
trainingLabels <- read.table("UCI HAR Dataset/train/y_train.txt")
trainingSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

trainingData <- cbind(trainingFeatures, trainingLabels, trainingSubjects)
remove(trainingFeatures, trainingLabels, trainingSubjects)

# load testing datasets
testingFeatures <- read.table("UCI HAR Dataset/test/X_test.txt")
testingFeatures <- testingFeatures[featuresMeanStd]
testingLabels <- read.table("UCI HAR Dataset/test/y_test.txt")
testingSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

testingData <- cbind(testingFeatures, testingLabels, testingSubjects)
remove(testingFeatures, testingLabels, testingSubjects)

# merge training and testing dataset into one dataset
data <- rbind(testingData, trainingData)
colnames(data) <- c(featuresMeanStd.names[featuresMeanStd], "activity", "subject")
remove(testingData, trainingData)

# reshaping data
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
data$subject <- as.factor(data$subject)
data$activity <- factor(data$activity, levels = activities[, 1], labels = activities[, 2])
remove(activities)

library(reshape2)

data <- melt(data, id = c("subject", "activity"), na.rm = TRUE)
tidy_data <- dcast(data,
                   subject + activity ~ variable,
                   fun.aggregate = mean,
                   na.rm = TRUE)

write.table(tidy_data,
            file = "tidy_data.txt",
            quote = FALSE,
            row.names = FALSE)

