library(jsonlite)
library(dplyr)
library(rio)
library(ggplot2)
library(gt);
library(gtExtras)
library(tidyr)
#install_formats()

if(!file.exists("cached_data.tsv") || as.Date(file.info('cached_data.tsv')$ctime) < Sys.Date() ) {

  dat0 <- fromJSON(txt = 'https://services.arcgis.com/g1fRTDLeMgspWrYp/arcgis/rest/services/SAMHD_DailySurveillance_Data_Public/FeatureServer/0/query?where=1%3D1&outFields=*&returnGeometry=false&outSR=4326&f=json')

  dat1 <- dat0[["features"]][["attributes"]] %>% subset(!is.na(total_case_cumulative)) %>%
    mutate(reporting_date = as.POSIXct(reporting_date/1000, origin = "1970-01-01"))
  # export(dat1, "cached_data.tsv")
  write.table(dat1, file='cached_data.tsv', quote=FALSE, na = "",sep='\t')
} else {dat1 <- import("cached_data.tsv")}


# Listening on http://127.0.0.1:5088 # your own computer route, copy IP address in browser, you will find the figure in browser.
cols <- c("change_in_7_day_moving_avg", "count_7_day_moving_avg")
Table1 <- gt(dat1) %>% cols_hide(c("globalid", "objectid")) %>% fmt_number(all_of(cols), decimals = 1) %>%
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
             deaths_daily_change = html("Death&nbsp;per&nbsp;Day"))
