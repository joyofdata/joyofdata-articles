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
  
  for(t in 2:(length(y)+h)) {
    yh_t <- ifelse(t > length(y), yh[t], y[t])
    l[t] <- al * (yh_t - s[max(1,t-m)]) + (1 - al) * (l[t-1] + b[t-1])
    b[t] <- be * (l[t] - l[t-1]) + (1 - be) * b[t-1]
    s[t] <- ga * (yh_t - l[t-1] - b[t-1]) + (1 - ga) * s[max(1,t-m)]
    yh[t+1] <- l[t] + b[t] + s[max(1,t-m+1)]
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