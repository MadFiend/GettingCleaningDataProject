#############################################################################################
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy 
##    data set with the average of each variable for each activity and each subject.
#############################################################################################

setwd("C:/Users/MadFiend/Desktop/R_datascience/R_GettingData/project")

require(plyr)

# Download and unzip the data  

fileName <- "dataset.zip"

if(!file.exists(fileName)) {
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, destfile = fileName, mode = "wb")
  unzip(fileName)
}
# Load the test data
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

# Load the train data
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)

# Load the features and activity labels
features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt") 

# Assign column names to the test and train data
colnames(x_test) = features[, 2]
colnames(subject_test) = "Subject Id"
colnames(y_test) = "Activity Id"

colnames(x_train) = features[, 2]
colnames(y_train) = "Activity Id"
colnames(subject_train) = "Subject Id"

colnames(activity_labels) = c("Activity Id", "Activity")

###########################################################
# 1. Merge the training and test sets to create one dataset
###########################################################

# Bind the x, y, and subject_ test data into one test_data object
test_data <- cbind(y_test, subject_test, x_test)

# Again for the train data into train_data object
train_data <- cbind(y_train, subject_train, x_train)

# Finally, create a data frame that contains all the test and train data
data <- rbind(train_data, test_data)

########################################################
# 2. Extract measurements on mean and standard deviation
########################################################

std_mean_data <- data[grepl("mean|std|Subject|Activity", names(data))]

##################################################################################
# 3. Add descrptive labels to the Activity Id column from the activity_labels data
##################################################################################

std_mean_data$'Activity Id' <- mapvalues(std_mean_data$'Activity Id', 
                                  from = c(1, 2, 3, 4, 5, 6), 
                                  to = c("walking", "walking upstairs", "walking downstairs", 
                                              "sitting", "standing", "laying"))

########################################
# 4. Give the dataset appropriate labels
########################################

names(std_mean_data) <- gsub('Acc',"Acceleration",names(std_mean_data))
names(std_mean_data) <- gsub('GyroJerk',"AngularAcceleration",names(std_mean_data))
names(std_mean_data) <- gsub('Gyro',"AngularSpeed",names(std_mean_data))
names(std_mean_data) <- gsub('Mag',"Magnitude",names(std_mean_data))
names(std_mean_data) <- gsub('^t',"TimeDomain.",names(std_mean_data))
names(std_mean_data) <- gsub('^f',"FrequencyDomain.",names(std_mean_data))
names(std_mean_data) <- gsub('mean',".Mean",names(std_mean_data))
names(std_mean_data) <- gsub('std',".StandardDeviation",names(std_mean_data))
names(std_mean_data) <- gsub('Freq\\.',"Frequency",names(std_mean_data))
names(std_mean_data) <- gsub('Freq$',"Frequency",names(std_mean_data))
names(std_mean_data) <- gsub('\\(|\\)', '', names(std_mean_data)) # remove parentheses
names(std_mean_data) <- gsub('-', '', names(std_mean_data)) # remove some residual hyphens

##########################################################################
# 5. Make a second independent tidy data set 
#    with the average of each variable for each activity and each subject.
##########################################################################

# Aggregate the data.

tidyData <- aggregate(std_mean_data[, 3:ncol(std_mean_data)], 
              by = list(Subject = std_mean_data$`Subject Id`, Activity = std_mean_data$`Activity Id`), 
                mean)

# Write the new table to a .txt file.

write.table(tidyData, file = "tidyData.txt", row.names = FALSE)

