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

emission.all.sources <- aggregate(Emissions ~ year,NEI, sum)

png(file = "plot1.png")
barplot(emission.all.sources$Emissions/1000000, emission.all.sources$year,
        names.arg = emission.all.sources$year, 
        xlab = "Year", ylab = "Total Emissions - All Sources (10 ^ 6) Tons", 
        main = "Total PM2.5 Emission Sources Plot", border = "blue", density = c(10,20,30,40))
dev.off()