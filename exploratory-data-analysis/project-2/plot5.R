# required libraries
library(ggplot2)
library(dplyr)

# Existence check
data.files <- dir("exdata_data_NEI_data", full.names = TRUE)
all.exists <- sapply(data.files, file.exists)

# Are all values true i.e. both file exists
if(!all(all.exists))
{
    stop("check dir -> exdata_data_NEI_data for files -> (summarySCC_PM25.rds or Source_Classification_Code.rds) for existence", call. = FALSE)
}

# This first line will likely take a few seconds. Be patient!

NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")

# get all the rows from the data frame whhere EI.Sector column value has Vehicle or Locomotives in it.
motor.sources <- SCC[grep("Vehicles",SCC$EI.Sector),]

# filter the data from NEI for baltimore citi
nei.filter <- filter(NEI,fips =="24510")

# join the data from above two data frames. It will retain only rows having same SCC common value
motor.join <- inner_join(nei.filter,motor.sources, by = "SCC")

#this is huge, delete it after relevant information has been extracted
rm(NEI)
rm(nei.filter)

# Group and summarise data
motor.data <- motor.join %>% group_by(year) %>% summarise(Emissions = sum(Emissions))

rm(motor.join)

png(file = "plot5.png")

bp <- barplot(motor.data$Emissions, motor.data$year,
        names.arg = motor.data$year, 
        xlab = "Year", ylab = "Total Emissions", 
        col = rainbow(20),
        ylim = c(0,500),
        main = "Total PM2.5 Emission - Motor Vehicle Sources - Unit (Tons)", border = "blue", density = c(10,20,30,40))
text(bp,motor.data$Emissions, labels = round(motor.data$Emissions,2), pos = 3, offset = 0.1)
dev.off()
rm(list = ls())

