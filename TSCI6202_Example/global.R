library(jsonlite)
library(dplyr)
library(rio)
library(ggplot2)
#install_formats()

if(!file.exists("cached_data.tsv") || as.Date(file.info('cached_data.tsv')$ctime) < Sys.Date() ) {

  dat0 <- fromJSON(txt = 'https://services.arcgis.com/g1fRTDLeMgspWrYp/arcgis/rest/services/SAMHD_DailySurveillance_Data_Public/FeatureServer/0/query?where=1%3D1&outFields=*&returnGeometry=false&outSR=4326&f=json')

  dat1 <- dat0[["features"]][["attributes"]] %>% subset(!is.na(total_case_cumulative)) %>%
    mutate(reporting_date = as.POSIXct(reporting_date/1000, origin = "1970-01-01"))
  # export(dat1, "cached_data.tsv")
  write.table(dat1, file='cached_data.tsv', quote=FALSE, na = "",sep='\t')
} else {dat1 <- import("cached_data.tsv")}


# Listening on http://127.0.0.1:5088 # your own computer route, copy IP address in browser, you will find the figure in browser.
