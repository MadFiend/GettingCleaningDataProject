---
title: ""
author: "David Mooney"
date: "January 29, 2016"
output: html_document
---

The purpose of this project is to demonstrate an ability to obtain, work with, and clean data as part of the Cousera course Getting and Cleaning Data offered by Johsn Hopkins University as part of the Data Science Specialization. 

The script `run_analysis.R` downloads and unzips the the necessary files, then performs a series of operations to produce a 'tidy' data set that is ready for further analysis.

The script:
1. Downloads, unzips and merges the data into one data set.
2. Assigns descriptive labels to the activity, subject and variables in the data set
3. Extracts mean and standard variation columns from the complete data set.
4. Calculates averages for the variables for each subject and activity.
5. Produces a new text file containing these averages in `tidyData.txt`

Note: Data files should be in working directory before running `run_analysis.R`