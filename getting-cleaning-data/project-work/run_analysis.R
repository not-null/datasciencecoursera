# Always start fresh i.e. cleanup

rm(list=ls())

# set current working directory
setwd("/Users/himanshurawat/coursera/datasciencecoursera/getting-cleaning-data/project-work/")

# Get hold of neccessary packages and load 
library(dplyr)

# Read all the data
files <- file.path("./UCI HAR Dataset", c("activity_labels.txt", "features.txt", "test/X_test.txt", "test/y_test.txt", "test/subject_test.txt", "train/X_train.txt", "train/y_train.txt", "train/subject_train.txt"))
data <- lapply(files, read.table, header = F, stringsAsFactors = FALSE)
names(data) <- gsub(".*/(.*)\\..*", "\\1", files)

# Merge test and train data
merged.observations <- bind_rows(data$X_test,data$X_train)
merged.activity <- bind_rows(data$y_test, data$y_train)
merged.subjects <- bind_rows(data$subject_test, data$subject_train)

# Merge and give meaningful column names
final.merge <- bind_cols(merged.subjects,merged.activity, merged.observations)
colnames(final.merge) <- c("Subjects" , "Activity" , data$features[,2])

# search for columns names having mean and std
columns.filter <- grep("*-mean()|*-std()", names(final.merge) , ignore.case = TRUE)
# Add Subjects and Activity columns
columns.filter <- c(1,2,columns.filter)

final.merge.filtered <- final.merge[,columns.filter]

# Change the activity names to descriptive information
final.merge.filtered$Activity <- factor(final.merge.filtered$Activity, levels=c(1,2,3,4,5,6), labels=data$activity_labels$V2)

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








