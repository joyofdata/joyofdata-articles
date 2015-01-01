source("./extract_ts_for_country.R")
source("./load_sdmx_from_eurostat.R")
source("./monthplot_for_country.R")

d <- load_sdmx_from_eurostat()

#> table(d$data$geo)[table(d$data$geo) > 600]
#
#AT     BE     CH     DE DE_TOT     DK     EE     EL     ES     FI     FX     IE     IS     IT     LU     NL     NO     PT     SE 
#751    754    750    742    754    751    749    635    754    751    751    631    751    604    750    751    742    633    751 

monthplot_for_country(d$data, "PT", sw=36, tw=48, pstl=TRUE, yred=1990)

