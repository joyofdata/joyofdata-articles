plot_hw_forecast <- function(obj) {
  d <- obj$data$date
  d <- c(d, d[length(d)]+(1:obj$horizon))
  
  par(mfrow=c(5,1), mar=c(2,3,1,1))
  plot(d, obj$ts$yh, type="l", col=rgb(1,0,0,.5), ylim=c(0,max(c(obj$ts$y,obj$ts$yh),na.rm=TRUE)))
  lines(d, obj$ts$y, type="l")
  plot(obj$ts$level, type="l", )
  plot(obj$ts$season, type="l")
  plot(obj$ts$trend, type="l")
  monthplot(ts(obj$ts$season, frequency=obj$frequency), labels=obj$data$wd[1:7])
  par(mfrow=c(1,1), mar=c(3,3,3,3))
}