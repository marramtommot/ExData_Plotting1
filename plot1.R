library(dplyr)
library(data.table)

loadProjectData <- function() {
  setwd("~/Desktop/Coursera/Data Science/4. Exploratory Data Analysis")
  
  zipFile <- "./data/household_power_consumption.zip"
  fn <-  "./data/household_power_consumption.txt"
  csv <- "./data/household_power_consumption.csv"
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  
  dt <- NULL
  
  # donwload the file, if necessary
  if(!file.exists(csv)) {
    if(!file.exists(fn)) {
      download.file(url, destfile = zipFile, method = "curl")

      # unzip and delete the original source
      unzip(zipFile, overwrite = T, exdir = "./data")
      unlink(zipFile)
    }
    
    # read data and filter
    fh <- fread(fn, na.strings="?", stringsAsFactors = FALSE)
    dt <- suppressWarnings(filter(fh, grep("^[1,2]/2/2007", Date)))
    
    # create a filtered csv for later use
    write.csv(dt, file = "./data/household_power_consumption.csv", row.names = FALSE)
    
    # delete the full dataset file
    unlink(fn)
  }
  else {
    # read the already existing filtered csv
    fh <- fread(csv, stringsAsFactors = FALSE)
    dt <- data.table(fh)
  }
  
  # numeric conversion of columns
  dt$Global_active_power <- as.numeric(as.character(dt$Global_active_power))
  dt$Global_reactive_power <- as.numeric(as.character(dt$Global_reactive_power))
  dt$Sub_metering_1 <- as.numeric(as.character(dt$Sub_metering_1))
  dt$Sub_metering_2 <- as.numeric(as.character(dt$Sub_metering_2))
  dt$Sub_metering_3 <- as.numeric(as.character(dt$Sub_metering_3))
  dt$Voltage <- as.numeric(as.character(dt$Voltage))
  
  # create a datetime column, used in x-axis 
  dt$Datetime <- paste(dt$Date, dt$Time)
  
  dt
}

plot1 <- function() {
  dt <- loadProjectData()

  png("plot1.png")
  hist(dt$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
  dev.off()
}
