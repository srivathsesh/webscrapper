#' Parses each review in a page separately. This function is called from IndeedScrapper()
#'
#' @param containerBin contents under div.cmp-review-container node in the webpage
#' @param Org character, organization name
#'
#' @return tibble, with the following columns
#'                    ID ,
#'                   Position,
#'                   State,
#'                   City,
#'                   Date,
#'                   Rating,
#'                   Title,
#'                   Review,
#'                   Pros,
#'                   Cons,
#'                   Org
#' @export
#'
#' @examples url <- 'https://www.indeed.com/cmp/Ryder/reviews?fcountry=ALL&fjobtitle=Driver&start=20' ; 
#' webpage <- read_html(url); container <- html_nodes(webpage,'div.cmp-review-container') %>% html_children(); 
#' parseContainer(container[2],'Ryder')
#' 
#' @author Sri Seshadri Data Scientist SCS Ryder Logistics
parseContainer <- function(containerBin,Org = NULL){
  
  library(rvest)
  library(tidyverse)
  
  stopifnot(length(containerBin) > 0)
  
  # Parse title
 containerBin %>% html_nodes('.cmp-review-title') %>% html_text() -> title
  
  # Parse Rating
  
containerBin %>% html_nodes('.cmp-ratingNumber') %>% html_text() %>% as.integer() -> Rating
  
  # Parse location
  str_split(containerBin %>% html_node('.cmp-reviewer-job-location') %>% html_text(), ",") %>% unlist() -> location
  State <- location[2]
  City <- location[1]
  
  # Parse date
  containerBin %>% html_nodes('.cmp-review-date-created') %>% html_text() %>% lubridate::mdy(.) -> Date_review
  
  # Parse Position
  containerBin %>% html_node('.cmp-reviewer-job-title') %>% 
    html_text() %>% ifelse(is_empty(.),NA,.) -> position
  
  # Parse Description
  containerBin %>% html_node('.cmp-review-description') %>% 
    html_text() %>% ifelse(is_empty(.),NA,.) -> review
  
  # Parse Pros
  containerBin %>% html_nodes('.cmp-review-pro-text') %>% 
    html_text() %>% ifelse(is_empty(.),NA,.) -> Pros
  
  # Parst Cons
  containerBin %>% html_nodes('.cmp-review-con-text') %>% 
    html_text() %>% ifelse(is_empty(.),NA,.) -> Cons
  # Parse ID
  child <- containerBin %>% html_children()
  child[3] %>% html_attrs() %>% unlist -> childarray
  
  childarray['data-reviewid'] %>% 
    ifelse(is_empty(.),NA,.) %>% as.numeric() -> ID
  
  # return as a list
 tibble(
   ID = ID,
   Position = position,
   State = State,
   City = City,
   Date = Date_review,
   Rating = Rating,
   Title = title,
   Review = review,
   Pros = Pros,
   Cons = Cons,
   Org = Org
   
   
 )
  
}