# John Koegel
# Coursera Getting and Cleaning Data
# Week 4 Final Project
library(dplyr)

# 1 Load Data

# Read in Activity Labels & Features
actLabels <- read.delim(paste(getwd(),"/activity_labels.txt",sep =""), header = FALSE, sep="",quote = "\"")
features <- read.delim(paste(getwd(),"/features.txt",sep =""), header = FALSE, sep="",quote = "\"")

# Read in Training Data
trainSubject <- read.delim(paste(getwd(),"/train/subject_train.txt",sep =""), header = FALSE, sep=" ")
trainX <- read.delim(paste(getwd(),"/train/X_train.txt",sep =""), header = FALSE, sep="",quote = "\"")
trainY <- read.delim(paste(getwd(),"/train/y_train.txt",sep =""), header = FALSE, sep="",quote = "\"")

# Read in Test Data
testSubject <- read.delim(paste(getwd(),"/test/subject_test.txt",sep =""), header = FALSE, sep=" ")
testX <- read.delim(paste(getwd(),"/test/X_test.txt",sep =""), header = FALSE, sep="",quote = "\"")
testY <- read.delim(paste(getwd(),"/test/y_test.txt",sep =""), header = FALSE, sep="",quote = "\"")

# Merge Training and Test Data
subject <- bind_rows(trainSubject,testSubject)
rm(testSubject)
rm(trainSubject)

X <- bind_rows(trainX,testX)
rm(trainX)
rm(testX)

Y <- bind_rows(trainY,testY)
rm(trainY)
rm(testY)

# 2 Create Mean and STD for all Columns
meanX <- X %>% summarize_each(funs(mean))
stdX <- X %>% summarize_each(funs(sd))

mean_std <- bind_rows(meanX, stdX)
rm(meanX)
rm(stdX)

rownames(mean_std) <- c("meanX","stdX")

# 3 Name Activities in Data Set & 4 Label Columns
actLabelsObservation <- inner_join(Y, actLabels, by = "V1")
actLabelSubjectObservation <- bind_cols(actLabelsObservation,subject)
colnames(X) <- gsub("-","_",gsub(",","_",features$V2))
colnames(actLabelSubjectObservation) <- c("ActivityId","Activity","SubjectId")
factTable <- bind_cols(actLabelSubjectObservation, X)
factTable <- select(factTable, -ActivityId)
rm(actLabelsObservation)
rm(subject)
rm(actLabels)
rm(Y)
rm(features)
rm(X)
rm(actLabelSubjectObservation)

# 5 Create Summarization Table
groupActSubjFact <- factTable %>% group_by(SubjectId, Activity) %>% summarize_each(funs(mean))