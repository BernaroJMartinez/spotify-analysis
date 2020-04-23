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
  facet_wrap(~ var, scales = 'free') + 
  labs(y = "Average Value Each Day",
       x = "Date",
       title = "Trends In Each Audio Feature Over Time") + 
  theme_minimal() +
  theme(axis.line = element_line(color = 'black', linetype = 'solid'))

averaged <- data %>%
  group_by(date) %>%
  summarise(danceability = mean(danceability), energy = mean(energy), 
            key = mean(key), loudness = mean(loudness), mode = mean(mode), 
            speechiness = mean(speechiness), acousticness = mean(acousticness), 
            instrumentalness = mean(instrumentalness), liveness = mean(instrumentalness), 
            valence = mean(valence), tempo = mean(tempo), 
            cases = mean(cases), deaths = mean(deaths))

averaged %>%
  dplyr::select(date, danceability, energy, key, speechiness, instrumentalness, liveness, valence, tempo, cases) %>%
  gather(key = "var", value = "value", -date, -cases) %>%
  ggplot(aes(x = value, y = log(cases))) +
  geom_point() +
  facet_wrap(~ var, scales = "free") +
  theme_minimal() + 
  labs(title = "Number of Average Cases Across Different Values of Audio Features",
       x = "Values",
       y = "Log of Cases Per Day") + 
  theme(axis.line = element_line(color = 'black', linetype = 'solid'))










