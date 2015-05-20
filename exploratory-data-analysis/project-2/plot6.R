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

# get all the rows from the data frame whhere EI.Sector column value has Vehicle in it.
motor.sources <- SCC[grep("Vehicles",SCC$EI.Sector),]

# filter the data from NEI for baltimore and los angeles
nei.filter <- filter(NEI, (fips == "24510" | fips == "06037"))

# join the data from above two data frames. It will retain only rows having same SCC common value
motor.join <- inner_join(nei.filter,motor.sources, by = "SCC")

#this is huge, delete it after relevant information has been extracted
rm(NEI)
rm(nei.filter)

# Group and summarise data
motor.data <- motor.join %>% group_by(year,fips) %>% summarise(Emissions = sum(Emissions))

rm(motor.join)

# create factors 
motor.data$fips <- factor(motor.data$fips, levels=c("06037", "24510"), c("Los Angeles County", "Baltimore City") )
motor.data$year <- factor(motor.data$year, levels=c("1999", "2002", "2005", "2008"))

png(file = "plot6.png")

qp <- ggplot(data=motor.data, aes(x=year, y=Emissions)) + geom_bar(aes(fill=year), stat = "identity") + guides(fill=F) + 
    ggtitle('Baltimore v/s Los Angeles - Motor Vehicle Total Emissions') + 
    ylab(expression('PM'[2.5])) + xlab('Year') + theme(legend.position='none') + facet_grid(. ~ fips) + 
    geom_text(aes(label=round(Emissions,0), size=1, hjust=0.5, vjust=-1))
print(qp)
dev.off()
rm(list = ls())

