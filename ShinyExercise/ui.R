library(shiny)

shinyUI(fluidPage(
  titlePanel("Predict your child's height"),
  sidebarLayout(
    sidebarPanel(
       h3("Instruction:"),
       h4("Please select the father's height on the left screen, the son's height with confidential interval will be shown on the right screen."),
       sliderInput("father", "What is the height of the father?", min = 59, max = 76, value = 67.50)
    ),
    mainPanel(
        h3("Results of prediction"),
        h4("Father's height you entered:"),
        textOutput("inputValue"),
        h4("Which resulted in a prediction of the son's height of:"),
        textOutput("prediction"),
        h4("with 95% confidence interval of:"),
        textOutput("lower"),
        textOutput("upper"),
        plotOutput("regression")
    )
  )
))
