library(dplyr)
library(readr)

top200_df <- list.files(path="data/top200/", full.names = TRUE) %>% 
  lapply(read.csv, skip = 1) %>% 
  bind_rows 

dates <- seq(as.Date('2020-03-01'), as.Date('2020-04-14'), by = 'day')
dates <- rep(dates, each = 200)

top200_df <- cbind(top200_df, dates)

saveRDS(top200_df, file = 'data/top200/top200.Rds')
