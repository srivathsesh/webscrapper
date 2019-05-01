# Scrape indeed.com for driver reviews.

# library calls

library(magrittr)
library(dplyr)
library(purrr)

source('IndeedScrapper.R')

## Note we are starting with base url where the number after "=" at the end of the url is left blank

Ryder_url <- 'https://www.indeed.com/cmp/Ryder/reviews?fcountry=ALL&fjobtitle=Driver&start='
Pensky_url <- 'https://www.indeed.com/cmp/penske/reviews?fcountry=ALL&fjobtitle=Driver&start='
XPO_url <- 'https://www.indeed.com/cmp/Xpo-Logistics/reviews?fcountry=ALL&fjobtitle=Driver&start='

# There are several pages within each link. Each page has 20 reviews. I didn't find an automatic way to retrieve the number of pages in the link.
# I am sure there must be a way. This is an opportunity to improve the code
# At this time we'll build a dataframe that takes in the imput for the functions that are in the project.

# There are 7 pages in the Ryder review page, starting from 0. page 1 - 0 start, page 2 - 20 start, page 3 - 40 start .... page 7 120 start

Ryder_Pages <-  seq(0,120,20)
Pensky_Pages <- seq(0,40,20)
XPO_Pages <-  seq(0,80,20)

Urls <- c(rep(Ryder_url,length(Ryder_Pages)),
          rep(Pensky_url,length(Pensky_Pages)),
          rep(XPO_url, length(XPO_Pages)))

Org <- c(rep('Ryder',length(Ryder_Pages)),
         rep('Pensky',length(Pensky_Pages)),
         rep('XPO', length(XPO_Pages)))

Pages <- c(Ryder_Pages,
           Pensky_Pages,
           XPO_Pages)

InputArguments <- list(Pages,Urls,Org)

scrapedData <-  InputArguments %>% pmap(.f=function(x,y,z) IndeedScrapper(x,y,z)) %>% 
  reduce(rbind.data.frame)


# Search for Truck + Driver key word

Ryder_url2 <- 'https://www.indeed.com/cmp/Ryder/reviews?fcountry=ALL&fjobtitle=Truck+Driver&start='
Pensky_url2 <- 'https://www.indeed.com/cmp/penske/reviews?fcountry=ALL&fjobtitle=Truck+Driver&start='
XPO_url2 <- 'https://www.indeed.com/cmp/Xpo-Logistics/reviews?fcountry=ALL&fjobtitle=Truck+Driver&start='


Ryder_Pages2 <-  seq(0,120,20)
Pensky_Pages2 <- seq(0,40,20)
XPO_Pages2 <-  seq(0,40,20)


Urls2 <- c(rep(Ryder_url2,length(Ryder_Pages2)),
          rep(Pensky_url2,length(Pensky_Pages2)),
          rep(XPO_url2, length(XPO_Pages2)))

Org2 <- c(rep('Ryder',length(Ryder_Pages2)),
         rep('Pensky',length(Pensky_Pages2)),
         rep('XPO', length(XPO_Pages2)))

Pages2 <- c(Ryder_Pages2,
           Pensky_Pages2,
           XPO_Pages2)

InputArguments2 <- list(Pages2,Urls2,Org2)

scrapedData_Truck_Driver <-  InputArguments2 %>% pmap(.f=function(x,y,z) IndeedScrapper(x,y,z)) %>% 
  reduce(rbind.data.frame)

IndeedReviews <- rbind.data.frame(scrapedData,scrapedData_Truck_Driver)

#  save data as .RData

save(IndeedReviews,file = 'Reviews.RData')

# At a later time JB hunt was asked to be added to the mix, the code below accomplishes that.

JBHunt_url <- 'https://www.indeed.com/cmp/J.b.-Hunt/reviews?fcountry=ALL&fjobtitle=Driver&start'

JB_Hunt_Pages <- seq(0,220,20)

jbhurls <- rep(JBHunt_url,length(JB_Hunt_Pages))

jbhuntorg <-  rep('JBHunt',length(JB_Hunt_Pages))

inputargs3 <- list(JB_Hunt_Pages,jbhurls,jbhuntorg)

IndeedScrapper_safe <- safely(IndeedScrapper)

inputargs3 %>% 
  pmap(.f=function(x,y,z) IndeedScrapper_safe(x,y,z)) %>% 
  map('result') %>% 
  compact() %>% 
  reduce(rbind.data.frame)

