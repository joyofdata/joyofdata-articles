library(lubridate)
library(forecast)

source("csv_to_df.R")
source("df_to_ts.R")
source("hw_forecast.R")
source("plot_hw_forecast.R")

df_users_all <- csv_to_df("users-all.csv")
df_users_google <- csv_to_df("users-google.csv")

df <- subset(df_users_google, date >= "2014-01-06" & date <= "2014-11-30")
obj <- hw_forecast(df, m=7, h=28, al=.1, be=.1, ga=.1)
plot_hw_forecast(obj)

mod <- ets(ts(df$users, frequency=7), model="AAA")
plot(forecast(mod, h=14))
