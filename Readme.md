# Scrap indeed.com for job reviews for Drivers 

## Execute the following commands in R

library(rvest) \n

library(dplyr) \n

library(purrr) \n

library(magrittr) \n

library(readr) \n

source('IndeedScrapper.R')

scrapped_data <- seq(0,120,20) %>% map_df(function(x) IndeedScrapper(x)) %>% distinct()

write_csv(scrapped_data,'indeedscrap.csv')

## Thank you for visiting the page... As always please contribute to make this better