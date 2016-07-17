d <- read.table("./figures/sm2.dat", h=T)
d <- subset(d, stability > -10)
d <- aggregate(d, by=list(vert=d$vertebrates, d$Z), mean)

d$vert <- as.vector(d$vert)

library(RColorBrewer)

pdf("figures/vertebrate.pdf", height=5)

palette(brewer.pal(3, "Set2"))

plot(0, pch=NA, xlim=range(d$Z), ylim=c(0, -7),
      xlab = "Allometric scaling (log)", ylab = "Temporal stability",
      las = 1, log='x', xaxs='i', yaxs='i')

rect(0.01, 0.0, 1, -7, col=rgb(0.97, 0.97, 0.97), border=NA)
abline(v=1, col='darkgrey', lty=3)

i <- 1
for(v in unique(d$vert)) {
  x <- subset(d, vert == v)
  lines(stability~Z, x, col = i, type='l', pch=NA, lwd=1, lty = lt)
  lines(stability~Z, x, col = i, type='p', pch=21+i, lwd=2, bg='white')
  i <- i + 1
}

legend("topright",
      legend=c("Invertebrates", "Ectotherm vertebrates"),
      col = c(1, 2),
      pch = 21 + c(1:2),
      pt.lwd = 2,
      bty='n')

box()

dev.off()
