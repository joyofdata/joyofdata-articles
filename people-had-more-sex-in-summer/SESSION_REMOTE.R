library(rsdmx)
library(forecast)
library(devtools)

base_url <- cat(
  "https://raw.githubusercontent.com/joyofdata/",
  "joyofdata-articles/master/people-had-more-sex-in-summer"
)

source_url(sprintf("%s/extract_ts_for_country.R", base_url))
source_url(sprintf("%s/load_sdmx_from_eurostat.R", base_url))
source_url(sprintf("%s/monthplot_for_country.R", base_url))

d <- load_sdmx_from_eurostat(dataset = "demo_fmonth")

#> table(d$data$geo)[table(d$data$geo) > 600]

monthplot_for_country(d$data, "DE", sw=36, tw=48, pstl=TRUE, yred=1990)
