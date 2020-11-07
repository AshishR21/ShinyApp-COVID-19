#Design Header
dashheader <- dashboardHeader(title = "COVID - 19")

#Design SideBar
dashsidebar <- dashboardSidebar( width = "200", collapsed = TRUE,
    sidebarMenu(id = "sideMenu",
                menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
                menuItem("Charts",tabName = "charts", icon = icon("bar-chart-o")),
                menuItem("About", tabName = "about", icon = icon("info-circle"))),
    sidebarMenu(id = "inputMenu", position = "bottom",
                menuItem("Country", tabName = "country"))
)

#Dashboard Menu Items(tab Name)
dashboard <- fluidPage(fluidRow(
    column(3, h3("Total Confirmed"), h3(totalOverall['Confirmed'])),
    column(3, h3("Total Recovered"), h3(totalOverall['Recovered'])),
    column(3, h3("Total Death"), h3(totalOverall['Death'])),
    column(3, h3("Active Cases"), h3(totalOverall['Confirmed']-totalOverall['Recovered']-totalOverall['Death'])),
))

#Design Body
dashbody <- dashboardBody(
    tabItems(
        tabItem("dashboard",dashboard),
        tabItem("charts","This is charts"),
        tabItem("about", "This is about Page!!!!")
    )
)

#Combine UI Elements
shinyUI(
    dashboardPage(
        dashheader,
        dashsidebar,
        dashbody
    )
)