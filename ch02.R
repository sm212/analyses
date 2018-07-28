library(tidyverse)

# ggplot is an implementation of the "layered grammer of graphics".
# It starts by making a blank plot, the iteratively putting more plots
# on top of it:

ggplot(data=mpg) # Blank plot
ggplot(data=mpg, aes(x=displ, y=hwy)) 
# Mapped variables (columns in the data) to the plot - ggplot shows this
# by drawing axes

ggplot(data=mpg, aes(x=displ, y=hwy)) +
  geom_point() + # Add points on top of the axes
  geom_line() # Add a line going through each point on top of the axes
              # and points

# ggplot has other aesthetic attributes e.g. colour, size, shape...
ggplot(data=mpg, aes(x=displ, y=hwy, colou)) + # Colour each point in by `class`
  geom_point()

ggplot(mpg, aes(x=displ, y=hwy)) +
  geom_point() +
  facet_wrap(~cyl)

ggplot(mpg, aes(drv, hwy)) +
  geom_violin()

ggplot(economics, aes(date, unemploy / pop)) +
  geom_line()

ggplot(economics, aes(date, uempmed)) +
  geom_line()

ggplot(economics, aes(unemploy / pop, uempmed)) +
  geom_path(aes(colour=date), size=1) + 
  xlab("% of population unemployed") +
  ylab("Median number of weeks unemployed")
