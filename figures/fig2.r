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

abline(v=1, col='grey', lty=2)

i <- 1
for(v in unique(d$vert)) {
  x <- subset(d, vert == v)
  lines(stability~Z, x, col = i, type='l', pch=19, lwd=3)
  i <- i + 1
}

legend("bottomright", fill=c(1:3),
      legend=c("Invertebrates", "Ectotherm vertebrates"),
      bty='n')

box()

dev.off()
