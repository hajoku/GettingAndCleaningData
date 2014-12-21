### this script reads in a bunch of files from an experiment with movement data from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
### after reading the data into dataframes, we merge them, extract some columns  and do some average calculations

#read in test data
X_test  = read.table('./test/X_test.txt')
y_test  = read.table('./test/y_test.txt')
subject_test = read.table('./test/subject_test.txt')
test = data.frame(X_test,y_test,subject_test)

#read in training data
X_train = read.table('./train/X_train.txt')
y_train = read.table('./train/y_train.txt')
subject_train = read.table('./train/subject_train.txt')
train = data.frame(X_train,y_train,subject_train)

#combine the two
combined = rbind(test,train)

## Step 1 finished

#we only wnat the columns with mean and std
descriptions  = read.csv('features.txt', sep = ' ', stringsAsFactors=FALSE)
#to lazy to write them out individually by hand, so I use regular expressions
mean_columns = grep("mean\\(\\)$", descriptions[[2]], value = FALSE)
std_columns = grep("std\\(\\)$", descriptions[[2]], value = FALSE)

#we want to keep the mean, std, activity and  subject columns
combined_mean_std=combined[,c(mean_columns, std_columns,562,563)]

## Step 2 finished

# give the columns better names
colnames(combined_mean_std) <- c("Mean of Magnitude of body acceleration",
                                 "Mean of Magnitude of gravity acceleration", 
                                 "Mean of Magnitude of body acceleration Jerk", 
                                 "Mean of Magnitude of body gyroscope",
                                 "Mean of Magnitude of body gyroscope jerk",
                                 "Mean of FFT of body acceleration", 
                                 "Mean of FFT of body acceleration jerk", 
                                 "Mean of FFT of body gyroscope",
                                 "Mean of FFT of body gyroscope jerk",
                                 "STD of Magnitude of body acceleration",
                                 "STD of Magnitude of gravity acceleration", 
                                 "STD of Magnitude of body acceleration Jerk", 
                                 "STD of Magnitude of body gyroscope",
                                 "STD of Magnitude of body gyroscope jerk",
                                 "STD of FFT of body acceleration", 
                                 "STD of FFT of body acceleration jerk", 
                                 "STD of FFT of body gyroscope",
                                 "STD of FFT of body gyroscope jerk",
                                 "activity",
                                 "subject"
                                 )

## step 4 finished (before Step 3)

# map activity numbers into human  readable format. Define a function for that
num2act <- function(n) { 
    if (n == 1) {
         return ("walking")
    }
    if (n == 2) {
         return ("walking upstairs")
    }
    if (n == 3) {
        return ("walking downstairs")
    }
    if (n == 4) {
        return ("sitting")
    }
    if (n == 5) {
        return("standing")
    }
    if (n == 6) {
        return("laying")
    }
}
combined_mean_std$activity <- lapply(combined_mean_std$activity, num2act)
combined_mean_std$activity <- unlist(combined_mean_std$activity)

## Step 3 finished

#calculate the average over the subjects and activities per measurement


#couldn't find a better way to get all the data in one dataframe in the end then
#to put the numerical data in a dataframe and the subjects and activities into a matrix. it's kind of ugly, I know
avg_set_num  = data.frame(stringsAsFactors = FALSE)
#in order to init the matrix, we need a first row, which we're going to delete in the end
deleteme <- c("delete","me")
avg_set_char = deleteme

subjects = as.character(unique(combined_mean_std$subject))
activities = as.character(unique(combined_mean_std$activity))

#for all subjects and activities...
for (s in subjects) {
    for (a in activities){
        #...calculate the mean of the values
        avg_row <- colMeans(combined_mean_std[(combined_mean_std$subject == s & combined_mean_std$activity == a),1:18])
        
        #append the new values to the existing df/matrix
        dim(avg_row) <- c(1,18)
        avg_set_num <- rbind(avg_set_num, avg_row)
        avg_set_char <- rbind(avg_set_char, c(a,s))
    }
}
#delete the first dummy row
avg_set_char <- avg_set_char[-1,]
#merge df and matrix
avg_set = data.frame(avg_set_num, avg_set_char)
colnames(avg_set) <- colnames(combined_mean_std)
write.table(avg_set, file = "tidydata.txt",  row.names = FALSE)
