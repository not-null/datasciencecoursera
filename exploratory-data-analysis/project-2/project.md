---
title: "Exploratory Data Analysis - Course Project 2"
output:
  html_document:
    highlight: monochrome
    number_sections: false
    theme: readable
    toc: yes

---
************
This document contains the project work including questions and corresponding answers. When required explanation is also provided.

# Introduction

Fine particulate matter (PM2.5) is an ambient air pollutant for which there is strong evidence that it is harmful to human health. In the United States, the Environmental Protection Agency (EPA) is tasked with setting national ambient air quality standards for fine PM and for tracking the emissions of this pollutant into the atmosphere. Approximatly every 3 years, the EPA releases its database on emissions of PM2.5. This database is known as the National Emissions Inventory (NEI). 

For each year and for each type of PM source, the NEI records how many tons of PM2.5 were emitted from that source over the course of the entire year. The data that you will use for this assignment are for 1999, 2002, 2005, and 2008.

# Data
The data for this assignment are available from the course web site as a single zip file:

* [Data for Peer Assessment](https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip)[29Mb]

The zip file contains two files:

PM2.5 Emissions Data <span style="color:red;">`(summarySCC_PM25.rds)`</span>: This file contains a data frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. For each year, the table contains number of tons of PM2.5 emitted from a specific type of source for the entire year. Here are the first few rows.

```
##     fips      SCC Pollutant Emissions  type year
## 4  09001 10100401  PM25-PRI    15.714 POINT 1999
## 8  09001 10100404  PM25-PRI   234.178 POINT 1999
## 12 09001 10100501  PM25-PRI     0.128 POINT 1999
## 16 09001 10200401  PM25-PRI     2.036 POINT 1999
## 20 09001 10200504  PM25-PRI     0.388 POINT 1999
## 24 09001 10200602  PM25-PRI     1.490 POINT 1999
```

* <span style="color:red;">`fips`</span>: A five-digit number (represented as a string) indicating the U.S. county
* <span style="color:red;">`SCC`</span>: The name of the source as indicated by a digit string (see source code classification table)
* <span style="color:red;">`Pollutant`</span>: A string indicating the pollutant
* <span style="color:red;">`Emissions`</span>: Amount of PM2.5 emitted, in tons
* <span style="color:red;">`type`</span>: The type of source (point, non-point, on-road, or non-road)
* <span style="color:red;">`year`</span>: The year of emissions recorded

Source Classification Code Table (<span style="color:red;">Source_Classification_Code.rds</span>): This table provides a mapping from the SCC digit strings in the Emissions table to the actual name of the PM2.5 source. The sources are categorized in a few different ways from more general to more specific and you may choose to explore whatever categories you think are most useful. For example, source “10100101” is known as “Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal”.

You can read each of the two files using the <span style="color:red;">readRDS()</span> function in R. For example, reading in each file can be done with the following code:

```
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
```
as long as each of those files is in your current working directory (check by calling <span style="color:red;"> dir()</span> and see if those files are in the listing).

# Assignment 

The overall goal of this assignment is to explore the National Emissions Inventory database and see what it say about fine particulate matter pollution in the United states over the 10-year period 1999–2008. You may use any R package you want to support your analysis.

## Making and Submitting Plots

For each plot you should

* Construct the plot and save it to a **PNG file**.

* Create a separate R code file (<span style="color:red;">plot1.R, plot2.R</span>, etc.) that constructs the corresponding plot, i.e. code in plot1.R constructs the plot1.png plot. Your code file should include code for reading the data so that the plot can be fully reproduced. You must also include the code that creates the PNG file. Only include the code for a single plot (i.e. <span style="color:red;">plot1.R</span> should only include code for producing <span style="color:red;">plot1.png</span>)

* Upload the PNG file on the Assignment submission page

* Copy and paste the R code from the corresponding R file into the text box at the appropriate point in the peer assessment.

# Common Code

<span style="color:blue;">*Below code checks for files existence and will be common to all the plot R scripts*</span>
```
# Existence check
data.files <- dir("exdata_data_NEI_data", full.names = TRUE)
all.exists <- sapply(data.files, file.exists)

# Are all values true i.e. both file exists
if(!all(all.exists))
{
    stop("check dir -> exdata_data_NEI_data for files -> (summarySCC_PM25.rds or Source_Classification_Code.rds) for existence", call. = FALSE)
}
```

# Questions & Answers

You must address the following questions and tasks in your exploratory analysis. For each question/task you will need to make a single plot. Unless specified, you can use any plotting system in R to make your plot.

## 1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the **base** plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

As <span style="color:red;">all sources</span> is mentioned, we will aggregate the emission for each of the years. Here we **don't** need to calculate specific source.

```
emission.all.sources <- aggregate(Emissions ~ year,NEI, sum)
```

Using barplot as it makes more sense.

```
png(file = "plot1.png")
barplot(emission.all.sources$Emissions/1000000, emission.all.sources$year,
        names.arg = emission.all.sources$year, 
        xlab = "Year", ylab = "Total Emissions - All Sources (10 ^ 6) Tons", 
        main = "Total PM2.5 Emission Sources Plot", border = "blue", density = c(10,20,30,40))
dev.off()
```

From the plot, we can say that, **yes** total emissons from PM2.5 has decreased in United States from 1999 to 2008.

## 2. Have total emissions from PM2.5 decreased in the **Baltimore City**, Maryland (<span style="color:red;">fips == "24510"</span>) from 1999 to 2008? Use the **base** plotting system to make a plot answering this question.

```
Yes, it has decreased
```
## 3. Of the four types of sources indicated by the <span style="color:red;">type</span> (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for **Baltimore City**? Which have seen increases in emissions from 1999–2008? Use the **ggplot2** plotting system to make a plot answer this question.

Here, we need to make a tidy data set i.e group them for each year per type of sources. <span style="color:red;">dplyr</span> is utilised to group them by year & type and then applying summarise function to emissions column.

```
baltimore.emissions <- tbl_df(baltimore.emissions)
baltimore.emissions <- baltimore.emissions %>% group_by(year, type) %>% summarise(Emissions = sum(Emissions))
```
Using <span style="color:red;">qplot</span>

```
print(qplot(year, Emissions, data=baltimore.emissions, color=type, geom ="line")  + ggtitle("Baltimore City Emmission by source, type and year") + xlab("Year") + ylab("Total Emissions (in tons)"))
```
From the plot, we can conclude that, 

* <span style="color:red;">NONPOINT, NON-ROAD, ON-ROAD</span> have seen decreases.
* <span style="color:red;">POINT</span> has seen increases.

## 4. Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

First we need to segregate all coal combustion related sources from the SCC data frame
```
coal.sector <- SCC[grep("Coal", SCC$EI.Sector),]
```
Next, using above data frame and NEI data frame, get the common data by SCC applying inner join.
Group and summarise the data by year.
```
nei.join <- inner_join(NEI,coal.sector, by = "SCC")
caal.data <- nei.join %>% group_by(year) %>% summarise(Emissions = sum(Emissions))
```
Finally plot the graph using barplot
```
barplot(caal.data$Emissions/100000, caal.data$year,
        names.arg = caal.data$year, 
        xlab = "Year", ylab = "Total Emissions - Unit (10 ^ 5) Tons", 
        col = rainbow(20),
        ylim = c(0,8),
        main = "Total PM2.5 Emission - Coal Combustion Related Sources", border = "blue", density = c(10,20,30,40))
```
**Conclusion**: Emissions from coal combustion-related sources have **decreased** from 1999-2008 time period.

## 5. How have emissions from motor vehicle sources changed from 1999–2008 in **Baltimore City**?

First, segregate the **Vehicle** data sources from SCC data frame
```
motor.sources <- SCC[grep("Vehicles",SCC$EI.Sector),]
```
Then get all the rows from NEI data frame for **Baltimore** city
```
nei.filter <- filter(NEI,fips =="24510")
```
At this stage we have relevant data for all **Vehicle** sources and **Baltimore** city. We should now get the common data on SCC by applying inner join followed by group and summarise action.
```
motor.join <- inner_join(nei.filter,motor.sources, by = "SCC")
motor.data <- motor.join %>% group_by(year) %>% summarise(Emissions = sum(Emissions))
```

Finally plot the graph. Also show emission values on the bars
```
bp <- barplot(motor.data$Emissions, motor.data$year,
        names.arg = motor.data$year, 
        xlab = "Year", ylab = "Total Emissions", 
        col = rainbow(20),
        ylim = c(0,500),
        main = "Total PM2.5 Emission - Motor Vehicle Sources - Unit (Tons)", border = "blue", density = c(10,20,30,40))
text(bp,motor.data$Emissions, labels = round(motor.data$Emissions,2), pos = 3, offset = 0.1)
```
**Conclusion**: Emissions from all vehicle sources have **decreased** from 1999-2008 time period.

## 6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in **Los Angeles County**, California (<span style="color:red;">fips == "06037"</span>). Which city has seen greater changes over time in motor vehicle emissions?

First, segregate the **Vehicle** data sources from SCC data frame
```
motor.sources <- SCC[grep("Vehicles",SCC$EI.Sector),]
```
Then get all the rows from NEI data frame for **Baltimore** and **Los Angeles** city
```
nei.filter <- filter(NEI, (fips == "24510" | fips == "06037"))
```
At this stage we have relevant data for all **Vehicle** sources for **Baltimore** and **Los Angeles** city. We should now get the common data on SCC by applying inner join followed by group and summarise action.
```
motor.join <- inner_join(nei.filter,motor.sources, by = "SCC")
motor.data <- motor.join %>% group_by(year,fips) %>% summarise(Emissions = sum(Emissions))
```
ggplot2 needs factor variables, so create factor variables for **fips** and **year** column
```
motor.data$fips <- factor(motor.data$fips, levels=c("06037", "24510"), c("Los Angeles County", "Baltimore City") )
motor.data$year <- factor(motor.data$year, levels=c("1999", "2002", "2005", "2008"))
```
Finally plot the graph using ggplot.
```
qp <- ggplot(data=motor.data, aes(x=year, y=Emissions)) + geom_bar(aes(fill=year), stat = "identity") + guides(fill=F) + 
    ggtitle('Baltimore v/s Los Angeles - Motor Vehicle Total Emissions') + 
    ylab(expression('PM'[2.5])) + xlab('Year') + theme(legend.position='none') + facet_grid(. ~ fips) + 
    geom_text(aes(label=round(Emissions,0), size=1, hjust=0.5, vjust=-1))
```
**Conclusion**: **Los Angeles City** has seen greater changes over tme in motot vehicle emissions.


