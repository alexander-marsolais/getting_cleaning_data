#Set working directory to '/UCI HAR Dataset' on your computer

##Save this file path to the variable 'wd' so we can switch back after reading
#in the training and test data
wd <- getwd()

##Save features in 'features_table' and extract character vector 'features' 
features_table <- read.table("features.txt")
features <- as.character(features_table$V2)

##Save activity lables in 'activity_labels_table' and extract character vector 
#'activity_labels'
activity_labels_table <- read.table("activity_labels.txt")
activity_labels <- as.character(activity_labels_table$V2)


#Switch working directory to '/train' folder so we can read in the training data
setwd(paste(wd, "train", sep = "/"))

##Read in training data to variables 'X_train', 'y_train' and 'subject_train'
#Bind data together into 'train_bind', add labels from 'features' vector
X_train <- read.table("X_train.txt", colClasses = "numeric")
y_train <- read.table("y_train.txt", colClasses = "numeric")
subject_train <- read.table("subject_train.txt", colClasses = "numeric")
train_bind <- cbind(subject_train, y_train, X_train)
names(train_bind) <- c("Subject", "Activity", features)


#Switch working directory to '/test' folder so we can read in the test data
setwd(paste(wd, "test", sep = "/"))

##Read in training data to variable 'X_test', 'y_test' and 'subject_test'
#Bind data together into 'test_bind', add labels from 'features' vector
X_test <- read.table("X_test.txt", colClasses = "numeric")
y_test <- read.table("y_test.txt", colClasses = "numeric")
subject_test <- read.table("subject_test.txt", colClasses = "numeric")
test_bind <- cbind(subject_test, y_test, X_test)
names(test_bind) <- c("Subject", "Activity", features)

##Now merge the two dataframes into 'merged_data' 
merged_data <- rbind(train_bind, test_bind)

##Replace numeric code in 'y_test' or 'y_train' variable with the descriptive labels
#in 'activity_labels'
#THIS IS FOR QUESTION ONE, THREE AND FOUR
activity_vector <- as.character(merged_data$Activity)
for (i in 1:length(activity_vector)) {
      n <- activity_vector[i] 
      activity_vector[i] <- activity_labels[as.numeric(n)]
}
merged_data$Activity <- activity_vector

##Pull out mean and standard deviation data, create 'merged_subset'
#Create a logical 'subsetting_vector' for this purpose - search for 
#substring 'mean' or 'std' in 'features' vector
#This code installs the 'stringr' package if not already installed
#THIS IS THE ANSWER FOR QUESTION TWO OF THE ASSIGNMENT

subsetting_vector <- as.vector(NULL)
if ("stringr" %in% row.names(installed.packages()) == FALSE) {install.packages("stringr")}
library(stringr)
for (i in 1:length(features)) {
      if (str_detect(features[i], "mean")) { 
          subsetting_vector[i] <- TRUE
      } else if (str_detect(features[i], "std")) {
          subsetting_vector[i] <- TRUE
      } else {
          subsetting_vector[i] <- FALSE
      }
}

subsetting_vector <- c(TRUE, TRUE, subsetting_vector)

merged_subset <- merged_data[,subsetting_vector]

##Now create 'merged_subset_means', a dataframe with the means for each Subject
#and Activity, and write it to original working directory
#This code installs the 'plyr' and 'reshape2' packages if not already installed
#THIS IS FOR QUESTION FIVE

if ("plyr" %in% row.names(installed.packages()) == FALSE) {install.packages("plyr")}
library(plyr)
if ("reshape2" %in% row.names(installed.packages()) == FALSE) {install.packages("reshape2")}
library(reshape2)

melt_subset <- melt(merged_subset, id.vars = c("Subject", "Activity"))
merged_subset_means <- ddply(melt_subset, .(Subject, Activity, variable), summarise, 
      mean=mean(value))  

setwd(wd)
write.table(merged_subset_means, "course_assignment.txt")