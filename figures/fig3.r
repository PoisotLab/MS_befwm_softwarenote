d <- read.table("./figures/sm3.dat", h=T)
d <- aggregate(d, by=list(d$competition, d$connectance), mean)


library(RColorBrewer)

pdf("figures/connectance.pdf")

palette(brewer.pal(3, "Set2"))

plot(0, pch=NA, xlim=range(d$competition), ylim=range(d$richness),
      xlab = "Competition", ylab = "Persistence",
      las = 1, log='x')

abline(v=1, col='grey')

i <- 1
for(co in unique(d$connectance)) {
  x <- subset(d, connectance ==  co)
  lines(richness~competition, x, col = i, type='o', pch=19, lwd=3)
  i <- i + 1
}

legend("bottomleft", fill=c(1:3),
      legend=c(unique(d$connectance)),
      bty='n')

dev.off()
