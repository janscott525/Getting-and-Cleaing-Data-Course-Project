require(plyr)

##Load training data and labels from downloaded text files:
setwd("c:/RWorkingDir/UCI HAR Dataset")
features <- read.table("./features.txt")
a_labels <- read.table("./activity_labels.txt")
x_train <- read.table("./train/X_train.txt", header=FALSE)
y_train <- read.table("./train/y_train.txt", header=FALSE)
sub_train <- read.table("./train/subject_train.txt", header=FALSE)

##Load test data from downloaded text files:
x_test <- read.table("./test/X_test.txt", header=FALSE)
y_test <- read.table("./test/y_test.txt", header=FALSE)
sub_test <- read.table("./test/subject_test.txt", header=FALSE)


##Merge training data
training_data <- cbind(x_train, y_train, sub_train)

##Merge test data
test_data <- cbind(x_test, y_test, sub_test)

##1.Merge test and training data
tst_trn_data <- rbind(training_data, test_data)

##2.Create data frame that subsets IDs, Mean and Std. Deviation columns:
tst_trn_final <- tst_trn_data[,grepl("mean|std|Subject|Activity_ID", names(tst_trn_data))]

## Clean up column names
tst_trn_cnames <- colnames(tst_trn_final)

for (i in 1:length(tst_trn_cnames)) {
    tst_trn_cnames[i] = gsub("\\()","",tst_trn_cnames[i]) 
    tst_trn_cnames[i] = gsub("-std$","StdDev",tst_trn_cnames[i]) 
    tst_trn_cnames[i] = gsub("-mean","Mean",tst_trn_cnames[i]) 
    tst_trn_cnames[i] = gsub("^(t)","time",tst_trn_cnames[i]) 
    tst_trn_cnames[i] = gsub("^(f)","freq",tst_trn_cnames[i]) 
    tst_trn_cnames[i] = gsub("([Gg]ravity)","Gravity",tst_trn_cnames[i]) 
    tst_trn_cnames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",tst_trn_cnames[i]) 
    tst_trn_cnames[i] = gsub("[Gg]yro","Gyro",tst_trn_cnames[i]) 
    tst_trn_cnames[i] = gsub("AccMag","AccMagnitude",tst_trn_cnames[i]) 
    tst_trn_cnames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",tst_trn_cnames[i]) 
    tst_trn_cnames[i] = gsub("JerkMag","JerkMagnitude",tst_trn_cnames[i]) 
    tst_trn_cnames[i] = gsub("GyroMag","GyroMagnitude",tst_trn_cnames[i]) 
}

##4.Renames the columns in the data set using the clean names 
colnames(tst_trn_final) <- tst_trn_cnames

##5.Subsets averag of activity
Avg_Sub_Act = ddply(tst_trn_final, c("Subject_ID","Activity_ID"), numcolwise(mean))
write.table(Avg_Sub_Act, file = "Avg_Sub_Act.txt")
