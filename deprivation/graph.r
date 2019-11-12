library(tidyverse)
library(parlitools)
imd = read_csv('./imd.csv')

constituency_info = bes_2017 %>%
  left_join(party_colour, by = c('winner_17' = 'party_name')) %>%
  select(pano:seat_change_1517, party_colour)

# Label dataframes
df_colnum = data.frame(x = 1:10, y = 1, label = 1:10)
df_leftnums = data.frame(x = 0.5, y = -(1:22), label = 1:22, 
                         alpha = 1 / (1:22))
df_rightnums = data.frame(x = 10.7, y = seq(-53, -32, by = 1), 
                          label = seq(553, 532, by = -1), alpha = 1/(1:22))

# Annotation & arrow dataframes
annotations = data.frame(x = c(-2, -1.2, -1.1, -1.2, 11.1, 11.1),
                         y = c(-5, -20.5, -45.5, -50, -45.5, -52.5),
                         label = c('Walton\n(Liverpool)\nMost\ndeprived\nconstituency\nin England',
                                   'Walsall\nNorth',
                                   'Clacton',
                                   'Blackpool\nNorth and\nCleveleys',
                                   'Hallam\n(Sheffield)',
                                   'Wokingham'))

arrows = data.frame(x = c(-1),
                    xend = c(0.3),
                    y = c(-2.3),
                    yend = c(-0.5),
                    curvature = c(-0.4))
  
df_plot = imd %>%
  left_join(constituency_info, by = c('constituency' = 'constituency_name')) %>%
  mutate(decile = ntile(imd_19, 10)) %>%
  arrange(imd_19)

ggplot(df_plot, aes(x = decile, y = -1)) +
  geom_bar(fill = df_plot$party_colour, stat = 'identity', 
           position = 'stack', colour = 'black', width = 0.8) +
  geom_text(aes(x = x, y = y, label = label), df_colnum, 
            fontface = 'bold') +
  geom_text(aes(x = 0.6, y = -56, label = 'MOST\nDEPRIVED'), 
            hjust = 0, fontface = 'bold', size = 3.5) +
  geom_text(aes(x = 10.4, y = -56, label = 'LEAST\nDEPRIVED'), 
            hjust = 1, fontface = 'bold', size = 3.5) +
  geom_text(aes(x = x, y = y, label = label, alpha = alpha), df_leftnums, 
            show.legend = F, size = 3, hjust = 1, vjust = -0.25, 
            fontface = 'bold') +
  geom_text(aes(x = x, y = y, label = label, alpha = alpha), df_rightnums, 
            show.legend = F, size = 3, vjust = -0.25, fontface = 'bold') +
  geom_text(aes(x= x, y = y, label = label), annotations, size = 3, hjust = 0,
            fontface = 'bold', colour = 'grey40') +
  geom_curve(aes(x = x, xend = xend, y = y, yend = yend), arrows, size = 0.5, 
             curvature = -0.4, arrow = arrow(length = unit(0.15, 'cm')), 
             colour = 'grey60') + 
  xlim(-2, 13) +
  ggtitle('CONSTITUENCIES BY DEPRIVATION AND PARTY', 
          '2017 Election Results vs IMD 2019') +
  theme(axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank(),
        panel.background = element_rect(fill = 'transparent'),
        plot.background = element_rect(fill = 'transparent'),
        plot.title = element_text(face = 'bold', hjust = 0.5),
        plot.subtitle = element_text(face = 'bold', hjust = 0.5))

ggsave('constituency_deprivation.png', height = 8, width = 6, units = 'in')