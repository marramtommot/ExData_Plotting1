library(dplyr)
library(data.table)

loadProjectData <- function() {
  setwd("~/Desktop/Coursera/Data Science/4. Exploratory Data Analysis")
  
  fn <-  "./data/household_power_consumption.txt"
  csv <- "./data/household_power_consumption.csv"
  
  downloadedDate <- NULL
  dt <- NULL
  
  if(!file.exists(csv)) {
    if(!file.exists(fn)) {
      url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
      zipFile <- "./data/power_data.zip"
      download.file(url, destfile = zipFile, method = "curl")
      downloadedDate <- date()
      unzip(zipFile, overwrite = T, exdir = "./data")
      unlink(zipFile)
    }
    
    fh <- fread(fn, na.strings="?", stringsAsFactors = FALSE)
    dt <- suppressWarnings(filter(fh, grep("^[1,2]/2/2007", Date)))
    
    write.csv(dt, file = "./data/household_power_consumption.csv", row.names = FALSE)
    
    unlink(fn)
  }
  else {
    fh <- fread(csv, stringsAsFactors = FALSE)
    dt <- data.table(fh)
  }
  
  dt$Global_active_power <- as.numeric(as.character(dt$Global_active_power))
  dt$Global_reactive_power <- as.numeric(as.character(dt$Global_reactive_power))
  dt$Sub_metering_1 <- as.numeric(as.character(dt$Sub_metering_1))
  dt$Sub_metering_2 <- as.numeric(as.character(dt$Sub_metering_2))
  dt$Sub_metering_3 <- as.numeric(as.character(dt$Sub_metering_3))
  dt$Voltage <- as.numeric(as.character(dt$Voltage))
  
  dt$Datetime <- paste(dt$Date, dt$Time)
  
  dt
}

plot2 <- function() {
  dt <- loadProjectData()

  png("plot2.png")
  plot(strptime(dt$Datetime, "%d/%m/%Y %H:%M:%S"), dt$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")
  dev.off()
}







