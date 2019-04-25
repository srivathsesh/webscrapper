#' webscrape indded.com for ratings, reviews, pros and cons. Wrapper for parsecontainer
#'
#' @param page numeric, page number of review webpage 
#' @param url string, contains link to indeed search page EXCEPT the page number, see example
#' @param Org string, organization or company name
#'
#' @return dataframe containing, reviewer ID, Position, State, City, Date of review, Rating, Title of review, Review, Pros, Cons and Org
#' @export
#'
#' @examples IndeedScrapper(20,'https://www.indeed.com/cmp/Ryder/reviews?fcountry=ALL&fjobtitle=Driver&start=','Ryder')
#' @author Sri Seshadri Data Scientist Ryder
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