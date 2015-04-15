
# Write a function named 'pollutantmean' that calculates the mean of a
# pollutant (sulfate or nitrate) across a specified list of monitors. 
# The function 'pollutantmean' takes three arguments: 'directory', 'pollutant', and 'id'. 
# Given a vector monitor ID numbers, 'pollutantmean' reads that monitors' 
# particulate matter data from the directory specified in the 'directory'
# argument and returns the mean of the pollutant across all of the monitors, 
# ignoring any missing values coded as NA.

pollutantmean <- function(directory, pollutant, id = 1:332) 
{
    
    ## 'directory' is a character vector of length 1 indicating
    ## the location of the CSV files
    
    ## 'pollutant' is a character vector of length 1 indicating
    ## the name of the pollutant for which we will calculate the
    ## mean; either "sulfate" or "nitrate".
    
    ## 'id' is an integer vector indicating the monitor ID numbers
    ## to be used
    
    ## Return the mean of the pollutant across all monitors list
    ## in the 'id' vector (ignoring NA values)
    
    source(file='getCSV.R')
    curr.dir <- paste(c(getwd(),directory),collapse="/")
    mean.vector <- vector(mode="numeric", length=0)
    # loop
    for(file_no in 1:length(id))
    {
        # read csv
        input <- read.csv(get_csv_path(curr.dir, file_no, id))
        
        # remove NA's
        remove.na <- input[!is.na(input[, pollutant]),pollutant]
        
        # store in vector
        mean.vector <- c(mean.vector, remove.na)
    }
    
    #calculate mean
    mean.final <- mean(mean.vector)
    round (mean.final,3)    
}

# # Example output 
# source("pollutantmean.R")
# pollutantmean("specdata", "sulfate", 1:10)
# 
# ## [1] 4.064
# 
# pollutantmean("specdata", "nitrate", 70:72)
# 
# ## [1] 1.706
# 
# pollutantmean("specdata", "nitrate", 23)
# 
# ## [1] 1.281


