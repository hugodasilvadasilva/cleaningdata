# cleaningdata
At this repository you can find the project assignment requested as a mean to evaluate the students at the end of the 3th Module (Getting and Cleaning data) from Coursera's Data Science Course.

## The script

The file run_analysis.R contains the script created to read the data available at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and tidy it accordinly to the instructions that has been given.
The script does the following:
1. Download and unzip the file at the user Working Directory
2. Read all the files that will be used at this clening script and store the data into dataframes having the same names as it's source file.
  1. The files are:
    * UCI HAR Dataset/activity_labels.txt
    * UCI HAR Dataset/features.txt
    * UCI HAR Dataset/train/subject_train.txt
    * UCI HAR Dataset/train/X_train.txt
    * UCI HAR Dataset/train/y_train.txt
    * UCI HAR Dataset/train/subject_test.txt
    * UCI HAR Dataset/train/X_test.txt
    * UCI HAR Dataset/train/y_test.txt
3. Name the dataframes columns
4. Name the columns of 'X_train' using the content of 'features' and select only those that contains 'mean()' or 'std()' into its text title
5. Merges the 'activity_label' with 'y_train' in order to have the 'Activity Name' and 'Id' in one dataframe only
6. Join the all train dataframes ('subject_train','y_train' and 'X_train') in order to have all data into one dataframe only
7. Repeats the steps 4 to 6 applying to test dataframes
8. Put test and train data into one dataframe only (the first rows are from train and the last rows belongs to test)
9. Converts the abraviated columns names into descriptive column names
10. Calculates the mean for each column that contains features data (columns from 4 to 69) keeping the same name as given beforehand
11. Save the result data into a file named 'samsungtidydataset.txt' at the users Working Directory

Thats the end of script.