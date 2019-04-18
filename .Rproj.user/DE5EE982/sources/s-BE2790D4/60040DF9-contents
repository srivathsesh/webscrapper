IndeedScrapper <- function(page,url = 'https://www.indeed.com/cmp/Ryder/reviews?fcountry=ALL&fjobtitle=Driver&start='){
  
  library(rvest)
  library(dplyr)
  library(purrr)
  source('parseContainer.R')
  
  url <- paste0(url,page)
  webpage <- read_html(url)
  
  container <- html_nodes(webpage,'div.cmp-review-container') %>% html_children()
  
  stopifnot(length(container) > 0)
  
  # attempt to make program move past error
  parseContainer_Safe <- safely(parseContainer)
  
  container[seq(2,length(container),2)] %>% map_df(.,.f=parseContainer_Safe)
  
  
}