library(jsonlite);
library(rio);
library(reactlog);
library(dplyr);


options(shiny.reactlog=TRUE);

if(!file.exists('cached_data.tsv') ||
   as.Date(file.info('cached_data.tsv')$ctime) < Sys.Date()){
  message('Downloading data');
  dat0 <- jsonlite::fromJSON('https://services.arcgis.com/g1fRTDLeMgspWrYp/arcgis/rest/services/SAMHD_DailySurveillance_Data_Public/FeatureServer/0/query?where=1%3D1&outFields=*&returnGeometry=false&outSR=4326&f=json');
  dat1 <- dat0$features$attributes %>%
    mutate(reporting_date=as.Date(as.POSIXct(reporting_date/1000,origin='1970-01-01'))) %>%
    subset(!is.na(total_case_cumulative));
  export(dat1,'cached_data.tsv');
} else {
  dat1 <- import('cached_data.tsv');
}

defaultpalette <- c("#000000","#ad0a60","#005002","#220869","#346200"
                    , "#002a8a", "#475700", "#414db4", "#005b27", "#952e90"
                    , "#446526", "#4a1b7e", "#77570d", "#0049a6", "#784b00"
                    , "#613ba1", "#003b11", "#72369b", "#005c39", "#761f84"
                    , "#243400", "#8b3b96", "#59602e", "#0a0052", "#894e13"
                    , "#5052ad", "#831a00", "#004694", "#900310", "#005391"
                    , "#732300", "#00377c", "#90481b", "#00003e", "#613800"
                    , "#3e005c", "#005442", "#a60032", "#004d71", "#a43530"
                    , "#003869", "#9a412a", "#00002e", "#ab2b41", "#003650"
                    , "#8a0025", "#001a3f", "#8e4a29", "#5d0068", "#4a2b00"
                    , "#60519c", "#5e2000", "#555695", "#640011", "#495c85"
                    , "#a3363f", "#3b004a", "#3b2200", "#810067", "#39180f"
                    , "#a32979", "#3b0c00", "#734b94", "#3e0300", "#953784"
                    , "#4b000c", "#5e5685", "#90473e", "#290035", "#7e504c"
                    , "#580051", "#6a403d", "#7f0055", "#512929", "#834586"
                    , "#30000e", "#963a74", "#1f0026", "#9b3b51", "#504260"
                    , "#740034", "#6f4d66", "#640046", "#884b50", "#340020"
                    , "#993b63", "#4b2c43", "#5c002e", "#83496e", "#4f0033"
                    , "#8b465d");
