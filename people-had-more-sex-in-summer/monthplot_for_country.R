monthplot_for_country <- function(data, country, sw=12, tw=36, pstl=FALSE, yred) {
  ts <- extract_ts_for_country(data, country)
  
  stl <- stl(ts, s.window=sw, t.window=tw)
  
  start <- start(ts)
  end <- end(ts)

  title <- sprintf("Live Births for %s from %d-%d until %d-%d",country,start[1],start[2],end[1],end[2])

  if(pstl) {
    plot(stl, main=title)
    l <- readline()
  }
  
  monthplot(stl$time.series[,"seasonal"], main=title, ylab="")
  lim <- par("usr")
  col <- list(
    winter = rgb( 20/255, 129/255, 255/255, 0.1),
    spring = rgb( 67/255, 255/255,  20/255, 0.1),
    summer = rgb(255/255, 168/255,  20/255, 0.1),
    autumn = rgb(107/255,  62/255,   0/255, 0.1)
  )
  
  rect(0.55, lim[3]-1, 2.45, lim[4]+1, border = col$winter, col = col$winter)
  rect(11.55, lim[3]-1, 12.45, lim[4]+1, border = col$winter, col = col$winter)
  rect(2.55, lim[3]-1, 5.45, lim[4]+1, border = col$spring, col = col$spring)
  rect(5.55, lim[3]-1, 8.45, lim[4]+1, border = col$summer, col = col$summer)
  rect(8.55, lim[3]-1, 11.45, lim[4]+1, border = col$autumn, col = col$autumn)
  
  if(!is.null(yred)) {
    abline(v=(1:12)-0.45+0.9*(yred-start[1])/(end[1]-start[1]), col=rgb(1,0,0,0.4))
    str <- sprintf("lines mark year %d",yred)
    mtext(str, side=3, adj=1, line=1, col="red", cex=.8)
  }
  
  mtext("(joyofdata.de)", side=3, adj=0, line=1, col="black", cex=.8)
  mtext("F.x. a birth in September indicates (ML) associated month of intercourse being December.", side=1, adj=0.5, line=2, col=rgb(.4,.4,.4), cex=.8)
}