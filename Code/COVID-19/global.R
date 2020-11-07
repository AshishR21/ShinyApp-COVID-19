library(shiny)
library(shinydashboard)
library(ggplot2)
library(gganimate)
library(gifski)
library(plotly)
suppressPackageStartupMessages(library(googleVis))

PlotCOVID <- read.csv("/home/ashish/Documents/Data_Science/Code/Data/plotCDR.csv")
PlotCOVID$Date <- as.Date(PlotCOVID$Date, format = "%Y-%m-%d")

#Date Range
minDate <- min(PlotCOVID$Date)
maxDate <- max(PlotCOVID$Date)

#To Take Backup
PlotCOVID1 <- PlotCOVID

#Summary/ TotalCountoverall
TotalOverall <- colSums(Filter(is.numeric, PlotCOVID[PlotCOVID$Date == maxDate,]))

#PreProcess data
preprocess <- function(data){
  PlotCOVID <- data
  LineData_Death <- aggregate(PlotCOVID$Death, by = list(PlotCOVID$Date), FUN = sum)
  names(LineData_Death) <- c("Date","Death")
  
  LineData_Confirmed <- aggregate(PlotCOVID$Confirmed, by = list(PlotCOVID$Date), FUN = sum)
  names(LineData_Confirmed) <- c("Date","Confirmed")
  
  LineData_Recovered <- aggregate(PlotCOVID$Recovered, by = list(PlotCOVID$Date), FUN = sum)
  names(LineData_Recovered) <- c("Date","Recovered")
  
  LineData_Confirmed_new <- aggregate(PlotCOVID$newConfirmed, by = list(PlotCOVID$Date), FUN = sum)
  names(LineData_Confirmed_new) <- c("Date","newConfirmed")
  
  LineData_Death_new <- aggregate(PlotCOVID$newDeath, by = list(PlotCOVID$Date), FUN = sum)
  names(LineData_Death_new) <- c("Date","newDeath")
  
  LineData_Recovered_new <- aggregate(PlotCOVID$newRecovered, by = list(PlotCOVID$Date), FUN = sum)
  names(LineData_Recovered_new) <- c("Date","newRecovered")
  
  LineData <- merge(LineData_Confirmed, LineData_Death, by = c("Date"))
  LineData <- merge(LineData, LineData_Recovered, by = c("Date"))
  LineData <- merge(LineData, LineData_Confirmed_new, by = c("Date"))
  LineData <- merge(LineData, LineData_Death_new, by = c("Date"))
  LineData <- merge(LineData, LineData_Recovered_new, by = c("Date"))
  
  return(LineData)
}