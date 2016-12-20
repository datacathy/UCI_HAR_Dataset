#===================================================================================================================
# This is file run_analysis.R. It contains commands to tidy and analyze the UCI HAR Dataset. In outline, 
# here are the cleaning and analysis steps in this document. Steps 1) through 4) correspond directly to the project
# instructions. Step 0) is preprocessing where I read in all relevant data.
#
# 0) First, I read in all the relevant files. I assume the pwd (current working directory) contains a directory
#    called "UCI HAR Dataset" that contains the files and directories from the input. Given this, I read in
#    the following files:
#        * activity_labels.txt: this file contains the translation between numbers in the data and activity
#          labels. I read it into a table called activity_labels, with columns "code" and "label".
#        * features.txt: this file contains the column names for the main dataset, read into data frame features
#        * test/subject_test.txt: this file contains which subject each observation in the X_test and y_test
#          files belongs to. Read into data frame subject_test
#        * test/X_test.txt: this file contains the testing subset of the main data, features extracted from the
#          observations from the sensors (one observation per row). Read into data frame X_test.
#        * test/y_test.txt: this file contains the "answers" if a model trains on the data from X_test.txt,
#          which are categorizations of the observations into activity codes. Read into data frame y_test.
#        * train/subject_test.txt: again, the file contains the subjects for the observations in X_train
#          and classifications in y_train. Read into data frame subject_test.
#        * train/X_train.txt: this file contains the training subset of the main data, which is features extracted
#          from the observations from the sensors (one observation per row). Read into data frame X_train.
#        * train/y_train.txt: this file contains the "answers" to the training data Xtrain.txt, in other words,
#          it contains the classification into activity codes for each observation. Read into data frame y_train.
#
# 1) Next, I work on the data frames X_train and X_test. First, I label the columns according to the features
#    column names. The result is two appropriately labeled data frames, one for the training, and one for the testing
#    input data. Then, I put together the various pieces of the dataset. I use cbind to put together the subjects,
#    features, and classifications for the training and the test data. I use rbind to put together the resulting 
#    completed data subsets. The result of the rbind is a merged training and test set.
#
# 2) Next,  I select only those columns whose name indicates a mean or std function. This extracts
#    the mean, std, and meanFreq columns for all relevant measurements.
#
# 3) Next, I translate activity codes in the data into human-readable labels according to the activity_labels
#    data frame.
#
# 4) Finally, I create the output data frame, which contains the average value of each variable for each
#    activity and subject. I output this data frame to a file using write.table.
#
#  The Codebook and README files for this project that should accompany this script can be found at:
#  https://github.com/datacathy/GCD_course_project. Thanks!
 #===================================================================================================================
 
#----------------------------------------------------------------------------------------------
# STEP 0): read in the relevant pieces of data.
#----------------------------------------------------------------------------------------------
print("Reading data...")

# read activity_labels.txt into a data frame and give it sensible column names
activity_labels <- read.table("./UCI\ HAR\ Dataset/activity_labels.txt")
names(activity_labels) <- c("code", "activity")

# read features.txt into a data frame and give it a sensible column name
features <- read.table("./UCI\ HAR\ Dataset/features.txt")
names(features) <- c("column_index", "feature_name")

# read the three training data files: subject_train.txt, X_train.txt, and y_train.txt and give
# the resulting data frames appropriate column names. Note that the column names for X_train
# are given by the features$feature_name column (in order).
subject_train <- read.table("./UCI\ HAR\ Dataset/train/subject_train.txt")
names(subject_train) <- c("subject")

X_train <- read.table("./UCI\ HAR\ Dataset/train/X_train.txt")
names(X_train) <- features$feature_name

y_train <- read.table("./UCI\ HAR\ Dataset/train/y_train.txt")
names(y_train) <- c("activity_code")

# now read the three test data files: subject_test.txt, X_test.txt, and y_test.txt and give
# the resulting data frames appropriate column names. Note that the column names for X_test
# are given by the features$feature_name column (in order).
subject_test <- read.table("./UCI\ HAR\ Dataset/test/subject_test.txt")
names(subject_test) <- c("subject")

X_test <- read.table("./UCI\ HAR\ Dataset/test/X_test.txt")
names(X_test) <- features$feature_name

y_test <- read.table("./UCI\ HAR\ Dataset/test/y_test.txt")
names(y_test) <- c("activity_code")

# Done reading in data!


#----------------------------------------------------------------------------------------------
# STEP 1): Merge training and test data
#----------------------------------------------------------------------------------------------
print("Merging training and test data...")

# First, we have to put the 3 data frames containing the training data together. Note that the
# order of rows in subject_train, X_train, and y_train is the same, so we cbind them to
# produce complete observations
training <- cbind(cbind(subject_train, y_train), X_train)

# similarly for the test data
testing <- cbind(cbind(subject_test, y_test), X_test)

# now that we have the completed training and testing data frames, we can put all the
# observations into one data frame using rbind.
fulldata <- rbind(training, testing)

# Done merging training and test data


#----------------------------------------------------------------------------------------------
# STEP 2): Extract mean and std data for each measurement
#----------------------------------------------------------------------------------------------
print("Extracting mean and std columns...")

# Now create a logical vector detailing which columns we want to keep, namely those that
# include a mean or std function. Note that this includes meanFreq columns.
which_cols_to_keep <- sapply(names(fulldata), function(x) { length(grep("mean()|std()", x)) > 0 })

# keep "activity_code", and "subject" columns as well
which_cols_to_keep['activity_code'] <- TRUE
which_cols_to_keep['subject'] <- TRUE

# now keep only those columns where which_cols_to_keep is true
keptdata <- fulldata[which_cols_to_keep]

# Done extracting mean and std functions


#----------------------------------------------------------------------------------------------
# STEP 3): Appropriately label activities
#----------------------------------------------------------------------------------------------
print("Labeling activities in human-readable form...")

# merge keptdata with the activity_labels data frame, resulting column activity contains
# human readable labels for each activity code in the observations
keptdata <- merge(activity_labels, keptdata, by.x="code", by.y="activity_code")

# drop extraneous "code" column
keptdata$code <- NULL

# Done labeling activities


#----------------------------------------------------------------------------------------------
# STEP 4): Output a table of averages of each variable for each activity & subject
#----------------------------------------------------------------------------------------------
print("Preparing and writing output to file GCDC-project-result.txt...")

# create a wide table of means for each activity and subject. For a discussion of whether to
# create this wide table or a narrower one, see README.md and Codebook.md.
library(dplyr)
result <- keptdata %>% group_by(activity, subject) %>% summarize_each(funs(mean))

# output result table using table.write with option row.names=FALSE. TO read the table back
# into R, use table.read with option header=TRUE.
write.table(result, "GCDC-project-result.txt", row.names=FALSE)

# Done outputing result.

# clean up
rm(list = c("activity_labels", 
            "features", 
            "subject_train", 
            "X_train", 
            "y_train", 
            "subject_test", 
            "X_test", 
            "y_test", 
            "fulldata", 
            "keptdata", 
            "result",
            "testing",
            "training",
            "which_cols_to_keep"))

print("...done.")
# Done script run_analysis.R. Thanks!

