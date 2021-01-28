library(dplyr)

# Read test data
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test_data <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test_data <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Read training data
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train_data <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train_data <- read.table("./UCI HAR Dataset/train/subject_train.txt")


temp_feats <- read.table("./UCI HAR Dataset/features.txt")
# Get the column names
col_names <- temp_feats$V2

# Rename the column names so they are more descriptive (Point 4 of course project)
colnames(test_data) <- col_names
colnames(train_data) <- col_names


# Only keep the columns of the measurements with mean or standard deviation
# (Point 2 of the course project)
test_data <- select(test_data,matches("mean\\(|std\\("))
train_data <- select(train_data,matches("mean\\(|std\\("))

# Add new columns to include subject ID and activity
test_data$subjectid = subject_test_data$V1
test_data$activity = y_test_data$V1

train_data$subjectid = subject_train_data$V1
train_data$activity = y_train_data$V1

# Combine/Merge both the test and training data sets (Point 1 of the course
# project)
combined_data <- rbind(train_data,test_data)

# Rename the column names to remove the () in the names
names(combined_data) <- make.names(names(combined_data))
names(combined_data) <- gsub("\\.", "", names(combined_data))


# Might be some more elegant way to do this, but since there are only
# 6 activities I can do it by hand. :-)
# (Point 3 of the course project)
combined_data$activity[combined_data$activity == 1] <- "WALKING"
combined_data$activity[combined_data$activity == 2] <- "WALKING_UPSTAIRS"
combined_data$activity[combined_data$activity == 3] <- "WALKING_DOWNSTAIRS"
combined_data$activity[combined_data$activity == 4] <- "SITTING"
combined_data$activity[combined_data$activity == 5] <- "STANDING"
combined_data$activity[combined_data$activity == 6] <- "LAYING"

# Create a second, independent tidy data set with the average of each variable 
# for each activity and each subject. (Step 5 of project)
ave_tidy_df <- aggregate(. ~ subjectid + activity,data=combined_data,mean)

# Write out the tidy data set per instructions
write.table(ave_tidy_df, "tidy_dataset.txt", row.names=FALSE)


