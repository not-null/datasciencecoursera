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

# get all the rows from the data frame whhere EI.Sector column value has Coal in it.
coal.sector <- SCC[grep("Coal", SCC$EI.Sector),]

# join the data from two data frames. It will retain only rows having same SCC value
nei.join <- inner_join(NEI,coal.sector, by = "SCC")

#this is huge, delete it after relevant information has been extracted
rm(NEI)

# Group and summarise data
caal.data <- nei.join %>% group_by(year) %>% summarise(Emissions = sum(Emissions))

rm(nei.join)

png(file = "plot4.png")

barplot(caal.data$Emissions/100000, caal.data$year,
        names.arg = caal.data$year, 
        xlab = "Year", ylab = "Total Emissions - Unit (10 ^ 5) Tons", 
        col = rainbow(20),
        ylim = c(0,8),
        main = "Total PM2.5 Emission - Coal Combustion Related Sources", border = "blue", density = c(10,20,30,40))
dev.off()
rm(list = ls())

