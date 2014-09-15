##run_analysis.R

This script first reads in all the raw data (training and test), as well as the 
'features' table (which contains a description of all the measurements in the 
study) and the 'activity_labels' table (which describes each activity in the 
study).

##Reading in raw data

Start by saving root working directory as 'wd', so working directory can be
switched during reading in of raw data.

Then save 'features' and 'activity_labels' as character vectors from 
respective tables in root directory.

Switch working directory to '/train' folder, and read in raw data 
(subject and measurements).  Create 'train_bind' (using cbind) 
with Subject, Activity, and measurements columns.  Label with 'features' vector.

Switch working directory to '/test' folder, and read in raw data 
(subject and measurements).  Create 'test_bind' (using cbind) 
with Subject, Activity, and measurements columns.  Label with 'features' vector.

##Merge the data

Create 'merged_data' with rbind.  Replaced the 'Activity' column (which is 
numeric) with the descriptive labels in 'activity_labels'.

The first column here is 'Subject', which is a numeric value (1:30) that indicates 
the subject.  Second column is 'Activity', which is a character value that 
indicates the activity.  The rest of the columns represent various accelerometer 
measurements (numeric).

##Subset mean and std data

Create 'subsetting_vector', which is a logical vector which is 'TRUE' for every 
value in 'features' which contains the substring 'mean' or 'std', and 'FALSE' 
otherwise (i.e., the vector indicates which columns are mean or std values, and
which are not).

Used 'subsetting_vector' to subset 'merged_data', creating 'merged_subset'. This 
data.frame is structured in the same manner as 'merged_data' ('Subject', 'Activity', 
measurements), but only contains 'mean' or 'std' measurements.

##Calculate the mean of measurements for each Subject and Activity

'merged_subset' was first melted using melt() (from reshape2 package), with 
id.vars=c("Subject", "Activity"), and stored in 'melt_subset' data.frame.

'melt_subset' contains four columns; 'Subject', 'Activity', 'variable', 'value'.

Then ddply() (from plyr package) was called on 'melt_subset', with 
.(Subject, Activity, variable) as .variable argument, and 'summarise, 
mean=mean(value)' passed to .fun argument.

Resulting data.frame is called 'merged_subset_means'.

This is then exported as text file ('course_assignment.txt') into 
the root directory.