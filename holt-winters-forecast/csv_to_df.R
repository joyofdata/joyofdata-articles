csv_to_df <- function(csv) {
  df <- read.table(csv, sep=",", header=TRUE, stringsAsFactors = FALSE)
  
  df$date <- as.Date(df$date, format="%m/%d/%y")
  df$users <- as.numeric(df$users)
  df$wd <- substr(lubridate::wday(df$date, label=TRUE),1,3)
  df$week <- lubridate::week(df$date)
  df$wdn <- lubridate::wday(df$date)
  df$wdn <- with(df, ifelse(wdn-1 == 0, 7, wdn-1))
  df$sn <- c(rep(0,7-df$wdn[1]+1),rep(1:nrow(df),rep(7,nrow(df))))[1:nrow(df)]
  
  return(df)
}