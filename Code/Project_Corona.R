#Auto Download files from github source
download.file(url="https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv",
	destfile="/home/ashish/Documents/Data_Science/Code/Data/RawData/time_series_19-covid-Confirmed.csv")

download.file(url="https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv",
	destfile="/home/ashish/Documents/Data_Science/Code/Data/RawData/time_series_19-covid-Deaths.csv")

download.file(url="https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv",
	destfile="/home/ashish/Documents/Data_Science/Code/Data/RawData/time_series_19-covid-Recovered.csv")

##################################################

#Steps :
#1. Data Gathering ( Data Sources : https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_time_series/ ).
#2. Data Cleansing & PreProcessing ( manual, will try though python)
#3. Visualization

####################################################

#library('googleVis')
#suppressPackageStartupMessages(library(googleVis))
library(reshape)

#Read CSV
confirmed_rawData <- read.csv("/home/ashish/Documents/Data_Science/Code/Data/RawData/time_series_19-covid-Confirmed.csv")
death_rawData <- read.csv("/home/ashish/Documents/Data_Science/Code/Data/RawData/time_series_19-covid-Deaths.csv")
Recovered_rawData <- read.csv("/home/ashish/Documents/Data_Science/Code/Data/RawData/time_series_19-covid-Recovered.csv")

#Data Cleaning
confirmed_data <- subset(confirmed_rawData, select = -c(Province.State,Lat,Long))
death_data <- subset(death_rawData, select = -c(Province.State,Lat,Long))
Recovered_data <- subset(Recovered_rawData, select = -c(Province.State,Lat,Long))

#Unipivot Data
Final_Confirmed <- melt(confirmed_data)
names(Final_Confirmed) <- c("Country","Date","Confirmed")

Final_Death <- melt(death_data)
names(Final_Death) <- c("Country","Date","Deaths")

Final_Recovered <- melt(Recovered_data)
names(Final_Recovered) <- c("Country","Date","Recovered")

#Date Formating
Final_Confirmed$Date <- gsub("X","",Final_Confirmed$Date)
Final_Confirmed$Date = as.Date(Final_Confirmed$Date, format="%m.%d.%y")

Final_Death$Date <- gsub("X","",Final_Death$Date)
Final_Death$Date = as.Date(Final_Death$Date, format="%m.%d.%y")

Final_Recovered$Date <- gsub("X","",Final_Recovered$Date)
Final_Recovered$Date = as.Date(Final_Recovered$Date, format="%m.%d.%y")

#Remove duplicates.
Ag_Final_Confirmed = aggregate(Final_Confirmed$Confirmed, by=list(Final_Confirmed$Country, Final_Confirmed$Date), FUN=sum)
names(Ag_Final_Confirmed) <- c("Country","Date","Confirmed")

Ag_Final_Death = aggregate(Final_Death$Deaths, by=list(Final_Death$Country, Final_Death$Date), FUN=sum)
names(Ag_Final_Death) <- c("Country","Date","Death")

Ag_Final_Recovered = aggregate(Final_Recovered$Recovered, by=list(Final_Recovered$Country, Final_Recovered$Date), FUN=sum)
names(Ag_Final_Recovered) <- c("Country","Date","Recovered")

#Ploting DataFrame (Join all DataFrame)
Confirmed_Death <- merge(Ag_Final_Confirmed,Ag_Final_Death, by=c('Country','Date'))
Confirmed_Recovered <- merge(Ag_Final_Confirmed,Ag_Final_Recovered, by=c('Country','Date'))
Recovered_Death <- merge(Ag_Final_Recovered,Ag_Final_Death, by=c('Country','Date'))
Confirmed_Death_Recovered <- merge(Confirmed_Death,Ag_Final_Recovered, by=c('Country','Date'))

#Confirmed_Death_Recovered <- Confirmed_Death

#CreateNew Dataset of Date : 20th March, 2020 Onwards.
COVID_Data_Latest <- Confirmed_Death_Recovered[Confirmed_Death_Recovered$Date > "2020-03-19",]

#Load Fixed Data till 19th March, 2020
COVID_Data_Fixed <- read.csv("/home/ashish/Documents/Data_Science/Code/Data/RawData/COVID_Data_Basic_Modified_20200320.csv")
COVID_Data_Fixed$Date <- as.Date(COVID_Data_Fixed$Date, format="%d/%m/%Y") #Date format
COVID_Data_Fixed <- subset(COVID_Data_Fixed, select=-c(X,newConfirmed, newDeath, newRecovered))


#bind 2 dataframe
COVID_Data <- rbind(COVID_Data_Fixed,COVID_Data_Latest)

#Calculate new data by country and date
COVID_Data$newConfirmed <- with(COVID_Data, ave(Confirmed,Country,FUN=function(x) c(0,diff(x))))
COVID_Data$newDeath <- with(COVID_Data, ave(Death, Country,FUN=function(x) c(0,diff(x))))
COVID_Data$newRecovered <- with(COVID_Data, ave(Recovered, Country,FUN=function(x) c(0,diff(x))))

#Save Processed basic data
write.csv(COVID_Data,"./Data/Kaggle/COVID_Data_Basic.csv")
write.csv(subset(COVID_Data, select = -c(Recovered,newRecovered)), "./Data/Kaggle/COVID_Data.csv")

#Days since each occurance country wise
COVID_Data$dayflag <- with(COVID_Data, ave(Confirmed,Country, FUN=function(x) x>0))
COVID_Data$day <- ave(COVID_Data$dayflag, COVID_Data$Country, FUN=cumsum)
COVID_Data$occuranceDays <- paste0("day",COVID_Data$day)

#Plotting Dataset
plotCDR <- COVID_Data[COVID_Data$dayflag==1,]
plotCDR <- subset(plotCDR, select=-c(day,dayflag))

#Delete any NA value in plotCDR
plotCDR <- na.omit(plotCDR)

#Save dataframe
write.csv(Confirmed_Death_Recovered, "./Data/Confirmed_Death_Recovered.csv")
write.csv(COVID_Data_Latest, "./Data/COVID_Data_Latest.csv")
write.csv(plotCDR, "./Data/plotCDR.csv")
write.csv(COVID_Data, "./Data/COVID_Data.csv")

#plot visualization
#Motion <- gvisMotionChart(plotCDR, idvar=c("Country"), timevar = "Date")
#plot(Motion)

#cat(Motion$html$chart, file="graph.html")

#UPLOAD THE FILES TO GDrive through APIs.
library(googledrive)

#Get dribble / get id of files
x<-as_dribble("~/My Projects/Project_Corona/Data/AutoUpdate/COVID_Data")
y<-as_dribble("~/My Projects/Project_Corona/Data/AutoUpdate/plotCDR")

#update files on google
x %>% drive_update(media = "/home/ashish/Documents/Data_Science/Code/Data/COVID_Data.csv")
y %>% drive_update(media = "/home/ashish/Documents/Data_Science/Code/Data/plotCDR.csv")

#Upload the files directly to Kaggle Datasets
system("kaggle datasets version -m 'AutoUpdate' -p /home/ashish/Documents/Data_Science/Code/Data/Kaggle -r skip")
