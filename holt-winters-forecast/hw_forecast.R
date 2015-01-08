hw_forecast <- function(df, m, h, al, be, ga) {
  
  y  <- as.vector(df$users)
  l  <- rep(NA,length(y))
  b  <- rep(NA,length(y))
  s  <- rep(NA,length(y))
  yh <- rep(NA,length(y))
  
  l[1] <- 1
  b[1] <- 1
  s[1] <- 1
  yh[1:2] <- y[1:2]
  
  # smoothing
  for(t in 2:length(y)) {
    yh[t] <- l[t-1] + b[t-1] + s[max(1,t-m)]
    l[t]  <- al * (y[t] - s[max(1,t-m)]) + (1 - al) * (l[t-1] + b[t-1])
    b[t]  <- be * (l[t] - l[t-1]) + (1 - be) * b[t-1]
    s[t]  <- ga * (y[t] - l[t-1] - b[t-1]) + (1 - ga) * s[max(1,t-m)]
  }
  
  # forecasting
  n <- length(y)
  for(t in 1:h) {
    yh[n+t] <- l[n] + t*b[n] + s[n-m+(t-1)%%m+1]
    b[n+t]  <- b[n]
    s[n+t]  <- s[n-m+(t-1)%%m+1]
    l[n+t]  <- l[n]
  }
  
  return(list(
    data = df,
    ts = data.frame(
      y = c(y,rep(NA, length(b)-length(y))),
      yh = yh[1:length(b)],
      trend = b,
      level = l,
      season = s
    ),
    frequency = m,
    horizon = h,
    hw = list(
      alpha = al,
      beta = be,
      gamma = ga
    )
  ))
}