args(shiny::shinyServer)


x <- faithful[,2]
bins <- seq(min(x), max(x), length.out = 3+1)
# draw the histogramwith the specified number of bins
hist(x, breaks= bins, col = 'darkgray', border= 'white')



<body><p>Hello</p></body>

  <div> # close it

  <div>Hello</div> # treat as a box



  <html><body><div>This is my content</div></body></html>


  <span> This is a span</span>



# 2022-01-20-----------------------------------------------------------------------------------------------------------------------------
## prepare data
library(jsonlite)
library(dplyr)
library(rio)
library(ggplot2)

if(!file.exists("cached_data.tsv")) {

dat0 <- fromJSON(txt = 'https://services.arcgis.com/g1fRTDLeMgspWrYp/arcgis/rest/services/SAMHD_DailySurveillance_Data_Public/FeatureServer/0/query?where=1%3D1&outFields=*&returnGeometry=false&outSR=4326&f=json')

dat1 <- dat0[["features"]][["attributes"]] %>% subset(!is.na(total_case_cumulative)) %>%
  mutate(reporting_date = as.POSIXct(reporting_date/1000, origin = "1970-01-01"))
export(dat1, "cached_data.tsv")
} else {dat1 <- import("cached_data.tsv")}

head(dat1$reporting_date/1000) %>% as.POSIXct(origin = "1970-01-01")


ggplot(dat1, aes(y = deaths_cumulative, x= reporting_date)) + geom_line()

ggplot(dat1, aes(y = total_case_daily_change, x= reporting_date)) + geom_line()

ggplot(dat1, aes(y = deaths_cumulative, x= reporting_date)) + geom_line(linetype="dotted", color = "blue", size=1) +
  geom_line(aes(y = total_case_daily_change, color = total_case_daily_change)) +
  ylab("counts ")

## shiny--------------------------------------------------------------------------------------------------------
fluidPage(titlePanel("Hello"), sidebarLayout(sidebarPanel(), mainPanel()))

## 2022-01-27 Class record ----------------------------------------------------------------------------------------
# Step 1
# in terminal,type: git clone git@github.com:dnarna909/SP22TSCI6202.git
# Step 2
# create a new project by choosing existing directory,
# copy server.R, ui.R, global.R, and in class record-20220113.R to new

# ggplot loop for plotting two figures
ggplot(dat1, aes_string(y = input$`Y value`, x= "reporting_date") ) +
  geom_line(linetype="dotted", color = input$colour_line, size=1) +
  geom_line(aes(y = total_case_daily_change, color = total_case_daily_change)) +
  ylab("counts ")

# one variable
input <- list(colour_line = c("red"))
geom.list <- list(p1 = geom_line(aes_string( y = "strac_covid_positive_in_hospita"),
                                 linetype="dotted", color = input$colour_line, size=1))

ggplot(dat1, aes_string( x= "reporting_date") ) +
  geom.list +
  ylab("counts ")

# multiple variables
input <- list(colour_line = c("red"),
              `Y value` = c("strac_covid_positive_in_hospita", "total_case_daily_change",
                            "total_case_cumulative"))
geom.list <- lapply(input$`Y value`, function(xx) geom_line(aes_string( y = xx),
                                               linetype="dotted", color = input$colour_line, size=1))

ggplot(dat1, aes_string( x= "reporting_date") ) +
  geom.list +
  ylab("counts ")

# multiple variables by different color
input <- list(colour_line = c("red", "blue", "green"),
              `Y value` = c("strac_covid_positive_in_hospita", "total_case_daily_change",
                            "total_case_cumulative"))
geom.list <- lapply(input$`Y value`, function(xx) geom_line(aes_string( y = xx),
                                                            linetype="dotted", color = input$colour_line, size=1))

ggplot(dat1, aes_string( x= "reporting_date") ) +
  geom.list +
  ylab("counts ")

# multiple variables by different color
input <- list(`Y value` = colnames(dat1)[3:7])
names <- lapply(input$`Y value`, function(xx) { colourInput(paste0(xx, "_color"), "Specifiy color" ) } )

geom.list <- lapply(input$`Y value`, function(xx) geom_line(aes_string( y = xx),
                                                            linetype="dotted", color = input[[paste0(xx, "_colour"),"Specifiy color"]], size=1))
ggplot(dat1, aes_string( x= "reporting_date") ) +
  geom.list +
  ylab("counts ")

# 2022-02-10 class record ----------------------------------------------------------------
install.packages("plotly")

hcl.pals(type='qualitative')
hcl.colors(5,palette='Dark 3')


input <- list(`Y Value`=c('Var1','Var2','Var3'))
lapply(seq_along(input$`Y value`), function(xx) { colourInput(paste0(input$`Y value`[xx], "_color"),
                                                              "Specifiy color",
                                                              hcl.colors(20,palette='Dark 3') [xx] ) } )

# 2022-03-10
runApp('TSCI6202_Example/',display.mode = 'showcase')


# rCharts
library(rCharts)

demo("datatables") # show demos
# import dat1
str(dat1)
dat1 <- dat1 %>% mutate(reporting_date_new = format(reporting_date))


dt <- dTable(
     dat1 %>% select(-c("V1", "reporting_date", "globalid")) %>% relocate("reporting_date_new"),
     sPaginationType= "full_numbers"
   )
dt

dt <- dTable(
     dat1,
     bScrollInfinite = T,
     bScrollCollapse = T,
     sScrollY = "200px",
     width = "500px"
   )
dt

dt <- dTable(
  dat1,
     sScrollY = "200px",
     bScrollCollapse = T,
     bPaginate = F,
     bJQueryUI = T,
     aoColumnDefs = list(
         sWidth = "5%", aTargets =  list(-1)
       )
   )
dt

demo("dimple")

# 2022-03-24 ------------------------------------
# install gt, gtExtras packages
# note: ctrl + shift + c : add # to all lines,
# create nice table by gt packages

gt(dat1) %>% cols_hide(c("globalid", "objectid")) # hide the columns, "" not affect

cols <- c("change_in_7_day_moving_avg", "count_7_day_moving_avg")
gt_preview(dat1) %>% cols_hide(c("globalid", "objectid")) %>% fmt_number(all_of(cols), decimals = 1) # change decimals

gt_preview(dat1) %>% cols_hide(c("globalid", "objectid")) %>% fmt_number(all_of(cols), decimals = 1) %>%
  fmt_missing(columns = everything(), missing_text = "")# show/change missing values display, NA,

gt_preview(dat1) %>% cols_hide(c("globalid", "objectid")) %>% fmt_number(all_of(cols), decimals = 1) %>%
  fmt_missing(columns = everything(), missing_text = "") %>%
  data_color(columns = c(total_case_daily_change), colors = scales::col_numeric(palette = c('green','red'), domain = NULL))# formatting colors

gt_preview(dat1) %>% cols_hide(c("globalid", "objectid")) %>% fmt_number(all_of(cols), decimals = 1) %>%
  fmt_missing(columns = everything(), missing_text = "") %>%
  data_color(columns = c(total_case_daily_change), colors = scales::col_numeric(palette = c('green','red'), domain = NULL)) %>%
  tab_style(
    style = list(
      cell_fill(color = "lightcyan"),
      cell_text(weight = "bold")),
    locations = cells_body(
      columns = vars(change_in_7_day_moving_avg),
      rows = change_in_7_day_moving_avg >0 )
    ) # formatting colors based on condition

gt_preview(dat1) %>% cols_hide(c("globalid", "objectid")) %>% fmt_number(all_of(cols), decimals = 1) %>%
  fmt_missing(columns = everything(), missing_text = "") %>%
  data_color(columns = c(total_case_daily_change), colors = scales::col_numeric(palette = c('green','red'), domain = NULL)) %>%
  tab_style(
    style = list(
      cell_fill(color = "lightcyan"),
      cell_text(weight = "bold")),
    locations = cells_body(
      columns = c(change_in_7_day_moving_avg),
      rows = change_in_7_day_moving_avg >0 )
  ) %>%
  cols_label(change_in_7_day_moving_avg="change_in_7_day_moving_avg1",
             total_case_daily_change="total_case_daily_change2",
             deaths_daily_change = html("Death&nbsp;per&nbsp;Day")) # change column names, for blanket: &nbsp;
gt_sparkline()

library(tidyr)
pivot_longer(dat1, any_of(names(dat1)[-(1:3) ])) %>% arrange(reporting_date) %>%
  group_by(name) %>%
  summarize(across(.fns = ~list(.x))) %>%
  View() # summarize data based on columns


# 03/31/2022 ---------------------------------------------------------------------------------------------------
gt_sparkline()

dat2_pvt <- dat1 %>%
  # select(1:7) %>%
  arrange(reporting_date) %>%
  pivot_longer(any_of(colnames(dat1)[-(1:3)])) %>%
  group_by(name) %>%
  summarize(across(.fns = ~list(na.omit(.x)))) %>%
  gt() %>%
  cols_hide(c("globalid", "objectid", "reporting_date")) %>%
  gt_sparkline(value)
dat2_pvt

dat1 %>%
  # select(1:7) %>%
  arrange(reporting_date) %>%
  pivot_longer(any_of(colnames(dat1)[-(1:3)])) %>%
  group_by(name) %>%
  summarize(across(.fns = ~list(na.omit(.x)))) %>%
  gt() %>%
  cols_hide(c("globalid", "objectid", "reporting_date")) %>%
  gt_sparkline(value, same_limit = FALSE) # A logical indicating that the plots will use the same axis range (TRUE) or have individual axis ranges (FALSE).

dat1 %>%
  # select(1:7) %>%
  arrange(reporting_date) %>%
  pivot_longer(any_of(colnames(dat1)[-(1:3)])) %>%
  group_by(name) %>%
  summarize(across(.fns = ~list(na.omit(.x)))) %>%
  mutate(Hist = value, Dense = value) %>%
  rename(sparkline = value) %>%
  gt() %>%
  cols_hide(c("globalid", "objectid", "reporting_date")) %>%
  gt_sparkline(sparkline, same_limit = FALSE) %>%
  gt_sparkline(Hist, same_limit = FALSE, type = "histogram") %>%
  gt_sparkline(Dense, same_limit = FALSE, type = "density")

# cols_move function
dat1 %>%
  # select(1:7) %>%
  arrange(reporting_date) %>%
  pivot_longer(any_of(colnames(dat1)[-(1:3)])) %>%
  group_by(name) %>%
  summarize(Median = median(value, na.rm = TRUE),
            SD = sd(value, na.rm = TRUE),
            across(.fns = ~list(na.omit(.x)))
  ) %>%
  mutate(Hist = value, Dense = value) %>%
  rename(sparkline = value) %>%
  gt() %>%
  cols_hide(c("globalid", "objectid", "reporting_date")) %>%
  gt_sparkline(sparkline, same_limit = FALSE) %>%
  gt_sparkline(Hist, same_limit = FALSE, type = "histogram") %>%
  gt_sparkline(Dense, same_limit = FALSE, type = "density") %>%
  cols_move("sparkline", after = "Median") %>%
  # cols_move_to_start("sparkline")


  # cols_label function
  dat1 %>%
  arrange(reporting_date) %>%
  pivot_longer(any_of(colnames(dat1)[-(1:3)])) %>%
  group_by(name) %>%
  summarize(Median = median(value, na.rm = TRUE),
            SD = sd(value, na.rm = TRUE),
            across(.fns = ~list(na.omit(.x)))  ) %>%
  mutate(Hist = value, Dense = value) %>%
  rename(sparkline = value) %>%
  gt() %>%
  cols_hide(c("globalid", "objectid", "reporting_date")) %>%
  cols_move("sparkline", after = "Median") %>%
  cols_label(sparkline = md("**Sparkline**"),
             Hist = html("<span,style='color:red'>Histogram</span>") )  %>%
  gt_sparkline(sparkline, same_limit = FALSE) %>%
  gt_sparkline(Hist, same_limit = FALSE, type = "histogram") %>%
  gt_sparkline(Dense, same_limit = FALSE, type = "density")


# cols_label(.list = list(Median = "MEDIAN") )










