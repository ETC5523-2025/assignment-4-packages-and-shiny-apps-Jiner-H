# inst/app/app.R
#
# This is the Shiny app that ships with the package.
# It assumes the package is installed/loaded so that data(delta_cases) works.

library(shiny)
library(dplyr)
library(ggplot2)

ui <- fluidPage(
  titlePanel("Delta variant quarantine analysis"),
  sidebarLayout(
    sidebarPanel(
      # Input 1: choose period
      selectInput(
        inputId = "period",
        label = "Select period:",
        choices = c("All", "pre-delta", "delta"),
        selected = "All"
      ),
      # Input 2: choose what to plot
      selectInput(
        inputId = "yvar",
        label = "Select outcome to plot:",
        choices = c(
          "Leakage events" = "leakage",
          "Detected in quarantine" = "detected_in_quarantine",
          "Local cases" = "local_cases",
          "Leakage per 1,000 arrivals" = "leakage_per_1000_arrivals"
        ),
        selected = "leakage"
      ),
      # Description block (assignment requirement)
      helpText("Data reconstructed from PMC8993115. Period = whether observation is before or during Delta."),
      helpText("Tip: Delta period should show more pressure on the system.")
    ),
    mainPanel(
      h4("Time series"),
      plotOutput("ts_plot"),
      br(),
      h4("Summary by period"),
      tableOutput("summary_tbl"),
      br(),
      p("How to interpret: higher leakage per 1,000 arrivals or higher local cases during the Delta period suggests that the system experienced more breaches.")
    )
  )
)

server <- function(input, output, session) {

  # 1) load data from the installed package
  data("delta_cases", package = "deltaoutbreak")

  # 2) reactive filtered data
  filtered_data <- reactive({
    if (input$period == "All") {
      delta_cases
    } else {
      dplyr::filter(delta_cases, .data$period == input$period)
    }
  })

  # 3) plot
  output$ts_plot <- renderPlot({
    df <- filtered_data()

    ggplot(df, aes(x = date, y = .data[[input$yvar]], color = period, group = 1)) +
      geom_line() +
      geom_point() +
      labs(
        x = "Month",
        y = input$yvar,
        color = "Period"
      ) +
      theme_minimal()
  })

  # 4) summary table
  output$summary_tbl <- renderTable({
    deltaoutbreak::summarise_leakage(filtered_data())
  })
}

shinyApp(ui, server)
