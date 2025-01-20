# runExample() to see more examples of Rshiny

library(shiny)

ui <- fluidPage(

    # Application title
    titlePanel("Iris Data Explorer"),

    sidebarLayout(
        sidebarPanel(
          selectInput("species", "Pick Iris species", choices = as.character(unique(iris$Species))),
          selectInput("x", "Pick X mapping", choices = colnames(select(iris, -Species))[1:2]),
          selectInput("y", "Pick Y mapping", choices = colnames(select(iris, -Species))[3:4])
          
        ),

        mainPanel(
          plotOutput("iris_plot"),
           tableOutput("iris_data")
        )
    )
)

server <- function(input, output) {
  data <- reactive({
    iris %>%
    filter(Species == input$species) %>%
    select(input$x, input$y)
      
  })
  
  output$iris_plot <- renderPlot({
    data() %>%
      setNames(c("X", "Y")) %>%
      ggplot()+
      geom_point(aes(X,Y), color="maroon")+
      xlab(input$x)+
      ylab(input$y)+
      ggtitle(input$species)
  }
  )
  output$iris_data <- renderTable({
    data()
      
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
