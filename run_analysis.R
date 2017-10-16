library(tidyr)
library(reshape2)
library(dplyr)
library(stringr)
this.dir <- dirname(parent.frame(2)$ofile)
wkDir <- gsub(" ","",paste(this.dir,"/UCI_HAR_Dataset",""))
setwd(wkDir) # set working directory

## Define function to remove empty elements
func <- function(Lchar){
  Lchar[which(Lchar !="")]
}

## fileConnections and Data Loading
fileConnect <- file('./test/X_test.txt')
fileConnectTrain <- file('./train/X_train.txt')
measurementName <- read.csv('features.txt',sep=" ",header = F,stringsAsFactors = F)

# Loading Test Data
L <- readLines(fileConnect)
L2<-strsplit(L,split = " ")
L3<-t(sapply(L2,func))
testDF<-data.frame(matrix(as.numeric(L3),ncol=561))
testSubject <- read.csv('./test/subject_test.txt',sep = " ",header = F,stringsAsFactors = F)
testActivityID <-  read.csv('./test/y_test.txt',sep = " ",header = F,stringsAsFactors = F)

# Loading Train Data
L <- readLines(fileConnectTrain)
L2<-strsplit(L,split = " ")
L3<-t(sapply(L2,func))
trainDF<-data.frame(matrix(as.numeric(L3),ncol=561))
trainSubject <- read.csv('./train/subject_train.txt',sep = " ",header = F,stringsAsFactors = F)
trainActivityID <-  read.csv('./train/y_train.txt',sep = " ",header = F,stringsAsFactors = F)

# Close file connections
close(fileConnect)
close(fileConnectTrain)


## Mofidy col names and merge data
testDF <- cbind(testDF,testSubject,testActivityID)
trainDF <- cbind(trainDF,trainSubject,trainActivityID)
names(testDF) <- c(as.vector(measurementName$V2),"subjectID","activityID")
names(trainDF) <- c(as.vector(measurementName$V2),"subjectID","activityID")
mergedDF <- rbind(testDF,trainDF)

# Extract only means,  stds,  subjectIDs and activityIDs
selectedIndex <- grep("mean|std",measurementName$V2)
selectedDF <- mergedDF[,c(selectedIndex,562,563)]

# Use decriptive activity names
activityLables <-  read.csv('activity_labels.txt',sep=" ",header = F,stringsAsFactors = F)
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