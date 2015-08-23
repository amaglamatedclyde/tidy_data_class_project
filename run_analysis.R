# This script produces an output when the working directory contains the unzipped UCI HAR dataset
# Uncomment the lines below to download the original file into an EMPTY directory and unzip it.

# setwd(<choose an empty directory for the project>)
# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","project_data.zip", method = "libcurl")
# data_folders <- list.files() #returns only one filename, "project_data.zip" because we started with an empty directory
# 
# # we unzip the downloaded data file which creates a directory structure in our project folder. 
# # inspection of the README files shows that the data tables we are interested in merging and their label data
# # are found in the 4 paths below
# 
# unzip(data_folders) 

library(dplyr)

#first load the tables from the test set folder. they are X_test, y_test, and subject_test 
test_set_path <- "UCI HAR Dataset/test/X_test.txt"
test_set_label_path <- "UCI HAR Dataset/test/y_test.txt"
test_set_subject_path <- "UCI HAR Dataset/test/subject_test.txt"
test_set <- read.table(test_set_path) 
test_set_labels <- read.table(test_set_label_path)
test_set_subjects <- read.table(test_set_subject_path)
label <- as.vector(test_set_labels[ ,1])
subject <- as.vector(test_set_subjects[ ,1])
test_set_complete <-  mutate(test_set, subject, label) 

# now we perform the same operations on the training set
train_set_path <- "UCI HAR Dataset/train/X_train.txt"
train_set_label_path <- "UCI HAR Dataset/train/y_train.txt"
train_set_subject_path <- "UCI HAR Dataset/train/subject_train.txt"
train_set <- read.table(train_set_path) 
train_set_labels <- read.table(train_set_label_path)
train_set_subjects <- read.table(train_set_subject_path)
label <- as.vector(train_set_labels[ ,1])
subject <- as.vector(train_set_subjects[ ,1])
train_set_complete <-  mutate(train_set, subject, label) 

# now merge the train and test sets
complete_set <- merge(test_set_complete, train_set_complete, all=TRUE) #merge the train and test sets
# identical(colnames(train_set), colnames(test_set)) let's just be sure the data colnames are identical!
#clean-up environment
rm(list = c("test_set", "test_set_complete", "test_set_labels", "test_set_subjects", "train_set", 
            "train_set_complete", "train_set_labels", "train_set_subjects", "test_set_path", "train_set_path", 
            "test_set_subject_path","train_set_subject_path", "test_set_label_path", "train_set_label_path"))

# change the colnames to the descriptive names of the corresponding features
# so we can select the variables of interest, mean and std, by name
feature_label_path <- "UCI HAR Dataset/features.txt"
feature_table <- read.table(feature_label_path, stringsAsFactors = FALSE)
feature_names <- as.vector(feature_table[,2])
feature_names <- append(feature_names, c("subject", "label"), after = length(feature_names)) # add the names of the 
  # 2 columns we created
if(!identical(make.names(feature_names), feature_names))
  {feature_names <-  make.names(feature_names, unique = TRUE)} #be sure the var names are valid R names, 
  # some original names contain ()
complete_set_with_feature_named_cols <- `colnames<-`(complete_set, feature_names) #finally add the feature names
  # as colnames

rm(list = c("complete_set", "feature_table", "feature_names", "feature_label_path")) #optionally clean-up environment

#subset the data to retain only variables with "mean" and "std()". see README.md for explanation
variables_of_interest <- select(complete_set_with_feature_named_cols, contains("std.."), contains("mean"), 
                                subject, label) #select columns with mean and std

rm(complete_set_with_feature_named_cols) #optionally clean-up environment

# use descriptive activity names instead of "label" column integer values
activity_table <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
activity_list <- as.list(activity_table[,2]) # here we take a 2-col table and make a list so we can look up names 
  # corresponding to integers
label_column <- variables_of_interest[["label"]] #extract the label col as a vector
exchange <- function(item){activity_list[[item]]} #create a utility function to transform labels into activity names
activity <- sapply(label_column, exchange) #create activity column as vector

variables_of_interest <- variables_of_interest %>% mutate(activity) %>% select(-label) %>%
  arrange(subject, activity)#add activity col, delete label col, arrange rows by subject and activity
rm(list = c("activity", "activity_list"))

# now perform the operations to generate the final table
summary_table <- group_by(variables_of_interest, activity, subject)
rm(list = c("variables_of_interest", "activity_table", "exchange", "label", "label_column", "subject"))
summary_table <- summarise_each(summary_table, funs(mean))
colnames(summary_table)[3:88] <- paste("meanof", colnames(summary_table)[3:88], sep = "") #make sure we update 
#the var names to reflect the operations performed by summarize_each()

#format variable names as recommended in video lecture Week 4 "Editing Text Variables"
colnames(summary_table) <- tolower(colnames(summary_table))
colnames(summary_table) <- gsub("\\.", "", colnames(summary_table))

summary_table <- data.frame(summary_table) #collapse the class inheritance structure to data.frame