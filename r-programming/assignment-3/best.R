best <- function(state, outcome) {
    
    valid.outcome <- c("heart attack","heart failure", "pneumonia")
    column.outcome.mortality <- c(11,17,23)
    # Read outcome data
    input.data <- read.csv("rprog_data_ProgAssignment3-data/outcome-of-care-measures.csv", colClasses = "character")
    
    ## Check that state and outcome are valid
    ## State is column 7 in the data frame
    ## Get the state column from data frame after removing all duplicates
    valid.state <- unique(input.data[,"State"])
    if(!is.element(state,valid.state))
    {
        stop("invalid state")
    }
    if(!is.element(outcome, valid.outcome))
    {
        stop("invalid outcome")
    }
    
    ## Return hospital name in that state with lowest 30-day death ## rate
    ## get subset from the original data, we need to work on this data
    # 2 <- Hospital.Name
    # 11 <- Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attac
    # 17 <- Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure
    # 23 <- Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia
    
    if(outcome == valid.outcome [1])
    {
        # Handle heart attack
        # get the subset of data in which we are interested
        working.data <- subset ( input.data , input.data[,"State"] == state & !is.na(input.data[,11]), select = c(2,7,11))
        # sort the data in ascending order
        #working.data <- working.data [ order ( working.data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack ) , ] 
    }
    else if( outcome == valid.outcome [2])
    {
        # Handle heart failure
        working.data <- subset ( input.data , input.data[,"State"] == state & !is.na(input.data[,17]), select = c(2,7,17))
    }
    else if(outcome == valid.outcome [3])
    {
        # Handle heart pneumonia
        working.data <- subset ( input.data , input.data[,"State"] == state & !is.na(input.data[,23]), select = c(2,7,23))
    }
    
    # sort the data in ascending order by third column
    
    working.data <- working.data [ order ( as.numeric ( working.data [,3] ) ), ] 
    #write.csv(working.data, file="output.csv", row.names=T)
    
    # return the first value working.data$Hospital.Name vector
    working.data$Hospital.Name[1]

}

## Submit test cases

# best("SC", "heart attack")
# [1] "MUSC MEDICAL CENTER"

# best("NY", "pneumonia")
# [1] "MAIMONIDES MEDICAL CENTER"

# best("NN", "pneumonia")
# Error in best("NN", "pneumonia") : invalid state
