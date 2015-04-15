# Write a function that reads a directory full of files and reports the number of completely observed cases in each data file.
# The function should return a data frame where the first column is the name of the file 
# and the second column is the number of complete cases. A prototype of this function follows

complete <- function(directory, id = 1:332) {
    
    ## 'directory' is a character vector of length 1 indicating
    ## the location of the CSV files
    
    ## 'id' is an integer vector indicating the monitor ID numbers
    ## to be used
    
    ## Return a data frame of the form:
    ## id nobs
    ## 1  117
    ## 2  1041
    ## ...
    ## where 'id' is the monitor ID number and 'nobs' is the
    ## number of complete cases
    
    source(file='getCSV.R')
    curr.dir <- paste(c(getwd(),directory),collapse="/")    
    output <- data.frame()
    # loop
    for(file_no in 1:length(id))
    {
        # read csv
        input <- read.csv(get_csv_path(curr.dir, file_no, id))
        
        # get the value of two columns
        row.count <- nrow(input[complete.cases(input),])
        csv.id <- id[file_no]
        
        # construct a row for data frame input
        input.row <- c(csv.id , row.count)
        
        # bind it
        output <- rbind(output, input.row)
    }
    
    # give column names
    colnames(output) <- c('id', 'nobs')
    output
}

# example output from this function

#source("complete.R")
#complete("specdata", 1)

##   id nobs
## 1  1  117

#complete("specdata", c(2, 4, 8, 10, 12))

##   id nobs
## 1  2 1041
## 2  4  474
## 3  8  192
## 4 10  148
## 5 12   96

#complete("specdata", 30:25)

##   id nobs
## 1 30  932
## 2 29  711
## 3 28  475
## 4 27  338
## 5 26  586
## 6 25  463

#complete("specdata", 3)

##   id nobs
## 1  3  243
