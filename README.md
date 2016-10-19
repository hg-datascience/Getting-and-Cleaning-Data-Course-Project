# Getting and Cleaning Data Course Project

This repo contains the following files:
 * An R script (`run_analysis.R`) that performs data collection, cleaning, transformation and summarization operations.
 * The resulting dataset: `tidy_data.txt`
 * The dataset Codebook: `codebook.md`

## run_analysis.R

The script proceeds as follows:

1. Downloads the original [`Human Activity Recognition Using Smartphones Dataset`](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) dataset and then decompresses it.

2. Creates a filter (referred onwards as `featuresFilter`) that extracts only the measurements on the mean and standard deviation features from the `UCI HAR Dataset/features.txt` file and enhances some features' names readability.

3. Merges the training and the testing dataset into one single dataset:
  1. Loads the training dataset and the testing dataset:
    1. Features' loading and filters them by using the `featuresFilter`
    2. Labels' loading
    3. Subjects' loading
    4. Merges them by using the `cbind` function
    5. These operations create two separate datasets: `trainingData` and `testingData`
  2. Merges the `trainingData` and `testingData` into one dataset named `data` by using the `rbind` function and then sets the correspondent column names.

4. Finally, the data core reshaping operations take place:
  1. Converts the 'subject' and 'activity' (setting the value to the textual name - extracted from `UCI HAR Dataset/activity_labels.txt`) into factors
  2. Reshapes the `data` to long-format by using the `subject` and `activity` as id vars.
  3. Reshapes it back to wide-format by using the `dcast` function. This operation uses then `mean` as the aggregate operation function and `subject` and `activity` as id vars.

5. Terminates by saving the summarized dataset to `tidy_data.txt`.
