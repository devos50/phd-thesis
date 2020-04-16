library(ggplot2)
library(dplyr)

#cols <- c("NOCHECK" = "#db0017", "CHECK" = "#136ac6", "CHECK+LIMTRADE" = "#40a33a")
linetypes <- c("XChange" = "solid", "BitShares" = "longdash", "Waves" = "dashed")
dotstyles <- c("XChange" = 15, "BitShares" = 16, "Waves" = 17)

dat <- read.csv("comparison.csv")
dat$system_load <- dat$instances * 2
dat$latency[dat$system == "Waves"] <- dat$latency[dat$system == "Waves"] / 1000.0
dat$latency[dat$system == "BitShares"] <- dat$latency[dat$system == "BitShares"] / 1000.0

# Average the results
dat <- dat %>%
group_by(system,system_load) %>%
summarise(
throughput = mean(throughput),
latency = mean(latency))

p <- ggplot(dat, aes(x=system_load, y=throughput, group=system, colour=system)) +
     geom_line(aes(linetype=system)) +
     geom_point(aes(shape=system)) +
     theme_bw() +
     theme(legend.position="bottom", legend.key = element_rect(colour = '#aaaaaa', size = 0.4), legend.title = element_text(size=12, face="bold")) +
     ylab("Peak throughput (operations/sec.)") +
     xlab("System load (new orders/sec.)") +
     scale_linetype_manual(values = linetypes) +
     scale_shape_manual(values = dotstyles) +
     scale_x_continuous(breaks=seq(0, 1000, by = 100)) +
     scale_y_continuous(breaks=seq(0, 7500, by = 1000))
ggsave("scalability_comparison.pdf", p, width=6, height=4)

p <- ggplot(dat, aes(x=system_load, y=latency, group=system, colour=system)) +
     geom_line(aes(linetype=system)) +
     geom_point(aes(shape=system)) +
     theme_bw() +
     theme(legend.position="bottom", legend.key = element_rect(colour = '#aaaaaa', size = 0.4), legend.title = element_text(size=12, face="bold")) +
     ylab("Average order fulfil latency (sec.)") +
     xlab("System load (new orders/sec.)") +
     scale_linetype_manual(values = linetypes) +
     scale_shape_manual(values = dotstyles) +
     scale_x_continuous(breaks=seq(0, 1000, by = 100))
ggsave("latency_comparison.pdf", p, width=6, height=4)
