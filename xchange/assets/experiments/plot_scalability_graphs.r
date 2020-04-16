library(ggplot2)
library(dplyr)

#cols <- c("NOCHECK" = "#db0017", "CHECK" = "#136ac6", "CHECK+LIMTRADE" = "#40a33a")
linetypes <- c("none" = "solid", "RESTRICT(1)" = "longdash", "INC_SET(2)" = "dashed", "RESTRICT(1)+INC_SET(2)" = "twodash")
dotstyles <- c("none" = 15, "RESTRICT(1)" = 16, "INC_SET(2)" = 17, "RESTRICT(1)+INC_SET(2)" = 18)
order <- c("none","RESTRICT(1)","INC_SET(2)", "RESTRICT(1)+INC_SET(2)")

dat <- read.csv("scalability.csv")
#dat$avg_bw <- dat$bw / dat$network_size / 1024.0
#dat$avg_trades <- dat$trades / 30.0
dat$system_load <- dat$instances * 2

# Average the results
dat <- dat %>%
group_by(system_load,policy) %>%
summarise(
throughput = mean(throughput),
latency = mean(latency))

p <- ggplot(dat, aes(x=system_load, y=throughput, group=policy, colour=policy)) +
     geom_line(aes(linetype=policy)) + geom_point(aes(shape=policy)) +
     theme_bw() +
     theme(legend.position="bottom", legend.key = element_rect(colour = '#aaaaaa', size = 0.4), legend.title = element_text(size=12, face="bold")) +
     ylab("Average throughput (trades/sec.)") +
     xlab("System load (new orders/sec.)") +
     scale_linetype_manual(values = linetypes, breaks=order) +
     scale_shape_manual(values = dotstyles, breaks=order) +
     scale_x_continuous(breaks=seq(0, 2000, by = 200)) +
     scale_color_discrete(breaks=order)
ggsave("scalability.pdf", p, width=6, height=4)

p <- ggplot(dat, aes(x=system_load, y=latency, group=policy, colour=policy)) +
     geom_line(aes(linetype=policy)) +
     geom_point(aes(shape=policy)) +
     theme_bw() +
     theme(legend.position="bottom", legend.key = element_rect(colour = '#aaaaaa', size = 0.4), legend.title = element_text(size=12, face="bold")) +
     ylab("Average order fulfil latency (sec.)") +
     xlab("System load (new orders/sec.)") +
     scale_linetype_manual(values = linetypes, breaks=order) +
     scale_shape_manual(values = dotstyles, breaks=order) +
     scale_x_continuous(breaks=seq(0, 2000, by = 200)) +
     scale_color_discrete(breaks=order)
ggsave("latency.pdf", p, width=6, height=4)
