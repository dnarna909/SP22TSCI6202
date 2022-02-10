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


