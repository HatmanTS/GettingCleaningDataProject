
#first at all, we have to load the used libraries
library(dplyr)

#second unzip and change the working directory
unzip("./Dataset.zip")
setwd("./UCI HAR Dataset/")

## Step 1: Merges the training and the test sets to create one data set.

# In order to have tidy the data we are going to load the subject, y value
# and x values for the train and the test data

#load train set
xtrain <- read.table("train/X_train.txt")
ytrain <- read.table("./train/y_train.txt")
subjecttrain <- read.table("./train//subject_train.txt")

#load test set
xtest <- read.table("test/X_test.txt")
ytest <- read.table("./test//y_test.txt")
subjecttest <- read.table("./test//subject_test.txt")

#merge train
mergedtrain <- cbind(subjecttrain, ytrain, xtrain)

#merge test
mergedtest <- cbind(subjecttest, ytest, xtest)
 
#merge train and test
mergedset <- rbind(mergedtrain, mergedtest)

## Step 2: Extracts only the measurements on the mean and
##         Standard Deviation for each measurement

# We need the features to know which are the mean and
# standard deviation columns
features <- read.table("./features.txt")

# We get the mean and the std index
featuresmean <- grepl(pattern = "-mean\\()", 
                x=features[[2]], ignore.case = TRUE)
featuresstd <- grepl(pattern = "-std\\()", 
                      x=features[[2]], ignore.case = TRUE)
# We extract the data, including the values for subjects and
# activities
extracteddata <- mergedset[,c(T,T,featuresmean | featuresstd)]

## Step 3: Uses descriptive activity names to name the 
## activities in the data set

# Here we have to change the values 1, 2, 3, 4, 5 and 6 to
# the activity name
activities <- read.table("./activity_labels.txt")
extracteddata[[2]] <- factor(extracteddata[[2]], labels = activities[[2]])

## Step 4: Appropriately labels the data set with descriptive variable names. 

# Here we have to change the column labels to a representative names
# The first to column names are Subject and Activity
colnames(extracteddata) <- c("Subject", "Activity",
                as.character(features[featuresmean | featuresstd ,2]))

## Step 5: From the data set in step 4, creates a second, 
## independent tidy data set with the average of each 
## variable for each activity and each subject.
meanextracted <- summarise_each(group_by(extracteddata, 
                                Subject, Activity),funs(mean))
setwd("../")

