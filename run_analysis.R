# Before you run this script, make sure your Working Directory is set properly

# Donwload and unzip zip file
zip.file.url <-
    "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zip.file.dest <- "samsung.zip"

if (!file.exists("./UCI HAR Dataset")) {
    if (!file.exists(zip.file.dest)) {
        download.file(url = zip.file.url, destfile = zip.file.dest, method = "curl")
        downloaded.at <- date()
    }
    unzip(zip.file.dest)
}

# Read required files from zip file

# Load general files
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)

# Name the columns of activity labels and features
names(activity_labels) <- c("Activity id", "Activity name")
names(features) <- c("Feature id", "Feature name")

# Load train and test files
subject_train <- read.table(file = "./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
X_train <- read.table(file = "./UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table(file = "./UCI HAR Dataset/train/y_train.txt", header = FALSE)

# Name the the subject_train column
names(subject_train) <- c("Subject id")

# Name y_train column and merges with the activity
names(y_train) <- c("Activity id")
y_train.01.mergedWithActivityName <- merge(x = activity_labels, y = y_train, all.y = TRUE)

# Name X_train columns and select only those which contains "mean" or "std" into its text title
names(X_train) <- features$`Feature name`
X_train.01.sliced <- X_train[,grep("mean\\(\\)|std\\(\\)", names(X_train))]

# Binds all 3 train sets
train.subject.activity.features <- cbind(subject_train, y_train.01.mergedWithActivityName, X_train.01.sliced)

### Repeat the same steps now for test sets

# Load test and test files
subject_test <- read.table(file = "./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
X_test <- read.table(file = "./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table(file = "./UCI HAR Dataset/test/y_test.txt", header = FALSE)

# Name the the subject_test column
names(subject_test) <- c("Subject id")

# Name y_test column and merges with activity
names(y_test) <- c("Activity id")
y_test.01.mergedWithActivityName <- merge(x = activity_labels, y = y_test, all.y = TRUE)

# Name X_test columns and select only those which contains "mean" or "std" into its text title
names(X_test) <- features$`Feature name`
X_test.01.sliced <- X_test[,grep("mean\\(\\)|std\\(\\)", names(X_test))]

# Binds all 3 test sets
test.subject.activity.features <- cbind(subject_test, y_test.01.mergedWithActivityName, X_test.01.sliced)

# Unify the train and test sets putting the train observations at the beginning and the test observations at the end
subject.activity.features <- rbind(train.subject.activity.features, test.subject.activity.features)

# Converts the columns titles into descriptive text
column.names <- names(subject.activity.features)
for(i in seq_along(column.names)){
    column.name <- column.names[i]
    desc = character(0)
    if(grepl("mean\\(\\)", column.name)){
        desc <- "Mean"
    }else if(grepl("std\\(\\)", column.name)){
        desc <- "Standard Deviation of"
    }
    
    if(grepl("^t", column.name)){
        desc <- paste(desc, "time", sep = " ")
    }else if(grepl("^f", column.name)){
        desc <- paste(desc, "frequency", sep = " ")
    }
    
    if(grepl("Body", column.name)){
        desc <- paste(desc, "from body", sep = " ")
    }else if(grepl("Gravity", column.name)){
        desc <- paste(desc, "gravity", sep = " ")
    }
    
    if(grepl("Acc", column.name)){
        desc <- paste(desc, "accelerometer", sep = " ")
    }else if(grepl("Gyro", column.name)){
        desc <- paste(desc, "gyroscope", sep = " ")
    }
    
    if(grepl("Jerk", column.name)){
        desc <- paste(desc, "in Jerk signals", sep = " ")
    }
    
    if(grepl("Mag", column.name)){
        desc <- paste(desc, "with Euclidean norm magnitude", sep = " ")
    }
    
    if(grepl("-[XYZ]",column.name)){
        desc <- paste(desc, "at", substr(column.name, start = nchar(column.name), stop = nchar(column.name)), "axis", sep = " ")
    }
    
    if(!identical(desc, character(0))){
        colnames(subject.activity.features)[i] <- desc
    }
}

# Calculates the mean of each feature grouping by subject and by activity
subject.activity <- aggregate(subject.activity.features[,4:69], by = subject.activity.features[c('Subject id', 'Activity name')], FUN = mean)

# Output the result into a txt file
write.table(x = subject.activity, file = "samsungtidydataset.txt", quote = TRUE, sep = ",", na = "NA", row.names = FALSE)