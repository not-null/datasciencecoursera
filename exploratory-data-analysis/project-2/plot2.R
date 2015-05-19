# Existence check
data.files <- dir("exdata_data_NEI_data", full.names = TRUE)
all.exists <- sapply(data.files, file.exists)

# Are all values true i.e. both file exists
if(!all(all.exists))
{
    stop("check dir -> exdata_data_NEI_data for files -> (summarySCC_PM25.rds or Source_Classification_Code.rds) for existence", call. = FALSE)
}

## This first line will likely take a few seconds. Be patient!

NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")

baltimore.emissions <- subset(NEI,subset=(NEI$fips == "24510"), select=c(Emissions,year))

#this is huge, delete it after relevant information has been extracted
rm(NEI)

baltimore.agg <- aggregate(baltimore.emissions$Emissions ~ baltimore.emissions$year, baltimore.emissions, sum)
colnames(baltimore.agg) <- c("year", "Emissions")

png(file = "plot2.png")
barplot(baltimore.agg$Emissions, baltimore.agg$year,
        names.arg = baltimore.agg$year,
        xlab = "Year", ylab = "Emissions - All Sources in Tons",
        main = "Total PM2.5 Emission Sources Plot for Baltimore City", border = "blue", density = c(10,20,30,40))
dev.off()
rm(list = ls())