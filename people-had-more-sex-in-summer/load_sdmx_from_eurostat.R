load_sdmx_from_eurostat <- function(dataset = "demo_fmonth") {
  library(rsdmx)
  
  url <- sprintf("http://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?sort=1&file=data%%2F%s.sdmx.zip", dataset)
  sdmx <- sprintf("%s.sdmx.xml", dataset)
  dsd <- sprintf("%s.dsd.xml", dataset)
  
  # downloading and unzipping
  # http://stackoverflow.com/a/3053883/562440
  
  temp <- tempfile()
  download.file(url,temp)
  
  sdmx <- readSDMX(unzip(temp, files=sdmx), isURL=FALSE)
  dsd <- readSDMX(unzip(temp, files=dsd), isURL=FALSE)
  
  unlink(temp)
  
  d <- as.data.frame(sdmx)
  d <- as.data.frame(lapply(d, as.character), stringsAsFactors=FALSE)
  
  return(list(
    sdmx = sdmx,
    dsd = dsd,
    data = d
  ))
}