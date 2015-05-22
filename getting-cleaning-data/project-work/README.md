# Project - Getting and Cleaning Data

**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [About Project](#)
- [Project Data](#)
- [Project Objective](#)
- [R Script](#)
- [Code Book](#)

*********
# About Project
The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

# Project Data
[Data Link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

Download and extract above file. Below is the directory structure.

1. UCI HAR Dataset
     + train (have all training data set)
     + test (have all test data set)
     + README.txt
     + features_info.txt
     + features.txt
     + activit_labels.txt

More information on relation of above data files is in <span style="color:red;">`CodeBook.md`</span> file.

# Project Objective
You should create one R script that does the following. 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# R Script
<span style="color:red;">`run_analysis.R`</span> is the script performing the cleaning of data and producing tidy data set for later analysis.

# Code Book
Describes the variables, the data, and any transformations or work that was performed to clean up the data

*******
