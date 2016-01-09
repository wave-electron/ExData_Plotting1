# plot4.R - Assignment 1 of Exploratory Data Analyis Course
# Author - Ashley Joyce
# Dataset has come from the UCI Machine Learning Repository
#http://archive.ics.uci.edu/ml/
# set working directory (based on your working directory)
working.dir <- getwd()
setwd(working.dir)

# read required libraries
library(data.table)

# make sure the local data folder exists
if (!file.exists('local data')) {
  dir.create('local data')
}

# check to see if the existing data set exists; if not, create it...
if (!file.exists('local data/power_consumption.txt')) {
  
  # download the zip file and unzip into local data
  file.url<-'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
  download.file(file.url,destfile='local data/power_consumption.zip')
  unzip('local data/power_consumption.zip',exdir='local data',overwrite=TRUE)
  
  # When using fread - Dates are read as character currently. They can be converted afterwards using as.Date()
  dt <- fread('local data/household_power_consumption.txt', sep = ";", header=TRUE,data.table=TRUE,na.strings=c("NA","?", ""), verbose=FALSE)
  
  # Convert the Date column to "date" class & subset between 01/02/2007 & 02/02/2007
  dt.2007 <- subset(dt, as.Date(dt$Date,"%d/%m/%Y") %in% as.Date("2007/02/01"):as.Date("2007/02/02"))
  
  # Paste Date to Time Cols and flip around so its in the correct format for the strptime()
  
  DateTime <- paste(as.Date(dt.2007$Date, format="%d/%m/%Y"),dt.2007$Time, sep=" ")
  DateTime <- strptime(DateTime, format="%Y-%m-%d %H:%M:%S")
  
  #  Bind DateTime Column to dataframe dt.2007
  dt.2007 <- cbind(dt.2007,DateTime=c(as.POSIXct(DateTime)))
  
  # write a clean data set to the directory
  
  write.table(dt.2007,file='local data/power_consumption.txt',sep=',',row.names=FALSE)
  
} else {
  
  dt.2007 <- read.table('local data/power_consumption.txt',header=TRUE,sep=',')
  dt.2007$DateTime<-as.POSIXlt(dt.2007$DateTime)
  
}

# delete the source data set 
if (file.exists('local data/household_power_consumption.txt')) {
  x<-file.remove('local data/household_power_consumption.txt')
}


## Plot 4 - Multi Plot Example

# open device
dev.copy(png, file = "plot4.png", width = 480, height = 480, units='px') # Copy my plot to a PNG file 

par(mfrow = c(2,2), mar = c(5,4,2,1))

# subPlot 1

with(dt.2007, plot(dt.2007$DateTime,dt.2007$Global_active_power,col = "black", type = "l", ylab = "Global Active Power", xlab = ""))


# subPlot 2

with(dt.2007, plot(dt.2007$DateTime,dt.2007$Voltage,col = "black", type = "l", ylab = "Voltage", xlab = "datetime"))



# subPlot 3
with(dt.2007, plot(time_frame,dt.2007$Sub_metering_1,col = "black", type = "l", ylab = "Energy sub metering", xlab = ""))
lines(dt.2007$DateTime,dt.2007$Sub_metering_2, col = "red")
lines(dt.2007$DateTime,dt.2007$Sub_metering_3, col = "blue")
legend("topright", lty = "solid", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))


# subPlot 4

with(dt.2007, plot(dt.2007$DateTime,dt.2007$Global_reactive_power,col = "black", type = "l", ylab = "Global_reactive_power", xlab = "datetime"))

#close the PDF file device # Close the PNG device
dev.off()  






