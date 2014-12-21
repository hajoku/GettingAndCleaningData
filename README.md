GettingAndCleaningData
======================

This Repository contains data and R source code from a programming assignment from coursera.com. 

The data is collected from the accelerometers from the Samsung Galaxy S smartphone while people were doing several activities. More details are available in the code book.

The file run_analysis.R contains R sourcecode to merge the data from different files and folders, extract some columns, calculate averages in̂ order to create a clean data set, saves as tidydata.txt, that can be used for further analysis.

**Here's how the script works in detail:**

Step 1 of the assignment
-----

First, the 3 files from the folder */test/* are joined to one dataframe.
The same is done with the 3 files from */train/*, and afterwards these two dataframes are concataneted, since we don't need a training and testing dataset.

Step 2 of the assignment
------

The file *features.txt* contains the descriptions of the columns. I use regular expressions to extract the column names that start with 'mean' or 'std'. Then I extract the according columns from the dataset from Step 1.

*Note: I changed the  order of the steps from the assignment*

Step 4 of the assignment 
------
     
I used the colnames function to give the columns more descriptive names.
  

Step 3 of the assignment
------
 
I used a helper function and lapply to substitute the activity numbers with descriptive names

Step 5 of the assignment
-----

In step 5, we loop over all subjects and all activities and calculate the average of the columns with the colmeans function. This data is written to a file *tidydata.txt* 
