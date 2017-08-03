library(shiny)

library(UsingR)
data(father.son)
library(ggplot2)

shinyServer(
    function(input, output) {
        fit <- lm(sheight ~ fheight, data = father.son)
        
        sonPred <- reactive({
            fatherInput <- input$father
            round(predict(fit, newdata=data.frame(fheight=fatherInput)),1)
        })
        
        output$inputValue <- renderText({input$father})
        output$prediction <- renderText({sonPred()})
        
        fathers <- father.son$fheight
        ribbon_x <- data.frame(fheight=seq(min(fathers), max(fathers), length=1000))
        ribbon_y <- data.frame(predict(fit, newdata=ribbon_x, interval = "prediction"))
        ribbon_dat <- cbind(ribbon_x, ribbon_y)
        
        son_lw <- reactive({
            fatherInput <- input$father
            son_CI<-predict(fit, newdata=data.frame(fheight=fatherInput), interval="prediction")
            round(son_CI[1,2],1)
        })
        
        son_up <- reactive({
            fatherInput <- input$father
            son_CI<-predict(fit, newdata=data.frame(fheight=fatherInput), interval="prediction")
            round(son_CI[1,3],1)
        })
        
        output$lower <- renderText(son_lw())
        output$upper <- renderText(son_up())
        output$regression <- renderPlot({
            g <- ggplot(data = ribbon_dat, aes(x=fheight, y=fit)) + 
                geom_ribbon(aes(ymin=ribbon_y$lwr, ymax=ribbon_y$upr), alpha=0.2) +
                geom_line(color="blue", size=1.5) +
                geom_point(data=father.son, aes(x=fheight, y=sheight), alpha=0.5) +
                geom_point(aes(x=input$father, y=sonPred()), color="red", size=3) +
                geom_point(aes(x=input$father, y=son_lw()), color="red", size=3) +
                geom_point(aes(x=input$father, y=son_up()), color="red", size=3) 
            g
        })
       
})
