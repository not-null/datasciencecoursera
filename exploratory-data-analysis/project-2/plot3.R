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

baltimore.emissions <- subset(NEI,subset=(NEI$fips == "24510"), select=c(Emissions,year,type))

#this is huge, delete it after relevant information has been extracted
rm(NEI)

baltimore.emissions <- tbl_df(baltimore.emissions)
baltimore.emissions <- baltimore.emissions %>% group_by(year, type) %>% summarise(Emissions = sum(Emissions))

png(file = "plot3.png")

print(qplot(year, Emissions, data=baltimore.emissions, color=type, geom ="line")  + ggtitle("Baltimore City Emmission by source, type and year") + xlab("Year") + ylab("Total Emissions (in tons)"))

dev.off()
rm(list = ls())

