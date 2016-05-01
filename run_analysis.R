
if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("reshape2")) {
  install.packages("reshape2")
}

require("data.table")
require("reshape2")

# Set working directory
setwd("~/Downloads/UCI HAR Dataset")
#Read datasets and labels
X_test <- read.table("test/X_test.txt")
Y_test <- read.table("test/Y_test.txt")
subject_test <- read.table("test/subject_test.txt")

X_train <- read.table("train/X_train.txt")
Y_train <- read.table("train/Y_train.txt")
subject_train <- read.table("train/subject_train.txt")
# activity labels
activity_labels <- read.table("activity_labels.txt")[,2]
# fatures
features <- read.table("features.txt")[,2]
#meqn qnd sd of features
extract_features <- grepl("mean|std", features)

names(X_test) = features
names(X_train) = features

X_test = X_test[,extract_features]
X_train = X_train[,extract_features]

#activity labels
Y_test[,2] = activity_labels[Y_test[,1]]
names(Y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

Y_train[,2] = activity_labels[Y_train[,1]]
names(Y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

#bind test and train data
test_data <- cbind(as.data.table(subject_test), Y_test, X_test)
train_data <- cbind(as.data.table(subject_train), Y_train, X_train)

# Merge test and train data
data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data= melt(data, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "tidy_data.txt")











