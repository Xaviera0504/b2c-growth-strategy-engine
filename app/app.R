# Load required libraries
library(shiny)
library(bslib)
library(readr)
library(dplyr)
library(ggplot2) # <-- NEW: The graphing library

# 1. Load the data 
data <- read_csv("processed_data.csv")

# 2. Define the User Interface 
ui <- page_sidebar(
  title = "B2C Growth Strategy Engine",
  theme = bs_theme(bootswatch = "flatly"),
  
  sidebar = sidebar(
    h4("Strategy Controls"),
    helpText("Use this dashboard to identify revenue at risk and high-value customer segments.")
  ),
  
  # KPI Boxes
  layout_columns(
    fill = FALSE,
    value_box(
      title = "Total Customers",
      value = nrow(data),
      theme_color = "primary"
    ),
    value_box(
      title = "High Risk Customers",
      value = sum(data$Churn_Risk == 1),
      theme_color = "danger"
    ),
    value_box(
      title = "Whale Customers",
      value = sum(data$User_Segment == "Whale"),
      theme_color = "success"
    )
  ),
  
  # NEW: Add a visual card for our chart
  card(
    card_header("Spend Distribution: Whales vs. Standard"),
    plotOutput("segment_plot")
  )
)

# 3. Define the Server Logic 
server <- function(input, output, session) {
  
  # NEW: Draw the plot using ggplot2
  output$segment_plot <- renderPlot({
    ggplot(data, aes(x = User_Segment, y = `Total Spend`, fill = User_Segment)) +
      geom_boxplot() +
      theme_minimal(base_size = 16) +
      labs(
        x = "Customer Segment", 
        y = "Total Spend ($)"
      ) +
      scale_fill_manual(values = c("Standard" = "#95a5a6", "Whale" = "#2ecc71")) +
      theme(legend.position = "none") # Hides the redundant legend
  })
}

# 4. Run the Application 
shinyApp(ui = ui, server = server)