d <- read.table("./figures/sm1.dat", h=T)
d <- aggregate(d, by=list(d$competition, d$K), mean)

library(RColorBrewer)

pdf("figures/carryingcapacity.pdf")

palette(brewer.pal(3, "Dark2"))

plot(0, pch=NA, xlim=range(d$K), ylim=c(0, 0.6),
      xlab = "Carrying capacity", ylab = "Diversity",
      las = 1, log='x', xaxs='i', yaxs='i')

i <- 1
for(comp in unique(d$competition)) {
  x <- subset(d, competition == comp)
  lines(diversity~K, x, col = i, type='l', pch=19, lwd=3)
  i <- i + 1
}

legend("bottomright", fill=c(1:3),
      legend=c("Coexistence", "Neutral", "Exclusion"),
      bty='n')

dev.off()
