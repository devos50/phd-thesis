# library
library(ggplot2)
library(ggthemes)
library(scales)

# load in dataset
data <- read.csv(file="./experiment.csv", header=TRUE, sep=",", check.names=FALSE)
levels(data$block_type)[levels(data$block_type)=="dappcoder_project"] <- "Create project"
levels(data$block_type)[levels(data$block_type)=="dappcoder_review"] <- "Review submission"
levels(data$block_type)[levels(data$block_type)=="dappcoder_submission"] <- "Create submission"
levels(data$block_type)[levels(data$block_type)=="devid_connection"] <- "Import records"
levels(data$block_type)[levels(data$block_type)=="devid_endorsment"] <- "Endorse skill"
levels(data$block_type)[levels(data$block_type)=="devid_skill"] <- "Add skill"
data$block_type <- factor(data$block_type, levels(data$block_type)[c(4,6,5,1,2,3)])

data$index <- data$index-1

# create barplot
plot <- ggplot(data, aes(x=index, y=count, fill=structure(block_type))) +
  theme_bw() +
  theme(legend.justification=c(0,1), legend.position = c(0.03, 0.96), legend.background = element_rect(fill="white", size=0.1, linetype="solid", colour ="black")) +
  labs(x = "Trial Participants", y = "Transaction Count", fill = "Transaction") +
  geom_bar(stat="identity") +
  expand_limits(x = 0, y = 0) +
  scale_x_continuous(expand = c(0, 0), limits = c(-1,16), breaks = seq(0, 15, len = 16)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0,120)) +
  scale_fill_manual(values=gdocs_pal()(6))

plot
ggsave("experiment_1_unit.eps", width = 15, height = 10, units = "cm")
