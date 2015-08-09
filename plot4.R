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

plot4 <- function() {
  dt <- loadProjectData()
  
  png("plot4.png")
  
  par(mfrow = c(2, 2))
  with(dt, {
    # plot 1
    plot(strptime(Datetime, "%d/%m/%Y %H:%M:%S"), Global_active_power, type = "l", xlab = "", ylab = "Global Active Power")
    
    # plot 2
    plot(strptime(Datetime, "%d/%m/%Y %H:%M:%S"), Voltage, type = "l", xlab = "datetime", ylab = "Voltage")
    
    # plot 3
    plot(strptime(Datetime, "%d/%m/%Y %H:%M:%S"), Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
    lines(strptime(Datetime, "%d/%m/%Y %H:%M:%S"), Sub_metering_2, type = "l", col = "red" )
    lines(strptime(Datetime, "%d/%m/%Y %H:%M:%S"), Sub_metering_3, type = "l", col = "blue" )
    legend("topright", lty= 1, col = c("Black", "red", "blue"), legend = c( "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n")
    
    # plot 4
    plot(strptime(Datetime, "%d/%m/%Y %H:%M:%S"), Global_reactive_power, type = "l", xlab = "datetime")
  })
  mtext("")
  
  dev.off()
}






