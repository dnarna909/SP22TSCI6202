#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(colourpicker);
library(shinyBS);
library(plotly);


# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("COVID Dashboard"),

  # Sidebar with a slider input for number of bins
  tabsetPanel(

    # COVID_19_Panel, renderUI, Plotly -----------------------------------------------------------------------------------------
    tabPanel( "COVID_19_Panel",
              sidebarLayout(
                sidebarPanel(
                  sliderInput("bins", "Number of bins:",
                              min = 1, max = 50, value = 30), # could be delete
                  colourInput('colour_line', "Specifiy color",
                              value='red'), # could be delete
                  selectInput("Y value", "Specifiy Variable",
                              names(dat1)[-(1:3)], multiple = TRUE,
                              selectize = TRUE
                              #, selected = colnames[5]
                  ), # ID,CAPTION, CHOICES
                  uiOutput("ycol")
                ),

                # Show a plot of the generated distribution
                mainPanel(fluidRow( column(10,
                                           # plotOutput("distPlot")
                                           plotlyOutput("distPlot")))
                )
              )
    ),

    # TestPanel, gt_plot ---------------------------------------------------------------------------------------------
    tabPanel(title = "TestPanel", gt_output("gTable_test")),

    # TestPanel3, gt_plot ------------------------------------------------------------------------------------------------
    tabPanel(title = "TestPanel3",
             sidebarLayout(
               sidebarPanel(
                 selectInput("gt_var", "Select Variables", dat2_pvt$name,
                             multiple = TRUE, selectize = TRUE,
                             selected = dat2_pvt$name),
                 selectInput("gt_col", "Select Statistics",
                             setdiff(colnames(dat2_pvt), hide_spark),
                             multiple = TRUE, selectize = TRUE,
                             selected = setdiff(colnames(dat2_pvt), hide_spark))),

               mainPanel(fluidRow(column(10,
                                         gt_output("distPlot_test"))))
             )
    ),

    # scPLOT, Plotly ---------------------------------------------------------------------------------------
    tabPanel(title = "sc_data",
             plotlyOutput("scPLOT"),

             sidebarLayout(
               sidebarPanel(
                 selectInput("meta.data", "features Variable",
                             colnames(sc_data@meta.data),
                             selectize = TRUE),
                 selectInput("meta.data2", "split Variable",
                             colnames(sc_data@meta.data),
                             selectize = TRUE)),
               mainPanel(plotlyOutput("scPLOT2"))
             ),

             sidebarLayout(
               sidebarPanel(
                 selectInput("features", "Dot plot for Multiple features Variable",
                             rownames(sc_data),
                             multiple = TRUE,
                             selectize = TRUE)),
               mainPanel(plotlyOutput("scPLOT3"))
             ),

             sidebarLayout(
               sidebarPanel(
                 selectInput("Gene_name", "Specifiy Variable",
                             rownames(sc_data),
                             selectize = TRUE)),
               mainPanel(plotlyOutput("scPLOT_interactive"))
             )
    )


  )
)
)





