rankhospital <- function(state, outcome, num = "best")
{
    valid.outcome <- c("heart attack","heart failure", "pneumonia")
    valid.num <- c("best","worst")
    # Read the data
    input.data <- read.csv("rprog_data_ProgAssignment3-data/outcome-of-care-measures.csv", colClasses = "character")
    
    valid.state <- unique(input.data[,"State"])
    if(!is.element(state,valid.state))
    {
        stop("invalid state")
    }
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
    # get the subset of input data to work on
    # We already know the columns of interest
    # 2 <- Hospital.Name
    # 11 <- Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attac
    # 17 <- Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure
    # 23 <- Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia
    
    if(outcome == valid.outcome [1])
    {
        # Handle heart attack
        # get the subset of data in which we are interested
        list.hospital <- subset ( input.data , input.data[,"State"] == state & input.data[,11] != "Not Available", select = c(2,7,11))
        # sort the data in ascending order
    }
    else if( outcome == valid.outcome [2])
    {
        # Handle heart failure
        list.hospital <- subset ( input.data , input.data[,"State"] == state & input.data[,17] != "Not Available", select = c(2,7,17))
    }
    else if(outcome == valid.outcome [3])
    {
        # Handle pneumonia
        list.hospital <- subset ( input.data , input.data[,"State"] == state & input.data[,23] != "Not Available", select = c(2,7,23))
    }
    
    # order the data frame by columns. 
    # First order by rates and then alphabetically 
    list.hospital <- list.hospital [ order ( as.numeric ( list.hospital [,3] ), list.hospital[,1] ), ] 
        
    if(num == valid.num[1])
    {
        # best
        list.hospital$Hospital.Name[1]
    }
    else if(num == valid.num[2])
    {
        # worst
        list.hospital$Hospital.Name[length(list.hospital[,1])]
    }
    else
    {
        # number
        if(as.numeric(num) > length(list.hospital[,1]) ) 
        {
            # ain't enough hospitals
            return ("NA")
        }
        else
        {
            # get the corresponding num lowest 30-day death rate
            list.hospital$Hospital.Name[as.numeric(num)]
        }
    }
}

# Submit test case's

# rankhospital("NC", "heart attack", "worst")
# [1] "WAYNE MEMORIAL HOSPITAL"

# rankhospital("WA", "heart attack", 7)
# [1] "YAKIMA VALLEY MEMORIAL HOSPITAL"


# rankhospital("WA", "pneumonia", 1000)
# [1] "NA"

# rankhospital("NY", "heart attak", 7)
# Error in rankhospital("NY", "heart attak", 7) : invalid outcome