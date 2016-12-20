# Codebook for the table contained in file GCDC-project-result.txt

Notes:

  1. Use read.table("GCDC-project-result.txt", header=TRUE) to read the table from the file.
  2. The file GCDC-project-result.txt is created by the script run_analysis.R.
  3. The script assumes you've already downloaded and unpacked the UCI HAR data from [the UCI
     machine learning repository] (http://archive.ics.uci.edu/ml/machine-learning-databases/00240/).
  4. Run the script from the directory containing the UCI HAR Dataset directory.


## Introduction

The UCI HAR data contains data on experiments carried out with a group of 30 volunteers, each between the ages of 19 and 48. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) while wearing a smartphone on their waist. Using a sample rate of 50 Hz, data from the smartphone's accelerometer and gyroscope was captured. The raw data is available in the Inertial Signals subdirectory of the test and train directories in the UCI HAR Dataset directory.

The raw data was processed into 561 features (listed in the file features.txt in the UCI HAR Dataset directory). Furthermore, the data was split into a training set (about 70% of the volunteers) and a testing set (the other 30%).

Finally, the data was shredded into classical machine learning configuration, which assumes an input matrix X of observations of the relevant features and a target vector y, for both the training and testing sets.

For this project, I reassembled the data into one large data frame, selected only certain features of interest (see below), labeled activities in a more human-readable form, and created a summary table contining average values for the retained features, grouped by activity and subject. Details follow.


## Variables

The table in GCDC-project-result.txt has 81 variables and 180 observations. The variables are as follows:

  * variable "activity" lists the activity that observation represents. It's values are
    discrete and take one of WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING,
    STANDING, or LAYING.
  * variable "subject" lists the id of the test subject the observation is about (1
    through 30).
  * the next 79 variables contain averages of the original measurement features for
    that activity and that subject. Note that only 79 of the original 561 features
    were retained for this project. Features involving the mean, std (standard
    deviation), or frequency mean (meanFreq) were selected and retained. For example,
    the value of tBodyAcc-mean()-X in the observation for subject 1 and activity
    "LAYING" is the average over all tBodyAcc-mean()-X measurements for subject 1
    and activity "LAYING". Grouping and averaging reduced the number of rows in the
    dataset from 10,299 to 180.


## Methodology

I had to make some decisions in implementing this project solution, and I hope to make those clear in what follows. First and foremost, I assume the UCI HAR Dataset has already been downloaded from the link in the course project description. I assume the data has been unzipped and the working directory is a directory containing both run_analysis.R (my script for cleaning and analysis) and the UCI HAR Dataset directory with the data in it.

Given this as a starting point, I then followed the project description through the five steps, plus an additional pre-processing step where I load the data into R.


### Step 0: Loading the data

In this step, I created R dataframes for each of the relevant pieces of information in the UCI HAR Dataset directory.

  * file activity_labels.txt: this file translated into a 6x2 dataframe giving the
    English labels for the activity codes contained in the y_train and y_test data
    (see below).
  * file features.txt: this file translated into a 561x2 dataframe giving a position
    number and the name of a feature in the X_train and X_test data (see below).
  * from directory train:
      - file X_train.txt: this translated to a 7352x561 dataframe giving 7352
        observations of the 561 features.
      - file y_train.txt: this translated to a 7352x1 dataframe giving the activity
        code for each of the observations in X_train.
      - file subject_train.txt: this translated to a 7352x1 dataframe giving the
        subject id for each of the observations in X_train.
  * from directory test:
      - file X_test.txt: this translated to a 2947x561 dataframe giving 2947
        observations for the 561 features.
      - file y_test.txt: this translated to a 2947x1 dataframe giving the activity
        code for each of the observations in X_test.
      - file subject_test.txt: this translated to a 2947x1 dataframe giving the
        subject id for each of the observations in X_test.

Dataframes were given names corresponding to the files they were read from, using read.table with all default parameters. For example, X_train.txt was read into dataframe X_train.

NOTE: for the script to work, it must be run from the same directory as the UCI HAR Dataset directory.


### Step 1: Merge the training and test sets

In this step, I first put together the training and testing pieces. I used cbind to bind the subject and activity data to appropriate observations. I did this for both the training and testing data. Then, I "unioned" the resulting dataframes using rbind to result in one large dataframe (with 10,299 rows and 563 variables) containing all the UCI HAR data.


### Step 2: Extract only measurements on the mean and standard deviation

In this step, I selected columns from the features dataframe (containing all 561 feature names) based on the regular expression "mean()|std()". I also retained the "activity_code" and "subject" columns. This gave me an 10,299x81 dataframe. The columns retained belonged to such names as "tGravityAcc-mean()-X", "tBodyGyro-std()-Z", and "fBodyAcc-meanFreq()-Y".

Note that I made a decision to include the "meanFreq" columns. I could have ruled these out, as the project description didn't specify whether to include these or not. I figured I would err on the side of too much information rather than too little.


### Step 3: Use descriptive activity names

In this step, I merged the dataset with the activity_labels dataframe, joining on the columns containing activity codes. This meant I had the appropriate activity label for each observation. I then dropped the redundant column which contained the codes. This gave me column "activity", a categorical variable taking one of the six activities: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, or LAYING.


### Step 4: Appropriately label the data set with descriptive variable names

My script run_analysis.R doesn't contain an explicit step for this because as soon as I loaded the X_train and X_test data, I renamed the columns according to the names in the features dataframe. This gave my columns descriptive attributes, like "fBodyAcc-bandsEnergy()-1,16". In fact, after loading each table, my next step was to give it descriptive column names. See run_analysis.R step 0 for details.


### Step 5: Create and output aggregated data

In this final step, I grouped the data by activity and subject id, then aggregated over each measurement to get the mean value for that activity and subject id. This resulted in a 180x81 dataframe of summarized values. This dataframe was then output with write.table into file GCDC-project-result.txt. The aggregated, tidy data can be read with the command:

`read.table("GCDC-project-result.txt", header=TRUE)`


## Summary

In this codebook, I've indicated how to run my script run_analysis.R to perform the course project requirements and result in the file GCDC-project-result.txt which contains a tidy, summarized version of the UCI HAR Dataset data.

I've also described the variables of the table in GCDC-project-result.txt and given an indication of how each was obtained from the input files.

I described the steps I went through in run_analysis.R to clean and summarize the input data. Also see the script itself for more comments and information.

Thank you.