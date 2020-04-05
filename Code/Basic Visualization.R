#Set Working Directory
setwd("~/Documents/Github/ShinyApp-COVID-19")

#raw Data
data <- read.csv("./Data/COVID_Data_Basic.csv")
data$Date <- as.Date(data$Date)

library(plotly)

plot_ly(data = data, x = ~Date) %>%
  group_by(Date)%>%
  summarise(CT = sum(Confirmed), DT = sum(Death), RT = sum(Recovered))%>%
  add_lines(y = ~CT, name = "Total Confirmed") %>%
  add_lines(y = ~DT, name = "Total Death") %>%
  add_lines(y = ~RT, name = "Total Recovered")%>%
  layout(title="Cases with Date", yaxis = list(title = "Cases", nticks = 10),
         legend = list(orientation = "h"))
