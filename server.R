library(shiny)
source("predictionModel/predictionModel.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  modeldfmList <- dfmList()
  
  session$onSessionEnded(stopApp)
  
  observeEvent(input$submit, {
    inputWords <- input$textInput
    
    prevWords <- ""
    timeTaken <- 0
    probability <- 0
    
    if(inputWords == ""){
      returnVal <- "Please input a sentence"
    } else {
      timeTaken <- system.time(val <- predictNextWord(inputWords), gcFirst = FALSE)
      returnVal <- val$nextWord
      print(paste("returnVal:", returnVal, "class(returnVal):", class(returnVal)))
      probability <- val$probability
      prevWords <- val$prevWord
      timeTaken <- timeTaken[3]
      if(prevWords == "a" && returnVal == "the"){
        prevWords <- ""
      }
    }
    
    output$predictedText <- renderText({
      returnVal
    })
    
    output$sidebar <- renderUI({
      if(inputWords == ""){
        return({h3("Please enter a text input to predict on")})
      } else {
        return({
          sidebarPanel(
            h4("n-gram used:"),
            h3(prevWords),
            br(),
            h4("time taken to find prediction:"),
            h3(paste(round(timeTaken, digits = 2), "s")),
            br(),
            h4("probability the prediction is correct:"),
            h3(paste(round(probability, digits = 5) * 100, "%", sep = "")),
            p("This probability is calculated as the relative\n
              number of time the n-gram is seen in the training\n
              data set")
          )
        })
      }
    })
  })
  
})
