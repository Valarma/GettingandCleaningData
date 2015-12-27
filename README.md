# Getting and Cleaning Data - Course Project
#
# Valard Marc
#
# 24 dec 2015
#

This is the course project for the Getting and Cleaning Data Coursera course.

The Script will create a sub folder named 'data' in the working directory if doesn't exist.
The output file will be writen in the working directory.

The R script, `run_analysis.R`, does the following:

1. Define variables used in the script

2. Download the dataset if it does not already exist in the working directory and unzip it

3. Load Data from files in to data frames:
        activityTest  <- Y_test.txt
        activityTrain  <- Y_train.txt
        subjectTest  <- subject_test.txt
        subjectTrain  <- subject_train.txt
        dataTest  <- X_test.txt
        dataTrain  <- X_train.txt

3. - Merge Test & Train rows
        activityTest & activityTrain
        subjectTest & subjectTrain
        dataTest & dataTrain
   - Names columns of merged data frames based on file features.txt
   - Merge subject & activity & data columns in an unique data frames
   
4. Extract appropriate data based on features ending with mean() and std()   
   
5. Capture activites names in file activity_labels.txt and factorize in the data frames   

4. Review the features naming to get it readable (^ = start with):
        "^t" --> "time-"
        "^f" --> "frequency-"
        "Acc" --> "Accelerometer"
        "Gyro" --> "Gyroscope"
        "Mag" --> "Magnitude"
        "BodyBody" --> "Body"

5. - Create new data frames containg the mean of each features for each activity and each subject.
   - Sort the new data frames on Subject then Activity
   - Output it in file 'meandata.txt'

   
# End
