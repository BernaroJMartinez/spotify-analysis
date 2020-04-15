library(spotifyr)
library(tidyverse)
library(dplyr)

top200 <- readRDS('data/top200/top200.Rds')

Sys.setenv(SPOTIFY_CLIENT_ID = '6a7f5a7fd7b742198b85b4686d6d41b0')
Sys.setenv(SPOTIFY_CLIENT_SECRET = '52e8a745afa04d43b973b2c811af1308')

access_token <- get_spotify_access_token()

tracks <- unique(top200$Track.Name)

get_ids <- function(x){
  Sys.sleep(.1)
  track_search <- search_spotify(x, type = 'track', market = 'US')
  id <- track_search$id[1]
  return(id)
}

ids <- sapply(tracks, get_ids)

audio_features = sapply(ids, get_track_audio_features)

df_cols <- unique(unlist(sapply(audio_features, function(x) names(unlist(x))))) 

audio_features_df <- audio_features %>% 
  sapply(function(x) unlist(x)[df_cols]) %>% 
  t %>% 
  data.frame %>% 
  type.convert(as.is = TRUE)

saveRDS(audio_features_df, file = 'data/audio_features.Rds')
