# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  
  #Filter function to filter Dataframe
  CreateDF <- reactive({

    PlotCOVID <- subset(PlotCOVID1, Date>=as.character(input$DateRange[1]) & Date<=as.character(input$DateRange[2]))
    if(input$Country=="All"){
      PlotCOVID <- PlotCOVID
    }else{
      PlotCOVID <- PlotCOVID[PlotCOVID$Country==input$Country,]
    }
  })
  
  # #Update SliderDate
  # observe({
  #   LineData <- CreateDF()
  #   newMinDate <- min(LineData$Date)
  #   updateSliderInput(session, "DateRange", min = newMinDate, value = c(newMinDate, maxDate))
  # })
  
  #TextOutput
  output$TotalConfirmed <- renderText({
    TotalOverall['Confirmed']
  })
  
  output$TotalDeath <- renderText({
    TotalOverall['Death']
  })
  
  output$TotalRecovered <- renderText({
    TotalOverall['Recovered']
  })
  
  #Output Confirmed Cases
  output$totalConfirmedCases <- renderPlot({
    LineData <- CreateDF()
    LineData <- preprocess(LineData)
    plot(LineData$Date,LineData$Confirmed,type = "l", 
         main = "Total Confirmed Cases Over Time", xlab = "Dates", ylab = "Confirmed Cases",
         col="blue")
    legend("topleft","Confirmed",fill = "blue")
  })
  
  #Output Death Cases
  output$totalDeathCases <- renderPlot({
    LineData <- CreateDF()
    LineData <- preprocess(LineData)
    plot(LineData$Date,LineData$Death,type = "l",
         main = "Total Death Cases Over Time", xlab = "Dates", ylab = "Death Cases",
         col="red")
    legend("topleft","Death",fill = "red")
  })
  
  # 
  # #Recovery Rate vs Death Rate ( Rate : out of Total Closed Cases)
  # output$RateRecoveredDeath <- renderPlot({
  #   LineData <- CreateDF()
  #   LineData <- preprocess(LineData)
  #   LineData$ClosedCases <- LineData$Death+LineData$Recovered
  #   plot(LineData$Date,(LineData$Recovered*100)/LineData$ClosedCases,type = "l",
  #        main = "Recovery Rate vs Death Rate", sub = "Rate calculated out of Total Closed Cases",xlab = "Dates", ylab = "Rates",
  #        col="green")
  #   lines(LineData$Date,(LineData$Death*100)/LineData$ClosedCases,type = "l", col="red")
  #   legend("topleft",c("Recovery Rate","Death Rate"),fill = c("green","red"))
  # })
  
  #NewConfirmed Vs NewDeath
  output$NewConfirmedDeath <- renderPlot({
    LineData <- CreateDF()
    LineData <- preprocess(LineData)
    plot(LineData$Date, LineData$newConfirmed, type = "l",
         main = "New Confirmed vs New Death",xlab = "Dates", ylab = "Cases",
         col="blue")
    lines(LineData$Date, LineData$newDeath, type = "l", col = "red")
    legend("topleft",c("New Confirmed","New Death"),fill = c("green","red"))
  })
  
  #Motion Visualization through googleVis
  output$googleVisMotion <- renderGvis({
    
    gvisMotionChart(subset(PlotCOVID,select = -c(X)), idvar = "Country", timevar = "Date")
  })
  
  #Motion chart with ggplot2
  output$LineRecovered <- renderPlot({
    LineData <- CreateDF()
    LineData <- preprocess(LineData)
    ggplot(LineData, aes(Date, Recovered))+
      geom_point()+
      geom_line()+
      labs(x = 'Date', y='Recovered Cases')+
      scale_x_date(date_breaks = "1 week",date_labels = "%d-%m-%y")+
      scale_y_continuous(n.breaks = 10)
  })
  
  #plotly Bubble motion chart
  output$BubbleMotion <- renderPlotly({
    LineData <- CreateDF()
    LineData <- preprocess(LineData)
    
    g <- ggplot(LineData, aes(Death, Recovered))+
      geom_point(colour = 'red')+
      labs(x = 'Death Cases', y='Recovered Cases')+
      scale_x_continuous(n.breaks = 10)+
      scale_y_continuous(n.breaks = 10)
    ggplotly(g)
  })
})
