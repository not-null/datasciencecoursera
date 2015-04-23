rankall <- function(outcome, num="best")
{
    valid.outcome <- c("heart attack","heart failure", "pneumonia")
    valid.num <- c("best","worst")
    
    # check the outcome and num first, even before reading the data
    # as they are not dependant on the data
    if(!is.element(outcome, valid.outcome))
    {
        stop("invalid outcome")
    }
    if(!is.element(num,valid.num))
    {
        # it may be a number check for it
        if(suppressWarnings(is.na(as.numeric(num))) )
        {
            stop("invalid num")
        }
    }

    ## Read outcome data
    input.data <- read.csv("rprog_data_ProgAssignment3-data/outcome-of-care-measures.csv", colClasses = "character")
    
    valid.state <- sort(unique(input.data[,"State"]))
    
    ## preallocate data frame with number of rows = no of state
    INITIAL.ROWS <- length(valid.state)
    output.data.frame <- data.frame(hospital=character(INITIAL.ROWS), state=character(INITIAL.ROWS) , row.names = valid.state, stringsAsFactors = FALSE)
    
    ## For each state, find the hospital of the given rank
    ## iterate over all the states
    for(state.index in 1:length(valid.state))
    {
        # get the subset of input data to work on
        # We already know the columns of interest
        # 2 <- Hospital.Name
        # 11 <- Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attac
        # 17 <- Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure
        # 23 <- Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia
        
        if(outcome == valid.outcome [1])
        {
            # Handle heart attack
            # get the subset data of state of interest
            list.hospital <- subset ( input.data , input.data[,"State"] == valid.state[state.index] & input.data[,11] != "Not Available", select = c(2,7,11))
            # sort the data in ascending order
        }
        else if( outcome == valid.outcome [2])
        {
            # Handle heart failure
            list.hospital <- subset ( input.data , input.data[,"State"] == valid.state[state.index] & input.data[,17] != "Not Available", select = c(2,7,17))
        }
        else if(outcome == valid.outcome [3])
        {
            # Handle pneumonia
            list.hospital <- subset ( input.data , input.data[,"State"] == valid.state[state.index] & input.data[,23] != "Not Available", select = c(2,7,23))
        }
        
        # order the data frame by column rate. 
        list.hospital <- list.hospital [ order ( as.numeric ( list.hospital [,3] ) , list.hospital[,1] ), ] 
        
        if(num == valid.num[1])
        {
            # best
            input.hospital <- list.hospital$Hospital.Name[1]
        }
        else if(num == valid.num[2])
        {
            # worst
            input.hospital <- list.hospital$Hospital.Name[length(list.hospital[,1])]
        }
        else
        {
            # number
            if(as.numeric(num) > length(list.hospital[,1]) ) 
            {
                # ain't enough hospitals
                input.hospital <- "<NA>"
            }
            else
            {
                # get the corresponding num lowest 30-day death rate
                input.hospital <- list.hospital$Hospital.Name[as.numeric(num)]
            }
        }
        output.data.frame$hospital[state.index] <- input.hospital
        output.data.frame$state[state.index] <- valid.state[state.index]
    }
    # write.csv(output.data.frame, file="output.csv", row.names=T)
    output.data.frame
    ## Return a data frame with the hospital names and the ## (abbreviated) state name
}