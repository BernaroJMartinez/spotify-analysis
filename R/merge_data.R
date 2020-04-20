library(tidyverse) 
library(lubridate) 

us_cases <- read.csv('data/us.csv')
top200 <- readRDS('data/top200/top200.Rds')
audio_features <- readRDS('data/audio_features.Rds')

audio_features <- dplyr::as_data_frame(audio_features, rownames = "Track.Name")

# Merged the top200 and audio_features datasets 
coronavirus <- left_join(top200, audio_features, "Track.Name")

colnames(coronavirus)[6] <- "date"

us_cases <- us_cases %>% 
  slice(41:89)

us_cases <- us_cases %>% 
  mutate(date = as_date(date))

# Compiled top200, audio_features, and us_cases datasets into one
coronavirus <- left_join(coronavirus, us_cases, "date")

saveRDS(coronavirus, file = 'data/coronavirus.Rds')
