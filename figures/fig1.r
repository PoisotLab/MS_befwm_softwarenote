d <- read.table("./figures/sm1.dat", h=T)
d <- aggregate(d, by=list(d$competition, d$K), mean)

library(RColorBrewer)

pdf("figures/carryingcapacity.pdf", height=5)

palette(brewer.pal(3, "PRGn"))

plot(0, pch=NA, xlim=range(d$K), ylim=c(0, 0.6),
      xlab = "Carrying capacity", ylab = "Diversity",
      las = 1, log='x', xaxs='i', yaxs='i')

i <- 1
for(comp in unique(d$competition)) {
  x <- subset(d, competition == comp)
  co <- i
  lt <- 1
  if (comp == 1.0) co <- 'grey'
  if (comp == 1.0) lt <- 2
  lines(diversity~K, x, col = co, type='l', pch=NA, lwd=1, lty = lt)
  lines(diversity~K, x, col = co, type='p', pch=21+i, lwd=2, bg='white')
  i <- i + 1
}

legend("bottomright",
      legend=c("Coexistence", "Neutral stability", "Exclusion"),
      col = c(1, 'grey', 3),
      pch = 21 + c(1:3),
      pt.lwd = 2,
      bty='n')

box()

dev.off()
