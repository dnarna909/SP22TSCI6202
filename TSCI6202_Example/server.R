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
  # gt_plot ----
  output$gTable_test <- render_gt({
    print("starting render plot:gTable_test")
    truncated_cols <- c("change_in_7_day_moving_avg", "count_7_day_moving_avg")
    gt_preview(dat1) %>%
      cols_hide(hide) %>%
      fmt_number(all_of(truncated_cols), decimals = 1) %>%
      fmt_missing(columns = everything(), missing_text = "Eureka") %>%
      data_color(columns = c("total_case_daily_change"),
                 colors = scales::col_numeric(palette = c("green", "red"),
                                              domain = NULL)) %>%
      tab_style(style = list(
        cell_fill(color = "yellow"),
        cell_text(weight = "bold")),
        locations = cells_body(columns = c(change_in_7_day_moving_avg),
                               rows = change_in_7_day_moving_avg >0)) %>%
      cols_label(deaths_under_investigation = html("Death&nbsp;per&nbsp;Day"))

    })

  # distPlot ----
  # output$dTable_test <- renderChart({
  #   print("starting render Chart")
  #   dt <- dTable(
  #     dat1 #%>% select(-c("V1", "reporting_date", "globalid")) %>% mutate(reporting_date = format(reporting_date))
  #     ,
  #     sPaginationType= "full_numbers"
  #   )
  #   dt
  #   d1 <- dPlot( x = "reporting_date",
  #                y = "total_case_cumulative",
  #                data = dat1,
  #                type = "line",
  #                height = 400,
  #                width = 700,
  #                bounds = list(x=50,y=20,width=650,height=300)
  #   )
  # })

  output$distPlot <- renderPlotly({
    print("starting render plot: distPlot")

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

  # distplot test ----
  # quick copy for tab 3 to test, doesn't plot yet
  output$distPlot_test <- render_gt({
    print("starting render plot: distPlot_test")
    # browser()
    out <- subset(dat2_pvt, name %in% input$gt_var)[, input$gt_col]  %>%
      gt() %>%
      #cols_hide(hide_dat2) %>%
      {xx <-. ;
      # browser();
      # cols_move("sparkline", after = "Median")
      if(all( c("Median") %in% input$gt_col )){ cols_move(xx, "sparkline", after = "Median")} else { xx }
      } %>%
      {xx <-. ;
      if(all( c("sparkline") %in% input$gt_col )){ cols_label(xx,
                                                              sparkline = md("**Sparkline**"),
                                                              Hist = html("<span,style='color:red'>Histogram</span>") )} else { xx }
      }  %>%
      cols_label(sparkline = md("**Sparkline**"),  Hist = html("<span,style='color:red'>Histogram</span>") )  %>%
      gt_sparkline(sparkline, same_limit = FALSE) %>%
      gt_sparkline(Hist, same_limit = FALSE, type = "histogram") %>%
      gt_sparkline(Dense, same_limit = FALSE, type = "density")
    out
  })



})


