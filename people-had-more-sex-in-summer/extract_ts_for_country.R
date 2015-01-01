extract_ts_for_country <- function(d, country) {
  ts <- d[d$geo==country & grepl("M\\d\\d",d$month),]
  ts <- ts[order(ts$TIME_PERIOD, ts$month),]
  ts[,c("TIME_PERIOD","OBS_VALUE")] <- lapply(ts[,c("TIME_PERIOD","OBS_VALUE")], as.numeric)
  
  y1 <- min(ts$TIME_PERIOD)
  y2 <- max(ts$TIME_PERIOD)
  
  if(ts$month[1] != "M01") {
    y1 <- y1+1
  }
  if(ts$month[nrow(ts)] != "M12") {
    y2 <- y2-1
  }
  ts <- ts[ts$TIME_PERIOD >= y1 & ts$TIME_PERIOD <= y2,]
  TS <<- ts
  
  if(! sum(ts$month == rep(sprintf("M%02d",1:12),(y2-y1+1))) == (y2-y1+1)*12) {
    stop("there seem to be months missing :/")
  }
  
  ts <- ts(ts$OBS_VALUE, start=c(y1,1), end=c(y2,12), frequency=12)

  return(ts)
}