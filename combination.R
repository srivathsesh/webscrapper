combination <- function(input) {
  numberslist <- list(
    "2" = c("a", "b", "c"),
    "3" = c("d", "e", "f"),
    "4" = c("g", "h", "i"),
    "5" = c("j", "k", "l"),
    "6" = c("m", "n", "o"),
    "7" = c("p", "q", "r", "s"),
    "8" = c("t", "u", "v"),
    "9" = c("w", "x", "y", "z")
  )
  strvec <- strsplit(input, "")[[1]]
  numberlength <- length(strvec)
  i <- 1
  collect <- NULL
  #flag <- F
  while (i < numberlength) {
     #browser()
    for (j in c(numberslist[[strvec[i + 1]]])) {
      if (i == 1) {
        collect <- c(collect,paste0(numberslist[[strvec[i]]],j))
      } else{
       # collect <- c(collect,paste0(collect,j))
        collect <- c(collect,paste0(collect[apply(array(collect),1,nchar)==i],j))
      }
      
    }
    i <- i + 1
  }

    return(collect[apply(array(collect),1,nchar)==numberlength])
 
}


anagramgrps <- function(string){
  words <- length(string)
  queueIndex <- seq(1:words)
  set <- list()
  getGrp <- function(){
    Grp <- queueIndex[1]
    x <- string[Grp]
    strvec <- strsplit(x,"")[[1]]
    for(j in queueIndex[-1]){
       y <- strsplit(string[j],"")[[1]]
       if(length(strvec) == length(y) & all(sort(strvec)==sort(y))){
         Grp <- c(Grp,j)
       }
    }
    queueIndex <<- setdiff(queueIndex,Grp)
    return(Grp)
  }
  
  i <- 1
  while(length(queueIndex)>0){
    message("at iteration ", i)
    grpname <- paste0("grp",i)
     set[[grpname]]<- getGrp()
     i <- i + 1
  }
  
  
  lapply(set,)
  
}

nchar("sri")
stringr::str_count("sri")
