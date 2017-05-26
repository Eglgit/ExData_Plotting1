##----------------------------------------------------------------------------
##----------------------------------------------------------------------------
##
##  File name:  Plot3.R
##  Date:       26May2017
##
##
##----------------------------------------------------------------------------
##----------------------------------------------------------------------------

##----------------------------------------------------------------------------
## Download, unzip and read table
##----------------------------------------------------------------------------

## Create working folder
If (!files.exists("Plotting")) 
{ dir.create("Plotting") }

## Download and read files
zipfile <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(zipfile, "./Plotting/Household_power_consumption.zip")

## Unzip the file
unzip(zipfile = "./Plotting/Household_power_consumption.zip", exdir = "./Plotting")

## Read table for 2007-02-01 and 2007-02-02
library(data.table)
library(dplyr)
library(reshape2)

## read the file
##----------------------------------------------------------------------------
hpc <- read.table("./Plotting/Household_power_consumption.txt", header = TRUE, sep = ";"
                  ,na.strings = "?",  colClasses = c('character','character','numeric',
                                                    'numeric','numeric','numeric'
                                                    ,'numeric','numeric','numeric')) 

hpc_data <- tbl_df(hpc)
hpc_data_set <- filter(hpc_data, Date == "2/2/2007" | Date == "1/2/2007")

    # reformat the date column and merge into one
##----------------------------------------------------------------------------
hpc_data_set <- mutate(hpc_data_set, Date_Time = paste(Date, Time, sep = " "))
hpc_data_set$Date_Time <- strptime(hpc_data_set$Date_Time, "%d/%m/%Y %H:%M:%S")


    # reformat column class
##----------------------------------------------------------------------------
hpc_data_set[, 3:9] <- lapply(hpc_data_set[, 3:9], as.numeric)
hpc_data_set <- hpc_data_set[, c(10, 3:9)]


##----------------------------------------------------------------------------
## Plot, 3
##----------------------------------------------------------------------------
plot(hpc_data_set$Date_Time, hpc_data_set$Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = "")
points(hpc_data_set$Date_Time, dataFil$Sub_metering_2, type = "l", col = "red")
points(hpc_data_set$Date_Time, hpc_data_set$Sub_metering_3, type = "l", col = "blue")
legend("topright", lty = c(1,1,1), lwd = c(2,2,2), col = c("black", "red", "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

    ## Save to file and close device
dev.copy(png, file="plot3.png", height=480, width=480)
dev.off()

