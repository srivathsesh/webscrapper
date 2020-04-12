library(rvest)
url <- 'https://www.truckinginfo.com/334884/is-it-time-to-rethink-shipper-carrier-contracts'
url2 <- 'https://www.overdriveonline.com/slowdown-watch-how-slow-how-far-down/'

webpage <- read_html(url)
webpage2 <- read_html(url2)

html_nodes(webpage,'div.content-body') %>% html_text() -> blobText
html_nodes(webpage2,'div.usercontent') %>% html_text() -> blobText2
# clean blob text
getwordCloud <- function(blobText){
  library(tm)
  words <- Corpus(VectorSource(blobText))
  
  # change case
  words <- tm_map(words,tolower)
  
  # remove numbers
  words <- tm_map(words,removeNumbers)
  
  # the above did not remove the quotes
  # remove crazy chars
  toSpace <- content_transformer(function(x, pattern) gsub(pattern = pattern,replacement = " ",x=x))
  words <- tm_map(words,toSpace, "\\r")
  words <- tm_map(words,toSpace, "\\n")
  words <- tm_map(words,toSpace, '”')
  words <- tm_map(words,toSpace,"“")
  words <- tm_map(words,toSpace,"’s")
  
  # remove whitespaces
  
  words <- tm_map(words,stripWhitespace)
  
  # remove stop words
  
  words <- tm_map(words,removeWords,stopwords("english"))
  
  # remove punctuation
  words <- tm_map(words,removePunctuation)
  
  # lemmatize words
  
  #words <- textstem::lemmatize_words(words)
  
  tdm  <- TermDocumentMatrix(words)
  m  <- as.matrix(tdm)
  # sort(termFreq(words[1][1]$content),decreasing = T)
  
  v <- sort(rowSums(m), decreasing = T)
  
  df <- data.frame(word = names(v), frequency = v)
  
  library(RColorBrewer)
  wordcloud::wordcloud(df$word, df$frequency, min.freq = 2, max.words = 500,
                       random.order = FALSE,rot.per = 0.35, colors = brewer.pal(8,"Dark2"))
  
}

getwordCloud(blobText)
getwordCloud(blobText2)

