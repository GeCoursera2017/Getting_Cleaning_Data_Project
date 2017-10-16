library(tidyr)
library(reshape2)
library(dplyr)
library(stringr)
## Before running this script, put "UCI HAR Dataset" in the same folder as run_analysis.R
## Setting working directory
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir) 

# Loading Test Data
testDF <- read.table('./UCI HAR Dataset/test/X_test.txt')
testSubject <- read.csv('./UCI HAR Dataset/test/subject_test.txt',sep = " ",header = F,stringsAsFactors = F)
testActivityID <-  read.csv('./UCI HAR Dataset/test/y_test.txt',sep = " ",header = F,stringsAsFactors = F)
testDF <- cbind(testDF,testSubject,testActivityID)

# Loading Train Data
trainDF <- read.table('./UCI HAR Dataset/train/X_train.txt')
trainSubject <- read.csv('./UCI HAR Dataset/train/subject_train.txt',sep = " ",header = F,stringsAsFactors = F)
trainActivityID <-  read.csv('./UCI HAR Dataset/train/y_train.txt',sep = " ",header = F,stringsAsFactors = F)
trainDF <- cbind(trainDF,trainSubject,trainActivityID)


## Mofidy col names and merge data
measurementName <- read.csv('UCI HAR Dataset/features.txt',sep=" ",header = F,stringsAsFactors = F)
mergedDF <- rbind(testDF,trainDF)
names(mergedDF) <- c(as.vector(measurementName$V2),"subjectID","activityID")


# Extract only means,  stds,  subjectIDs and activityIDs
selectedIndex <- grep("mean|std",measurementName$V2)
selectedDF <- mergedDF[,c(selectedIndex,562,563)]

# Use decriptive activity names
activityLables <-  read.csv('UCI HAR Dataset/activity_labels.txt',sep=" ",header = F,stringsAsFactors = F)
selectedDF<- selectedDF %>% mutate(activityNames =activityLables$V2[activityID] ) %>% select(-activityID)

# Reshape data frame to desired tidy dataset
finalDF<- selectedDF %>% 
  gather(measurements,value,-(subjectID:activityNames)) %>% 
  unite(subjectID_activityNames,subjectID,activityNames,sep="_")  %>% 
  dcast(subjectID_activityNames ~ measurements,mean) %>%
  separate(subjectID_activityNames,into =c("subjectID","activityNames"),sep="_") %>%
  gather(measurements,averageValue,-(subjectID:activityNames))

# Write dataset to txt files
write.table(selectedDF,file = "firstDataset.txt",row.names=F)
write.table(finalDF,file = "finalDataset.txt",row.names=F)
