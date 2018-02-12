library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Coursera NLP Capstone Text Prediction Project"),
  
  sidebarLayout(
      uiOutput("sidebar"),
    
    mainPanel(
       textInput("textInput", "Input text here"),
       actionButton("submit", "Submit"),
       br(),
       h3("predicted word:"),
       h2(textOutput("predictedText"))
    )
  )
))
