#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    print("Start shinyServer")
    # output$ycol <- renderUI({colourInput('colour_line_1', "Specifiy color") }) # one color
    # output$ycol <- renderUI({ lapply(input$`Y value`, function(vv) colourInput(paste0(vv, "_colour"),"Specifiy color")) }      ) # add more colors
    output$ycol <- renderUI({ lapply(seq_along(input$`Y value`),
                                     function(xx) { colourInput(paste0(input$`Y value`[xx], "_color"),
                                                                "Specifiy color",
                                                                hcl.colors(20,palette='Dark 3') [xx] ) } )
    })
    output$dTable_test <- renderChart({
      print("starting render Chart")
      dt <- dTable(
        dat1 #%>% select(-c("V1", "reporting_date", "globalid")) %>% mutate(reporting_date = format(reporting_date))
        ,
        sPaginationType= "full_numbers"
      )
      dt
      d1 <- dPlot( x = "reporting_date",
                   y = "total_case_cumulative",
                   data = dat1,
                   type = "line",
                   height = 400,
                   width = 700,
                   bounds = list(x=50,y=20,width=650,height=300)
      )
    })
    output$distPlot <- renderPlotly({
      print("starting render plot")

        # generate bins based on input$bins from ui.R
       # x    <- faithful[, 2]
        #bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        # browser()
        # geom.list <- lapply(input$`Y value`, function(xx) geom_line(aes_string( y = xx), linetype="dotted", color = input$colour_line_1,
                                                                    # color = input$colour_line,
        #                                                             size=1)) # one color
        # geom.list <- lapply(input$`Y value`, function(xx) { colourInput(paste0(xx, "_color"), "Specifiy color" ) } )
        geom.list <- lapply(input$`Y value`, function(xx) geom_line(aes_string( y = xx),
                                                                    # linetype="dotted",
                                                                    # color = input$colour_line_1,
                                                                  color = input[[paste0(xx, "_color")]],
                                                                   size=1)) # more colors
        plt <- ggplot(dat1, aes_string( x= "reporting_date") ) +
          geom.list +
          ylab("counts ")
        plt
        ggplotly(plt) %>% layout(dragmode = "select")

    })

})


