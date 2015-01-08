df_to_ts <- function(df) {
  ts_df <- ts(df$users, frequency=7, start=c(df$sn[1],df$wdn[1]), end=c(df$sn[nrow(df)],df$wdn[nrow(df)]))
  return(ts_df)
}