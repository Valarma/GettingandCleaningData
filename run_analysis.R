##
## Variables definition
##

fileSourceUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

downloadedFile <- "getdata.zip"

##
## Download and Extract Data Files
##

if (!file.exists("./data")){dir.create("./data")}

downloadedfilepath <- file.path("./data", downloadedFile)

download.file(fileSourceUrl,destfile = downloadedfilepath, method = "libcurl", mode="wb")  ## use libcurl on my windows computer
              
unzip(zipfile = downloadedfilepath,exdir="./data")   ## file are located in folder "UCI HAR Dataset"

datapath <- file.path("./data", "UCI HAR Dataset")

##
## Read Data from files and put them into Variables
##

activityTest  <- read.table(file.path(datapath, "test" , "Y_test.txt" ),header = FALSE)
activityTrain <- read.table(file.path(datapath, "train", "Y_train.txt"),header = FALSE)

subjectTest  <- read.table(file.path(datapath, "test" , "subject_test.txt"),header = FALSE)
subjectTrain <- read.table(file.path(datapath, "train", "subject_train.txt"),header = FALSE)

dataTest  <- read.table(file.path(datapath, "test" , "X_test.txt" ),header = FALSE)
dataTrain <- read.table(file.path(datapath, "train", "X_train.txt"),header = FALSE)

##
## 1 - Merges the training and the test sets to create one data set
## 
## Bind data from train & test. Name collumns. Then Bind columns all together
##

activitybinded <- rbind(activityTrain, activityTest)
subjectbinded <- rbind(subjectTrain, subjectTest)
databinded <- rbind(dataTrain,dataTest)

names(subjectbinded)<-c("subject")
names(activitybinded)<- c("activity")
dataNames <- read.table(file.path(datapath, "features.txt"),head=FALSE)
names(databinded)<- dataNames$V2

datacol12 <- cbind(subjectbinded, activitybinded)
dataAllInOne <- cbind(databinded, datacol12)

##
## 2 - Extracts only the measurements on the mean and standard deviation for each measurement. 
## 
## Extract appropriate data - Mean and Standard 
##

subdataNames<-dataNames$V2[grep("-(mean|std)\\(\\)", dataNames$V2)]

selectedNames<-c(as.character(subdataNames), "subject", "activity" )
selectedData<-subset(dataAllInOne,select=selectedNames)

##
## 3- Uses descriptive activity names to name the activities in the data set
## 
## Capture and factorize Activity Labels
##

activityLabels <- read.table(file.path(datapath, "activity_labels.txt"),header = FALSE)
selectedData$activity <- factor(selectedData$activity, levels = activityLabels[,1], labels = activityLabels[,2])

##
## 4 - Appropriately labels the data set with descriptive variable names
## 
## Adapt descriptive variable names to readable description
##

names(selectedData)<-gsub("^t", "time-", names(selectedData))
names(selectedData)<-gsub("^f", "frequency-", names(selectedData))
names(selectedData)<-gsub("Acc", "Accelerometer", names(selectedData))
names(selectedData)<-gsub("Gyro", "Gyroscope", names(selectedData))
names(selectedData)<-gsub("Mag", "Magnitude", names(selectedData))
names(selectedData)<-gsub("BodyBody", "Body", names(selectedData))

##
## 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
## for each activity and each subject.
##
## Create Output and write it to file
##

outputData <- aggregate(. ~ subject + activity, selectedData, mean)
outputData <- outputData[order(outputData$subject,outputData$activity),]
write.table(outputData, file = "meandata.txt",row.name=FALSE)
