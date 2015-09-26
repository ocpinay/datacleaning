library(dplyr)

#setwd("C:/Users/Liza/Documents/DSGettingData/data/datacleaning")
yTrain <- read.table("./UCI HAR Dataset/train/y_train.txt", quote="\"")
yTest <- read.table("./UCI HAR Dataset/test/y_test.txt", quote="\"")

features <- read.table("./UCI HAR Dataset/features.txt", quote="\"")
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", quote="\"")

subjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", quote="\"")
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt", quote="\"")

xTrain <- read.table("./UCI HAR Dataset/train/X_train.txt", quote="\"")
xTest <- read.table("./UCI HAR Dataset/test/X_test.txt", quote="\"")

colnames(activityLabels)<- c("V1","Activity")


#Merging of the 70% of the Volunteer select for generating the training data

#merging the y_train with the activity label
subject70<- rename(subjectTrain, subject=V1)
trainSubY<- cbind(yTrain,subject70)
trainSubYAct<- merge(trainSubY,activityLabels, by=("V1"))

#giving names from features to the X_train data frame
colnames(xTrain)<- features[,2]

#Combining y_train, activity labels, X_train
trainSubXY<- cbind(trainSubYAct,xTrain)
#eliminating the first column from train2 to avoid error "duplicate column name"
trainSubXYFull<- trainSubXY[,-1]



#Merging of the 30% of the Volunteer select for generating the test data

#merging the y_test with the activity label
subject30 <- rename(subjectTest, subject=V1)
testSubY<- cbind(yTest,subject30)
testSubYAct<- merge(testSubY,activityLabels, by=("V1"))


#giving names from features to the X_test data frame
colnames(xTest)<- features[,2]

#Combining y_test, activity labels, X_test
testSubXY<- cbind(testSubYAct,xTest)

#eliminating the first column from train2 to avoid error "duplicate column name"
testSubXYFull<- testSubXY[,-1]


# Extracting only mean and standard deviation measurements

#selecting only the columns that contains means and std
trainSubXYSet <- select(trainSubXYFull,contains("subject"), contains("Activity"), contains("mean"), contains("std"))

#selecting only the columns that contains means and std
testSubXYSet<- select(testSubXYFull,contains("subject"), contains("Activity"), contains("mean"), contains("std"))



# Combining Train data with Test data
completeSubXY<- rbind(trainSubXYSet,testSubXYSet)


#Summarizing the data
tidy<- (completeSubXY%>%
                  group_by(subject,Activity) %>%
                  summarise_each(funs(mean)))

write.table(tidy,file="tidy.txt",row.name=FALSE)
