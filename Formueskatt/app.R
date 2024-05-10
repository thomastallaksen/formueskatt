library(shiny)
library(dplyr)
library(readr)
library(scales)  # For formatting numbers

# Les inn dataene
data <- read_csv("data.csv")

# Definer UI for applikasjonen
ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      .shiny-output-error { visibility: hidden; }
      .shiny-output-error:before { visibility: hidden; }
      .well {
        background-color: #f7f7f7;
        padding: 20px;
        border: none;
      }
      .shiny-input-container {
        margin-bottom: 0;  # Fjerner margin for å justere høyden på inputboksen
      }
    "))
  ),
  titlePanel(""),
  tags$div(style = "height: 20px;"),  # Gir litt luft mellom toppen og innholdet
  sidebarLayout(
    sidebarPanel(
      tags$div(
        style = "background-color: #f7f7f7; padding: 20px; height: 100%;",
        selectInput("kommune", 
                    "Søk etter din kommune:", 
                    choices = c("Alle kommuner", sort(unique(data$Kommunenavn))),
                    selected = "Alle kommuner"
        )
      )
    ),
    mainPanel(
      tags$div(
        style = "background-color: #f7f7f7; padding: 20px; margin-bottom: 20px;",
        tags$h4("Formueskatt:", style="margin: 0;"),
        tags$h2(textOutput("formueskatt"), style="font-weight: bold; font-size: 24px; margin-top: 5px;")
      ),
      tags$div(
        style = "background-color: #f7f7f7; padding: 20px;",
        tags$h4("Antall helsefagarbeidere:", style="margin: 0;"),
        tags$h2(textOutput("helsefagarbeidere"), style="font-weight: bold; font-size: 24px; margin-top: 5px;")
      )
    )
  )
)

# Definer serverlogikken
server <- function(input, output) {
  
  filtered_data <- reactive({
    if (input$kommune == "Alle kommuner") {
      data
    } else {
      filter(data, Kommunenavn == input$kommune)
    }
  })
  
  output$formueskatt <- renderText({
    sum_formueskatt <- sum(filtered_data()$Formueskatt, na.rm = TRUE)
    paste(format(sum_formueskatt, big.mark = " ", decimal.mark = ","), "kr")
  })
  
  output$helsefagarbeidere <- renderText({
    sum_helsefagarbeidere <- sum(filtered_data()$Helsefagarbeidere, na.rm = TRUE)
    format(sum_helsefagarbeidere, big.mark = " ")
  })
}

# Kjør appen
shinyApp(ui = ui, server = server)
