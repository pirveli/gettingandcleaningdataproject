To perform the analysis as required by the Getting and Cleaning Data project outline the following steps were taken.
The main goal of the project is to prepare tidy data set based on provided data files.

The script run_analysis.R uses dplyr package for manipulation of data. It allows to summarise data easily. This package has to be installed prior to the analysis.

The first step is to read all relevant data train and test data files into the memory (actual data, variable names, activity names, subject ids.

In the next step activities are verbosed i.e. nnumeric values are replaced with strings. This makes data more human readable which is required by tidy data paradigm. Also appropiate column names are assigned to subject and activity data.

Since the variables of interest are those that contain mean ("-mean()" suffix) and standard deviation ("-std()" suffix) of measured activities the next steps selects only those column names and subsets the train and test data sets.

After selecting desired columns from train and test sets all the data are merged into single data frame. Column names of all variables are raw and not human readable, so the new names are prepared and then substituted. This is in accordance of tidy data principles. Each column name can have of two suffixes: ".time" and ".freq". These denote measurements in time and frequency domains, respectively. In the raw data they were dentoted with "t" and "f" prefixes, respectively.

After these preparation steps the analysis can be performed. The data is grouped by subject and activity as stated in the project requirements. Next, the mean values of all variables for each subject and activity are calculated and saved in the ascii file. The resulting file fulfills tidy data principles.
