library(tidyverse)

# Unemployment numbers by president
presidents <- subset(presidential, start > economics$date[1])
presidents$x_pos <- presidents$start + (presidents$end - presidents$start) / 2

ggplot(economics) +
  geom_line(aes(date, unemploy)) +
  geom_rect(data=presidents,
            aes(xmin=start, xmax=end, fill=party), 
            ymin=-Inf, ymax=Inf, alpha=0.2) +
  geom_vline(data=presidents,
             aes(xintercept=as.numeric(start)),
             colour="grey50",
             alpha=0.5) +
  geom_text(data=presidents,
            aes(x=x_pos, y=2000, label=name)) +
  scale_fill_manual(values=c("blue", "red")) +
  theme_minimal()

# Grouping variables
data(Oxboys, package="nlme")
# Oxboys is a longitudinal dataset, measuring the height of 26 subjects
# (boys) on 9 seperate occassions. It also contains the centered ages


ggplot(Oxboys, aes(age, height, group=Subject)) +
  geom_point() +
  geom_line()

# Each Subject's data is individually grouped, and then seperately mapped using the
# same aesthetic (points & lines in this case).
# Compare this to the same plot without specifying the group variable:
ggplot(Oxboys, aes(age, height)) +
  geom_point() +
  geom_line()


ggplot(Oxboys, aes(age, height)) +
  geom_line(aes(group=Subject)) +
  geom_smooth(method="lm", se=F, size=1.5)

ggplot(Oxboys, aes(Occasion, height)) +
  geom_boxplot() +
  geom_line(colour="blue", mapping=aes(group=Subject), alpha=0.3)


ggplot(mpg, aes(displ, cty)) +
  geom_boxplot(aes(group=displ))

df <- data.frame(x=1:3, y=1:3, colour=c(1, 3, 5))
ggplot(df, aes(x, y, colour=factor(colour), group=1)) +
  geom_line()
