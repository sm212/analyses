library(tidyverse); library(lubridate)

ggplot(economics, aes(date, unemploy)) +
  geom_line()

presidents <- subset(presidential, start > economics$date[1])
presidents$x_pos <- presidents$start + (presidents$end - presidents$start) / 2

ggplot(economics) +
  geom_line(aes(date, unemploy)) +
  geom_rect(data=presidents,
            aes(xmin=start, xmax=end, fill=party), ymin=-Inf, ymax=Inf, alpha=0.2) +
  geom_vline(data=presidents,
             aes(xintercept=as.numeric(start)),
             colour="grey50",
             alpha=0.5) +
  geom_text(data=presidents,
            aes(x=x_pos, y=2000, label=name)) +
  scale_fill_manual(values=c("blue", "red")) +
  theme_minimal()
