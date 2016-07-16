d <- read.table("./figures/sm1.dat", h=T)
d <- aggregate(d, by=list(d$competition, d$K), mean)

library(RColorBrewer)

pdf("figures/carryingcapacity.pdf")

palette(brewer.pal(5, "PRGn"))

plot(0, pch=NA, xlim=range(d$K), ylim=c(0, 0.6),
      xlab = "Carrying capacity", ylab = "Diversity",
      las = 1, log='x', xaxs='i', yaxs='i')

i <- 1
for(comp in unique(d$competition)) {
  x <- subset(d, competition == comp)
  co <- i
  lt = 1
  if (comp == 1.0) co <- 'grey'
  if (comp == 1.0) lt <- 2
  lines(diversity~K, x, col = co, type='l', pch=19, lwd=3, lty = lt)
  i <- i + 1
}

legend("bottomright", fill=c(2, 'grey', 4),
      legend=c("Coexistence", "Neutral", "Exclusion"),
      bty='n')

box()

dev.off()
