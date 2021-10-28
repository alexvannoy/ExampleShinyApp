# NOTE:  Mostly stolen from 
# https://github.com/rstudio/shiny-examples/blob/master/084-single-file/app.R

# Source dependency functions
R.utils::sourceDirectory(file.path(usethis::proj_get(), "R"))


# Define the UI
ui <- bootstrapPage(
  numericInput('n', 'Number of obs', 200L),
  plotOutput('plot')
)


# Define the server code
server <- function(input, output) {
  # Note to self: reactive elements are called like methods
  numberOfObs <- reactive({
    # TODO: Add some error checking of some kind.
    if(!is.integer(input$n)) {
      stop("That's not an integer...")
    }
    n <- trivial_function(input$n)
    return(n)
  })
  output$plot <- renderPlot({
    graphics::hist(stats::runif(numberOfObs()))
  })
}


# Return a Shiny app object
shinyApp(ui = ui, server = server)