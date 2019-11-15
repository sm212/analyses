library(tidyverse)

df = read_csv('./domains_19.csv')

essex = c('Basildon and Billericay', 'Braintree',
          'Brentwood and Ongar', 'Castle Point', 'Chelmsford',
          'Colchester', 'Epping Forest', 'Harlow', 'Harwich and North Essex', 
          'Maldon', 'Rayleigh and Wickford', 'Rochford and Southend East',
          'Saffron Walden', 'South Basildon and East Thurrock',
          'Southend West', 'Thurrock', 'Witham')

domains = c('imd', 'income', 'employment', 'education', 'health', 'crime',
            'barriers', 'environment', 'idaci', 'idaopi')

titles = c('IMD Scores', 'Income Deprivation Scores', 
           'Employment Deprivation Scores', 'Education Deprivation Scores',
           'Health Deprivation Scores', 'Crime Deprvation Scores',
           'Barriers to Housing and Services Deprivation Scores', 
           'Living Environment Deprivation Scores',
           'Income Deprivation Affecting Children Index',
           'Income Deprivation Affecting Older People Index')

scores = df %>%
  select(constituency, ends_with('score')) %>%
  pivot_longer(-constituency, names_to = 'domain', values_to = 'score') %>%
  mutate(domain = str_replace(domain, '_score', ''))

ranks = df %>%
  select(constituency, ends_with('rank')) %>%
  pivot_longer(-constituency, names_to = 'domain', values_to = 'rank') %>%
  mutate(domain = str_replace(domain, '_rank', ''))

# Merge and fix crime & health scores - looks like they weren't transformed?
df_long = scores %>%
  left_join(ranks) %>%
  group_by(domain) %>%
  arrange(rank) %>%
  ungroup() %>%
  mutate(score = ifelse(domain %in% c('crime', 'health'), exp(score), score),
         fill = ifelse(constituency == 'Clacton', 'orange',
                       ifelse(constituency %in% essex, 'blue', 'grey50')))

for (i in 1:length(domains)){
  plot_domain = domains[[i]]
  plot_title = titles[[i]]
  
  p = df_long %>%
    filter(domain == plot_domain) %>%
    ggplot(aes(x = rank, y = score)) +
    geom_bar(aes(fill = fill), width = 1, stat = 'identity') +
    scale_fill_identity(guide = 'legend', 
                        labels = c('Essex', 'Other', 'Clacton')) +
    scale_x_continuous(breaks = c(0, seq(54, 533, by = 55)),
                       labels = 1:10) +
    ggtitle(plot_title) + 
    labs(x = 'Decile', fill = '') +
    theme(axis.text.y = element_blank(),
          axis.title.y = element_blank(),
          axis.ticks.y = element_blank(),
          axis.ticks.x = element_line(colour = 'grey80'),
          axis.text.x = element_text(size = 12, face = 'bold', 
                                     colour = 'grey70'),
          panel.grid.major.y  = element_blank(),
          panel.grid.major.x = element_line(colour = 'grey80'),
          panel.background = element_rect(fill = 'transparent'),
          plot.background = element_rect(fill = 'transparent'),
          legend.position = c(0.95, 0.5))
  
  ggsave(filename = paste0('./img/clacton_', plot_domain, '.png'),
         plot = p,
         height = 6, width = 9, units = 'in')
}