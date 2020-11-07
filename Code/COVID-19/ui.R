# Define UI for application that draws a histogram
shinyUI(
  dashboardPage(
    dashboardHeader(title = "COVID Analysis"),
    dashboardSidebar(
      sidebarMenu(id = "sideMenu",
        menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
        menuItem("Charts", icon = icon("bar-chart-o"),
                 menuSubItem("Basic Charts", tabName = "basiccharts"),
                 menuSubItem("GoogleVis Charts", tabName = "googlevis"),
                 menuSubItem("Ggplot Charts", tabName = "ggplot"),
                 menuSubItem("Plotly Charts", tabName = "Plotly")),
        menuItem("About", tabName = "about", icon = icon("info-circle"))),
      sidebarMenu(id = "filter",
        selectInput("Country","Select Country", c("All",levels(PlotCOVID$Country))),
        sliderInput("DateRange","Select Date Range", min = minDate, max = maxDate
            ,value = c(minDate,maxDate))
        )
    ),
    dashboardBody(
      tabItems(
        tabItem("dashboard",
                fluidRow(column(3,h3('Total Confirmed'),h3(TotalOverall['Confirmed'])),
                         column(3,h3('Total Death'),h3(TotalOverall['Death'])),
                         column(3,h3('Total Recovered'),h3(TotalOverall['Recovered'])),
                         column(3,h3('Total Active'),h3(TotalOverall['Confirmed'] - TotalOverall['Death'] - TotalOverall['Recovered']))
                         )),
        tabItem("basiccharts",
                splitLayout(
                  plotOutput("totalConfirmedCases"),
                  plotOutput("totalDeathCases")), 
                plotOutput("NewConfirmedDeath")
                ),
        tabItem("googlevis", htmlOutput("googleVisMotion")),
        tabItem("ggplot", plotOutput("LineRecovered")),
        tabItem("Plotly", plotlyOutput("BubbleMotion")),
        tabItem("about", "This section describe about the project and author information!!")
      )
   ))
)
