#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny);
library(ggplot2);

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

    output$ycol <- renderUI({
        req(input$yvals);
        mapply(colourInput,paste0('color_',input$yvals),input$yvals
               ,defaultpalette[seq_along(input$yvals)]
               ,MoreArgs = list(allowTransparent=T),SIMPLIFY = F)
    })

    output$distPlot <- renderPlot({
        req(input$yvals);
        plotlines <- lapply(input$yvals,function(yy){
            geom_line(aes_string(y=yy),col=input[[paste0('color_',yy)]])});
        subset(dat1,between(reporting_date
                            ,input$datefilter[1],input$datefilter[2])) %>%
            ggplot(aes(x=reporting_date,y=total_case_daily_change,group=1)) +
            plotlines +
            geom_vline(xintercept = input$vline,col='blue',alpha=0.5,size=2);
    });

})
