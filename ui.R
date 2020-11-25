library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Data Science Capstone Project - Word Prediction Application"),
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            textInput("InputSentence", "Enter some words to begin prediction:")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            h3("Predicted word:"),
            textOutput("predictedWord")
        )
    )
))