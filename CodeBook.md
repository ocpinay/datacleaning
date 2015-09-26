## Code Book 

This code book describes how data from the Human Activity Recognition Using Smartphones Data Set was collected, transformed, 
and cleaned to prepare tidy data that can be used for later analysis.

### Description of the Raw Data

The Human Activity Recognition Using Smartphones Data Set was built from the recordings of 30 volunteers performing activities of daily living (ADL) 
while carrying a waist-mounted smartphone with embedded inertial sensors.  These records contain triaxial acceleration from the accelerometer, 
the estimated body acceleration, triaxial angular velocity from the gyroscope, a 561-feature vector with time and frequency domain variables, 
an activity label, and an identifier of the subject who participated in the experiment.

The 30 volunteers were divided into test sets (30%) and training data sets (70%).

The raw data set included the following files:
* features_info.txt: Information about the variables used on the feature vector.
* features.txt: List of all features.
* activity_labels.txt: Links the class labels with their activity name.
* train/X_train.txt: Training measurements.
* train/y_train.txt: Training labels.
* train/subject_train.txt: Each row identifies the subject who performed the activity. Its range is from 1 to 30. 
* test/X_test.txt: Test measurements.
* test/y_test.txt: Test labels.
* test/subject_test.txt: Each row identifies the subject who performed the activity. Its range is from 1 to 30. 
* train/Inertial Signals/total_acc_x_train.txt: The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. 
	Every row shows a 128 element vector. The same description applies for the total_acc_x_train.txt and total_acc_z_train.txt files for the Y and Z axis. 
* train/Inertial Signals/body_acc_x_train.txt: The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
* train/Inertial Signals/body_gyro_x_train.txt: The angular velocity vector measured by the gyroscope. The units are radians/second. 

For preparing the tidy data in this project, the files inside the Inertial Signals folder and features_info.txt were not used.

### Variables

The variables used for preparing the tidy data were the mean and standard deviation for each measurement.

### Work/Transformations

#### Getting and Loading the Raw Data

The raw data was downloaded from the specified link, https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

It was extracted into a local working directory.

read.table is used to load the different files used into R.  

These files were read into the following data frames: 
* features.txt -> features 
* activity_labels.txt -> activityLabels 
* train/X_train.txt -> xTrain
* train/y_train.txt -> yTrain  
* train/subject_train.txt -> subjectTrain 
* test/X_test.txt -> xTest
* test/y_test.txt -> yTest 
* test/subject_test.txt -> subjectTest

#### Combining the Training Data Frames with Descriptive Activity and Variable Names

1. Column names for activityLabels data frame was changed to "V1" and "Activity" using colnames
2. To merge the yTrain data frame with activityLabels data frame:
2.a. Change the column name of subject to "V1" in subjectTrain using rename from the dplyr package and assign it to subject70
2.b. Combine yTrain with subject70 using cbind and assign this to trainSubY
2.c. Combine trainSubY and activityLabels using the "V1" column by using merge from the dplyr package and assign this to trainSubYAct
3. Use the 2nd column of the features data frame to give descriptive column names to xTrain using colnames
4. Combine the transformed yTrain, trainSubYAct, with xTrain by using cbind and assign this to trainSubXY
5. Eliminate the first column of trainSubXY by subsetting and assign this to trainSubXYFull

#### Combining the Test Data Frames with Descriptive Activity and Variable Names

1. To merge the yTest data frame with activityLabels data frame used in the previous process:
1.a. Change the column name of subject to "V1" using rename from the dplyr package and assign it to subject30
1.b. Combine yTest with subject30 using cbind and assign this to testSubY
1.c. Combine testSubY and activityLabels using the "V1" column by using merge from the dplyr package and assign this to testSubYAct
3. Use the 2nd column of the features data frame to give descriptive column names to xTest using colnames
4. Combine the transformed yTest, testSubYAct, with xTest by using cbind and assign this to testSubXY
5. Eliminate the first column of testSubXY by subsetting and assign this to testSubXYFull

#### Extracting only the Measurements on the Mean and Standard Deviation for Each Measurement

1. Use select(trainSubXYFull, contains("subject"), contains("Activity"), contains("mean"), contains("std")) to extract only the mean and standard deviation of each measurement of the transformed training data set then assign it to trainSubXYSet.
2. Use select(testSubXYFull, contains("subject"), contains("Activity"), contains("mean"), contains("std")) to extract only the mean and standard deviation of each measurement of the transformed test data set then assign it to testSubXYSet.

#### Combining the transformed Test and Training Data Frames

Combine trainSubXYSet with testSubXYSet using rbind and assign this to completeSubXY.

#### Summarize the Data by getting the average of each variable for each activity and each subject

Using the pipeline operator (%>%), perform the series of operations on completeSubXY:
1. Group the data frame by subject and then by Activity using group_by.
2. Summarize the measurement and get the mean by using summarise_each(funs(mean)).
3. Assign this to tidy

#### Write Tidy Data into a txt file

Use write.table(tidy,file="tidy.txt",sep="\t",row.names = FALSE) to make a text file from the transformed raw data.







 	

	

