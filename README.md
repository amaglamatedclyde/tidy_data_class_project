#Tidy Data Class Project
## Cleaning the UCI HAR Dataset
This repo contains my submissions for the 'Getting and Cleaning Data' class project

The script file 'run_analysis.R' produces a table that summarizes the UCI HAR Dataset. The final table
is called 'summary_table' and consists of 180 observations of 88 variables.

The original dataset, found at <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>, consists of 10299 observations of 561 variables, split into two sets of observations. The observed variables are accelerometer and gyroscope data collected from 30 test subjects as they performed multiple trials of six different activites: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.

* The script first creates tables from the split sets, 'test' and 'training', in order to merge them into the complete set of observations. The activity labels and subject IDs are added to the individual sets as columns prior to merging.

* in the next step of the script, we extract the descriptive names of the variables from the file 'features.txt' and replace the column names of the complete_set table with these names. The explanation of these names can be found in the code book provided in this repository and originate in the file 'feature_info.txt', the text of which has been appended to the Code Book. It should be noted that not all of the orginal variable names are valid R variable names so the make.names() function is used to legalize them.

* Next we subset the variables of interest from the table using dplyr select(). These are all of the variables that are calculated means or standard deviations. I've chosen to include all varibles with the word 'mean' in the title, rather than arbitrarily eliminate them because they don't follow the pattern of indicating a mean function has been applied by using parentheses, i.e. "mean().""

* At this step the 'label' column consists of integer values that correspond to the activites performed when test subject measurements were taken. We create a column 'activity' and substitute the descriptive names of the activities as they correspond to the integer values, and after delete the 'label' column.

* To create the final table of interest, we group the set of variables-of-interest by activity and subject. We then calculate the mean for activity variables across all subjects. This is supplied as the summary_table.

* Finally, we eliminate periods and uppercase letters from the variable names, in accordance with the course recommendations for variable names, and we then collapse the class inheritance structure of the summary_table to data.frame

Note that there are optional lines to clean-up the environment by deleting interemediate variables after they are no longer needed. These have been left uncommented so the script leaves only the summary_table in the environment.

