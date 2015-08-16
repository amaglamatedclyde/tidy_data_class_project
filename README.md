<center># Tidy Data Class Project</center>
## Cleaning the UCI HAR Dataset
This repo contains my submissions for the 'Getting and Cleaning Data' class project

The script file 'run_analysis.R' produces a table that summarizes the UCI HAR Dataset. The final table
is called 'summary_table' and consists of 180 observations of 69 variables.

This dataset consists of 10299 observations of 561 variables, split into two sets of observations. The observed variables are accelerometer and gyroscope data collected from 30 test subjects as they performed multiple trials of six different activites: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.

*The script first creates tables from the split sets, 'test' and 'training', in order to merge them into the complete set of observations. The activity labels and subject IDs are added as columns prior to merging.

*in the next step of the script, we extract the descriptive names of the variables from the file 'features.txt' and replace the column names of the complete_set table with these names. The explanation of these names can be found in the code book provided in this repository and originate in the file 'feature_info.txt'. It should be noted that not all of the orginal variable names are valid R variable names so the make.names() function is used to legalize them.

*Next we subset the variables of interest from the table using dplyr select(). These are all of the variables that are calculated means or standard deviations.

*At this step the 'label' column consists of integer values that correspond to the activites performed when test subject measurements were taken. We create a column 'activity' and substitute the descriptive names and after delete the 'label; column.

*To create the final table of interest, we group the set of variables-of-interes by activity and subject. We then calculate the mean for activity variables across all subjects. This is supplied as the summary_table.

Note that there are optional lines to clean-up the environment by deleting interemediate variables after they are no loner needed.

