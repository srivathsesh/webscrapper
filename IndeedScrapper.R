IndeedScrapper <- function(page,url = 'https://www.indeed.com/cmp/Ryder/reviews?fcountry=ALL&fjobtitle=Driver&start=',Org = NULL){
  
  library(rvest)
  library(dplyr)
  library(purrr)
  source('parseContainer.R')
  
  url <- paste0(url,page)
  webpage <- read_html(url)
  
  container <- html_nodes(webpage,'div.cmp-review-container') %>% html_children()
  
  stopifnot(length(container) > 0)
  
  # safely
  
  parseContainer_safe <- safely(parseContainer)
  
  list(container[seq(2,length(container),2)], rep(Org,length(seq(2,length(container),2)))) %>% 
    pmap(.f=function(x,y) parseContainer_safe(x,y)) %>% 
    map('result') %>% 
    compact() %>% 
    reduce(rbind.data.frame)
  
  
}