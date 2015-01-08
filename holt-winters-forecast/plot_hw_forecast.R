plot_hw_forecast <- function(obj) {
  d <- obj$data$date
  d <- c(d, d[length(d)]+(1:obj$horizon))
  
  par(mfrow=c(5,1), mar=c(2,3,1,1))
  plot(d, obj$ts$yh, type="l", col=rgb(1,0,0,.5), ylim=c(0,max(c(obj$ts$y,obj$ts$yh),na.rm=TRUE)))
  lines(d, obj$ts$y, type="l")
  mtext("Time Series", side=3, adj=0.2, line=-2, col="blue", cex=1)
  
  pf <- function(v, d, h, str) {
    n <- length(v)-h
    plot(d, v, type="l")
    abline(v=d[n+1], col=rgb(0,0,1,0.5), lty=2)
    mtext(str, side=3, adj=0.2, line=-2, col="blue", cex=.8)
  }
  pf(obj$ts$level, d, obj$horizon, str="LEVEL")
  pf(obj$ts$season, d, obj$horizon, str="SEASON")
  pf(obj$ts$trend, d, obj$horizon, str="TREND")
  
  monthplot(ts(obj$ts$season, frequency=obj$frequency), labels=obj$data$wd[1:7])
  par(mfrow=c(1,1), mar=c(3,3,3,3))
}