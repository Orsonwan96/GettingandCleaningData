library(dplyr)

filename <- "E:/WorkTools/CodingTools/DataScience/DataScienceCoursera/GettingandCleaningData/AssignmentData.zip"


##Download the data file and unzip
if(!file.exists(filename)) {
    fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileurl, filename)
}
if(!file.exists("UCI HAR Dataset")){
    unzip(filename)
}

##read train data
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
Subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

##read test data
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
Subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

##read data features
features <- read.table("./UCI HAR Dataset/features.txt")

##read activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

##merge train and test data 
X_total <- rbind(X_train, X_test)
Y_total <- rbind(Y_train, Y_test)
Subject_total <- rbind(Subject_train, Subject_test)

##extract the selected measurements
Selected_Features <- features[grep(".*mean.*|.*std.*", features[, 2]), ]
X_total <- X_total[, Selected_Features[, 1]]

##descriptive activity
colnames(Y_total) <- "activity"
Y_total$ActivityLabels <- factor(Y_total$activity, labels = activity_labels[,2])
ActivityLabels <- Y_total[, 2]

##labels the data set with descriptive variable names.
colnames(X_total) <- features[Selected_Features[,1],2]

##
colnames(Subject_total) <- "subject"
data <- cbind(X_total, ActivityLabels, Subject_total)
total_mean <- data %>% group_by(ActivityLabels, subject) %>% summarize_all(funs(mean))
write.table(total_mean, file = "./UCI HAR Dataset/results.txt", row.names = FALSE, col.names = TRUE)
