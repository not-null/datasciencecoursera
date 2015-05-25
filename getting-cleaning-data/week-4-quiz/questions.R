#Question-1 read the csv file

data <- read.table(file = "getdata_data_ss06hid.csv", header = TRUE, sep =",", nrows = 6497)
print ( strsplit(names(data)[123],"wgtp") )
rm(list = ls())

#Question-2 read the csv file

data <- read.csv(file = "getdata_data_GDP.csv", header = TRUE, sep =",", nrows = 331, stringsAsFactors = FALSE)
p <- as.numeric(gsub("[^0-9]", "", data[c(5:194), 5]))
print (mean(p))

rm(list = ls())

#Question-4 read the csv file

data <- read.csv(file = "getdata_data_GDP.csv", header = TRUE, sep =",", nrows = 331, stringsAsFactors = FALSE)
edu <- read.csv(file = "getdata_data_EDSTATS_Country.csv", header = TRUE, sep =",", nrows = 235, stringsAsFactors = FALSE)

library(dplyr)

data.filter <- data_frame(data[c(5:194),c(1)])
colnames(data.filter) <- "CountryCode"

edu.filter <- select(edu,CountryCode,Special.Notes)

data.join <- inner_join(edu.filter, data.filter, by = "CountryCode")
print(length(grep("Fiscal year end: June", data.join$Special.Notes)))
rm(list = ls())

#Question-5

library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn) 

in.2012 <- sampleTimes[grep("^2012", sampleTimes)]
print(length(in.2012))

library(lubridate)
monday.2012 <- grep("Monday", sapply(in.2012, wday, label =TRUE, abbr = FALSE))
print(length(monday.2012))
rm(list = ls())

