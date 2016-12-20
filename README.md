This repository contains the final project for the Coursera course Getting and Cleaning Data. It consists of three files:

* This file, README.md containing information on what's in this repository and how to use it.

* The file run_analysis.R which inputs the UCI HAR Dataset and outputs the analysis according to the project instructions. Make sure to set your working directory to the one containing the UCI HAR Dataset directory.
Then run this file with the command source("run_analysis.R") (assuming you're in the directory containing run_analysis.R). The script creates a file called GCDC-project-result.txt in the same directory from which it's sourced. To load the data from this file, use the R command read.table("GCDC-project-result.txt", header=TRUE) and have a look at the summarized measurements.

* The file Codebook.md contains details of the transformations performed on the input data. For more information about the UCI HAR Dataset, see [the documentation] (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

Have fun!
