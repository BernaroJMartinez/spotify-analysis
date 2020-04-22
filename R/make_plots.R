library(ggplot2)
library(dplyr)
library(tidyr)


data <- readRDS('data/coronavirus.Rds')

data <- data %>% 
  mutate(position_bracket = case_when(
    Position < 10 ~ "Top Ten",
    Position < 50 ~ "Top Fifty",
    Position < 100 ~ "Top One Hundred",
    Position < 200 ~ "Top Two Hundred"
  ))

grouped_date_data <- data %>% 
  group_by(date) %>% 
  select(c('date', "danceability","energy","key","loudness", "mode","speechiness","acousticness",
           "instrumentalness","liveness","valence","tempo", 'duration_ms', "time_signature")) %>% 
  summarise_all('mean') %>% 
  gather(-date, -position, key = "var", value = "value") 

ggplot(data = grouped_date_data, mapping = aes(x = date, y = value)) + 
  geom_line() + 
  facet_wrap(~ var, scales = 'free')+
  theme_minimal()

grouped_position_data <- data %>% 
  filter(!is.na(position_bracket)) %>% 
  group_by(position_bracket, date) %>% 
  select(c('date', 'position_bracket', "danceability","energy","key","loudness", "mode","speechiness","acousticness",
           "instrumentalness","liveness","valence","tempo", 'duration_ms', "time_signature")) %>% 
  summarise_all('mean')
