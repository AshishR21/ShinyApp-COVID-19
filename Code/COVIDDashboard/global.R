#set working directory
setwd("~/Documents/Github/ShinyApp-COVID-19/Code/COVIDDashboard")

#load library
library(shiny)
library(shinydashboard)

#read COVID Data
COVIDData <- read.csv("/home/ashish/Documents/Data_Science/Code/Data/Kaggle/COVID_Data_Basic.csv")
COVIDData$Date <- as.Date(COVIDData$Date)

dateRange <- c(min(COVIDData$Date),max(COVIDData$Date))

#TotalOverall
totalOverall <- colSums(Filter(is.numeric, COVIDData[COVIDData$Date == dateRange[2],]))