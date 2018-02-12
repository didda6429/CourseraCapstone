##------------------------------------------
#
# This script contains all the required functions for the 
# prediction-model
#
##------------------------------------------

require(data.table)
require(dplyr)

## Read the data tables into R
dfmList <- function(){
  return(lapply(1:4, function(x)readRDS(paste("predictionModel/modelDataFiles/", x, "grams.RDS", sep = ""))))
}

## Base function which acts as a wrapper to all the other required function calls
predictNextWord <- function(input){
  return(removePunct(inputSentence(input)))
}

## Seperate a sentence into a vector of words
inputSentence <- function(input){
  return(unlist(strsplit(input, " ")))
}

## Remove the punctuation from the input
removePunct <- function(input){
  input <- tolower(gsub("[[:punct:][:blank:]]+", "", input))
  return(findNextWord(input))
}

## Go through the data tables to find the next word
## This implements stupid-backoff, so it keeps going
## until it finds a n-gram it recognises.
findNextWord <- function(input){
  inputLength <- length(input)
  if(length(input) == 1 && input == ""){
    inputLength <- 0
    input <- "a" 
  }
  combinedInput <- paste(input, collapse = "_")
  if(inputLength <=3){
    returnVal <- modeldfmList[[inputLength + 1]] %>%
      filter(prevWord == combinedInput) %>%
      mutate(probability = freq/totalCount)
    print(returnVal)
    if(nrow(returnVal) != 1){
      if(inputLength > 1){
        print("a")
        print(input)
        returnVal <- findNextWord(input[2:length(input)])
      } else {
        print("b")
        returnVal <- findNextWord("")
      }
    }
  } else {
    returnVal <- findNextWord(input[2:length(input)])
  }
  return(returnVal)
}
