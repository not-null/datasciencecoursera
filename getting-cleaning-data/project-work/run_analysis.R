# Always start fresh i.e. cleanup

rm(list=ls())

# set current working directory
setwd("/Users/himanshurawat/coursera/datasciencecoursera/getting-cleaning-data/project-work/")

# Get hold of neccessary packages and load 
library(dplyr)

# Need to format below information
# Data that has been provided, in a simpler terms can be linked as follow
#   1. features.txt [561 X 2]. Every row (2nd col) is a observation label.
#       for e.g tBodyAcc-mean()-X can be interpreted as "Time Body Accelerometer - Mean taken - along X axis"
#
#   2. X_test.txt [2497 X 561]. Every column is measurement value
#
#   3. Both (1) and (2) are linked. Every row (2nd col) in features.txt corresponds to column value in X_test.txt.
#       
#      Note: Same interpertation is applicable to X_train.txt as well.

# Read the common data
activity.labels <- read.table("./UCI HAR Dataset/activity_labels.txt", nrows=6,header = F, stringsAsFactors = FALSE)
features <- read.table("./UCI HAR Dataset/features.txt", nrows=561,header = F, stringsAsFactors = FALSE)

# Read the test data
test.observations <- read.table("./UCI HAR Dataset/test/X_test.txt",nrows = 2947, header = F, stringsAsFactors = FALSE)
test.activity <- read.table("./UCI HAR Dataset/test/y_test.txt", nrows = 2947,header = F, stringsAsFactors = FALSE)
test.subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt",nrows = 2947, header = F, stringsAsFactors = FALSE)

# Read the training data
train.observations <- read.table("./UCI HAR Dataset/train/X_train.txt", nrows = 7352,header = F, stringsAsFactors = FALSE)
train.activity <- read.table("./UCI HAR Dataset/train/y_train.txt", nrows = 7352,header = F, stringsAsFactors = FALSE)
train.subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt", nrows = 7352,header = F, stringsAsFactors = FALSE)

# Merge test and train data
merged.observations <- bind_rows(test.observations,train.observations)
merged.activity <- bind_rows(test.activity, train.activity)
merged.subjects <- bind_rows(test.subjects, train.subjects)

# Give col names to merged observation. It links features.txt
colnames(merged.observations) <- features[,2]
colnames(merged.activity) <- "Activity"
colnames(merged.subjects) <- "Subjects"

final.merge <- bind_cols(merged.subjects,merged.activity, merged.observations)

# search for columns names having mean and std
columns.filter <- grep("*-mean()|*-std()", names(final.merge) , ignore.case = TRUE)
# Add Subjects and Activity columns
columns.filter <- c(1,2,columns.filter)

final.merge.filtered <- final.merge[,columns.filter]

# Change the activity names to descriptive information
final.merge.filtered$Activity <- as.character(final.merge.filtered$Activity)
final.merge.filtered$Activity[which(final.merge.filtered$Activity == 1)] <- activity.labels[[2]][1]
final.merge.filtered$Activity[which(final.merge.filtered$Activity == 2)] <- activity.labels[[2]][2]
final.merge.filtered$Activity[which(final.merge.filtered$Activity == 3)] <- activity.labels[[2]][3]
final.merge.filtered$Activity[which(final.merge.filtered$Activity == 4)] <- activity.labels[[2]][4]
final.merge.filtered$Activity[which(final.merge.filtered$Activity == 5)] <- activity.labels[[2]][5]
final.merge.filtered$Activity[which(final.merge.filtered$Activity == 6)] <- activity.labels[[2]][6]

#Give expanded and meaningful names
names(final.merge.filtered)<-gsub("Acc", "Accelerometer", names(final.merge.filtered))
names(final.merge.filtered)<-gsub("Gyro", "Gyroscope", names(final.merge.filtered))
names(final.merge.filtered)<-gsub("BodyBody", "Body", names(final.merge.filtered))
names(final.merge.filtered)<-gsub("Mag", "Magnitude", names(final.merge.filtered))
names(final.merge.filtered)<-gsub("^t", "Time", names(final.merge.filtered))
names(final.merge.filtered)<-gsub("^f", "Frequency", names(final.merge.filtered))
names(final.merge.filtered)<-gsub("tBody", "TimeBody", names(final.merge.filtered))
names(final.merge.filtered)<-gsub("-mean()", "Mean", names(final.merge.filtered), ignore.case = TRUE)
names(final.merge.filtered)<-gsub("-std()", "SD", names(final.merge.filtered), ignore.case = TRUE)
names(final.merge.filtered)<-gsub("-freq()", "Frequency", names(final.merge.filtered), ignore.case = TRUE)
names(final.merge.filtered)<-gsub("angle", "Angle", names(final.merge.filtered))
names(final.merge.filtered)<-gsub("gravity", "Gravity", names(final.merge.filtered))

# Get the average of all the observation variable columns by Subjects and Activity
tds <- final.merge.filtered %>% group_by(Activity,Subjects) %>% summarise_each(funs(mean))

# Finally write tidy data set to a file
write.table(tds, file = "tidy-data-set.txt", row.names = FALSE, sep = ",")








