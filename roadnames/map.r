library(ggplot2)
library(dplyr)
library(sf)
library(extrafont)

loadfonts()

shp_road = read_sf('./shp/gis_osm_roads_free_1.shp')
shp_la = read_sf('./shp/Local_Authority_Districts_April_2019_Boundaries_UK_BFC.shp')
shp_la = st_transform(shp_la, st_crs(shp_road))

road_type = function(road_name){
  words = strsplit(road_name, ' ')[[1]]
  words[length(words)]
}

plot_roads = function(la_name, road_groups){
  la = shp_road %>%
    st_join(shp_la %>% filter(lad19nm == la_name), left = F)
  
  la$road_type = sapply(la$name, road_type)
  la$colour = ifelse(la$road_type %in% road_groups, la$road_type, 'Other')
  
  p = ggplot() +
    coord_sf(datum = NA) +
    geom_sf(data = la %>% filter(colour == 'Other'), 
            colour = 'grey80', size = 0.1) +
    geom_sf(data = la %>% filter(colour != 'Other'), 
            mapping = aes(colour = colour, fill = colour), size = 0.3) +
    theme_void() +
    scale_colour_manual(values = c('Road' = '#019868', 'Avenue' = '#f6cf71',
                                   'Way' = '#ec0b88', 'Street' = '#651eac',
                                   'Drive' = '#e18a1e', 'Close' = '#9dd292',
                                   'Other' = '#c6c6c6')) +
    scale_fill_manual(values = c('Road' = '#019868', 'Avenue' = '#f6cf71',
                                 'Way' = '#ec0b88', 'Street' = '#651eac',
                                 'Drive' = '#e18a1e', 'Close' = '#9dd292',
                                 'Other' = '#c6c6c6')) +
    labs(title = paste(la_name, 'roads')) +
    theme(legend.title = element_blank(),
          legend.text = element_text(size = 14),
          plot.title = element_text(size = 18, face = 'italic'),
          text = element_text(family = 'Century Gothic'))
  
  ggsave(plot = p, filename = paste0('./img/', la_name, '.png'), dpi = 600, 
         height = 8, width = 8, units = 'in')
}

road_groups = c('Road', 'Street', 'Close', 'Avenue', 'Drive', 'Way')
las = c('Manchester', 'Middlesbrough', 'Leeds', 'Newcastle upon Tyne', 
        'Liverpool', 'Sheffield', 'Chelmsford')

for (la in las){
  plot_roads(la, road_groups)
}
