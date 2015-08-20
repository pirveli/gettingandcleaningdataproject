#!/usr/bin/env Rscript

# load required packages
library(dplyr)

# read training set
train <- read.table("data/train/X_train.txt")
train_activities <- read.table("data/train/y_train.txt")
train_labels <- read.table("data/train/y_train.txt")
train_subject <- read.table("data/train/subject_train.txt")

# read test set
test <- read.table("data/test/X_test.txt")
test_activities <- read.table("data/test/y_test.txt")
test_labels <- read.table("data/test/y_test.txt")
test_subject <- read.table("data/test/subject_test.txt")

# read descriptive names
activity_labels <- read.table("data/activity_labels.txt")
features <- read.table("data/features.txt")

# verbose activities
train_activities$V1 <- activity_labels$V2[train_activities$V1]
test_activities$V1 <- activity_labels$V2[test_activities$V1]

# add descriptive column names
names(train) <- features$V2
names(train_activities) <- c("activity")
names(train_subject) <- c("subject")
names(test) <- features$V2
names(test_activities) <- c("activity")
names(test_subject) <- c("subject")

# extracting columns numbers with mean and standard deviation
mean_columns <- which(grepl("-mean()", features$V2, fixed=TRUE))
std_columns <- which(grepl("-std()", features$V2, fixed=TRUE))
selected_columns <- c(mean_columns, std_columns)
selected_columns <- sort(selected_columns)

# subset data
train <- train[, selected_columns]
test <- test[, selected_columns]

# merge subjects with activities and measurements
merged_train <- cbind(train_subject, train_activities)
merged_train <- cbind(merged_train, train)
merged_test <- cbind(test_subject, test_activities)
merged_test <- cbind(merged_test, test)

merged <- rbind(merged_train, merged_test)

# prepare verbose column names
new.names <- c("subject", "activity", 
               # time domain
               "body.acceleration.mean.x.time", "body.acceleration.mean.y.time", "body.acceleration.mean.z.time", 
               "body.acceleration.std.x.time", "body.acceleration.std.y.time", "body.acceleration.std.z.time",
               
               "gravity.acceleration.mean.x.time", "gravity.acceleration.mean.y.time", "gravity.acceleration.mean.z.time", 
               "gravity.acceleration.std.x.time", "gravity.acceleration.std.y.time", "gravity.acceleration.std.z.time", 
               
               "body.acceleration.jerk.mean.x.time", "body.acceleration.jerk.mean.y.time", "body.acceleration.jerk.mean.z.time", 
               "body.acceleration.jerk.std.x.time", "body.acceleration.jerk.std.y.time", "body.acceleration.jerk.std.z.time",
               
               "body.gyro.mean.x.time", "body.gyro.mean.y.time", "body.gyro.mean.z.time", 
               "body.gyro.std.x.time", "body.gyro.std.y.time", "body.gyro.std.z.time",
               
               "body.gyro.jerk.mean.x.time", "body.gyro.jerk.mean.y.time", "body.gyro.jerk.mean.z.time",
               "body.gyro.jerk.std.x.time", "body.gyro.jerk.std.y.time", "body.gyro.jerk.std.z.time",
               
               "body.acceleration.magnitude.mean.time", "body.acceleration.magnitude.std.time",
               "gravity.acceleration.magnitude.mean.time", "gravity.acceleration.magnitude.std.time", 
               
               "body.acceleration.jerk.magnitude.mean.time", "body.acceleration.jerk.magnitude.std.time",
               
               "body.gyro.magnitude.mean.time", "body.gyro.magnitude.std.time",
               "body.gyro.jerk.magnitude.mean.time", "body.gyro.jerk.magnitude.std.time",
               
               # frequency domain
               
               "body.acceleration.mean.x.freq", "body.acceleration.mean.y.freq", "body.acceleration.mean.z.freq", 
               "body.acceleration.std.x.freq", "body.acceleration.std.y.freq", "body.acceleration.std.z.freq",
               
               "body.acceleration.jerk.mean.x.freq", "body.acceleration.jerk.mean.y.freq", "body.acceleration.jerk.mean.z.freq", 
               "body.acceleration.jerk.std.x.freq", "body.acceleration.jerk.std.y.freq", "body.acceleration.jerk.std.z.freq",
               
               "body.gyro.mean.x.freq", "body.gyro.mean.y.freq", "body.gyro.mean.z.freq", 
               "body.gyro.std.x.freq", "body.gyro.std.y.freq", "body.gyro.std.z.freq",
               
               "body.acceleration.magnitude.mean.freq", "body.acceleration.magnitude.std.freq",
               "body.acceleration.jerk.magnitude.mean.freq", "body.acceleration.jerk.magnitude.std.freq",
               
               "body.gyro.magnitude.mean.freq", "body.gyro.magnitude.std.freq",
               "body.gyro.jerk.magnitude.mean.freq", "body.gyro.jerk.magnitude.std.freq")

# set verbose names
names(merged) <- new.names

# create tbl_df 
merged_tbl <- tbl_df(merged)


# group data by subject and activity
grouped <- group_by(merged, subject, activity)

# calculate required means and assign the result to a new variable
tidy <- summarise_each(grouped, funs(mean))

# write tidy data to file
write.table(tidy, "tidy.txt", row.name=FALSE)
