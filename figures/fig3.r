d <- read.table("./figures/sm3.dat", h=T)
d <- aggregate(d, by=list(d$competition, d$connectance), mean)


library(RColorBrewer)

pdf("figures/connectance.pdf", height=5)

palette(brewer.pal(6, "Oranges")[-1])

plot(0, pch=NA, xlim=c(0.8, 1.2), ylim=c(0,0.8),
      xlab = "Competition", ylab = "Persistence",
      las = 1, log='x', xaxs='i', yaxs='i')

rect(0.8, 0, 1.0, 0.8, col=rgb(0.97, 0.97, 0.97), border=NA)
abline(v=1, col='darkgrey', lty=3)


i <- 1
for(co in unique(d$connectance)) {
  x <- subset(d, connectance ==  co)
  cex = 1.0
  if (i == 1) cex <- 2
  lines(richness~competition, x, col = i, type='l', pch=NA, lwd=1, lty = lt)
  lines(richness~competition, x, col = i, type='p', pch=20+i, lwd=2, bg='white', cex=cex)
  i <- i + 1
}

box()

legend("topright",
      legend=c(unique(d$connectance)),
      col = c(1:5),
      pch = 20 + c(1:5),
      pt.cex = c(2.0, rep(1, 4)),
      pt.lwd = 2,
      bty='n')

dev.off()
