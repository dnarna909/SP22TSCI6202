#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny);
library(colourpicker);
library(shinyBS);
daterange <- as.Date(range(dat1$reporting_date));

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("COVD-19 in Bexar County"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            actionButton('btnMenu',"☰"),
            conditionalPanel("input.btnMenu%2==0",
                             selectInput('yvals','Plot lines:',choices=names(dat1)[-(1:3)]
                                         ,selected=names(dat1)[4]
                                         ,multiple=T,selectize = T),
                             uiOutput('ycol'),
                             sliderInput("datefilter","Date range:",
                                         min = min(daterange),
                                         max = max(daterange),
                                         step = 1,
                                         value=daterange,
                                         timeFormat='%Y-%m-%d'),
                             dateInput("vline","Date marker:"
                                       ,min = min(daterange)
                                       ,max = max(daterange)
                                       ,value=median(daterange)
                                       ,width='150px'
                             )
            ),
                             # sliderInput("vline","Date marker:"
                             #             ,min = min(daterange)
                             #             ,max = max(daterange)
                             #             ,step = 0.1
                             #             ,value=median(daterange)
                             #             ,timeFormat = '%Y-%m-%d')
                             # ),
            width=2),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot")
        )
    )
))
