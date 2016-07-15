d <- read.table("./figures/sm2.dat", h=T)
d <- aggregate(d, by=list(vert=d$vertebrates, d$Z), mean)

d$vert <- as.vector(d$vert)

library(RColorBrewer)

pdf("figures/vertebrate.pdf")

palette(brewer.pal(3, "Set2"))

plot(0, pch=NA, xlim=range(d$Z), ylim=range(d$stability),
      xlab = "Carrying capacity", ylab = "Temporal stability",
      las = 1, log='x')

abline(v=1, col='grey')

i <- 1
for(v in unique(d$vert)) {
  x <- subset(d, vert == v)
  lines(stability~Z, x, col = i, type='o', pch=19, lwd=3)
  i <- i + 1
}

legend("bottomleft", fill=c(1:3),
      legend=c("Vertebrate consumers", "Invertebrate consumers"),
      bty='n')

dev.off()
