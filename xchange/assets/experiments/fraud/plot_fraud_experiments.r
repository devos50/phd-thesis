library(ggplot2)

options(scipen=999)

# Money gained by adversaries
dat <- read.csv("gained_per_user.csv")
dat$strategy <- as.factor(dat$strategy)

dat <- dat[dat$stolen > 0.01,]

p <- ggplot(dat, aes(x=peer_id, y=stolen, group=strategy, colour=strategy)) +
     geom_point(aes(shape=strategy)) +
     theme_bw() +
     scale_y_log10(breaks=c(0.01, 0.1, 1, 10, 100, 1000, 10000, 100000, 1000000)) +
     theme(legend.position="bottom", legend.title = element_text(size=12, face="bold"), legend.key = element_rect(colour = '#aaaaaa', size = 0.4)) +
     ylab("Value gained by fraud ($)") +
     xlab("Peer ID") +
    annotate("text", x=300, y = 200, label = "$ 100", size = 3.5) +
    geom_hline(yintercept=100, size=0.5, alpha=0.6, linetype="dashed")

ggsave("gained_per_user.pdf", p, width=6.2, height=4)

print(nrow(dat[dat$strategy == "RESTRICT+INC_SET",]))
datf <- dat[dat$stolen > 100,]
datf <- datf[datf$strategy == "RESTRICT+INC_SET",]
print(datf)


# Money lost by users
dat <- read.csv("losses_per_user.csv")
dat$strategy <- as.factor(dat$strategy)

dat <- dat[dat$lost > 0.01,]

p <- ggplot(dat, aes(x=peer_id, y=lost, group=strategy, colour=strategy)) +
     geom_point(aes(shape=strategy)) +
     theme_bw() +
     scale_y_log10(breaks=c(0.01, 0.1, 1, 10, 100, 1000, 10000, 100000, 1000000)) +
     theme(legend.position="bottom", legend.title = element_text(size=12, face="bold"), legend.key = element_rect(colour = '#aaaaaa', size = 0.4)) +
     ylab("Value lost to adversaries ($)") +
     xlab("Peer ID") +
    annotate("text", x=600, y = 200, label = "$ 100", size = 3.5) +
    geom_hline(yintercept=100, size=0.5, alpha=0.6, linetype="dashed")

ggsave("losses_per_user.pdf", p, width=6.2, height=4)
