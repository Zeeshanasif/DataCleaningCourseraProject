#sourcing packages
library("dplyr")
library("plyr")

#reading test tables
X_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")

#reading train tables
X_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt")

#reading activity labels index and variable names
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt")
features<-read.table("./UCI HAR Dataset/features.txt")

#fetching variable names from 'features'
names(X_train)<-features$V2
names(X_test)<-features$V2

#adding named lables to y_train, y_test and properly naming their columns
y_train<-join(y_train,activity_labels)
names(y_train)<-c("activity_id","activity_label")
y_test<-join(y_test,activity_labels)
names(y_test)<-c("activity_id","activity_label")

#naming columns of subject_test and subject_train
names(subject_test)<-"subject"
names(subject_train)<-"subject"

#binding subjects to X_train and X_test
X_test<-mutate(X_test,test_subject=subject_test$subject)
X_train<-mutate(X_train,test_subject=subject_train$subject)

#binding activity labels
X_test<-mutate(X_test,activity_description=y_test$activity_label)
X_train<-mutate(X_train,activity_description=y_train$activity_label)

#binding test and train data and rearranging columns to place 'subject' and 'activity_description' in beginning
X_train_test<-bind_rows(X_train,X_test)
X_combined<-X_train_test[,c(562,563,1:561)];View(X_combined)

#Extract columns with mean and std
X_mean_std<-select(X_combined,test_subject,activity_description,contains("mean"),contains("std"))

#Summarises averages as requested in step 5
X_grouped<-group_by(X_mean_std,test_subject,activity_description)
X_average<-summarise_each(X_grouped,funs(mean),3:88)

write.table(X_average,"X_average.txt")
View(X_average)

