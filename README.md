This script **run_analysis.R** is created to:
1. Loading train and test data into two separate data frames: **trainDF** and **testDF**. 
2. Labels data frames **trainDF** and **testDF** with descriptive variable names.
3. Merge **trainDF** and **testDF** into one data frame: **mergedDF**.
4. For **mergedDF** Extracts only the measurements on the mean and standard deviation for each measurement.
5. Uses descriptive activity names to name the activities in **mergedDF**.
6. Based on **mergedDF**, create a second independent, tidy data set **finalDF** with the average of each variable for each activity and each subject.
7. Write **mergedDF** and **finalDF** into txt files using **write.table()**
