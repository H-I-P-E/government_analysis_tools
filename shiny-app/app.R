# Load packages ----


tools <- read_tsv(regexs_shiny_path)

narrow_tool_counts <- read_csv(tool_counts_by_job_shiny_path) %>%
  select(-length) %>%
  gather(key='tool', value = 'count', -job_id, - job_department, -date_downloaded, -description_word_count, -roles) 

# User interface ----
ui <- fluidPage(
  titlePanel("Civil service analytical tools"),
  
  sidebarLayout(
    sidebarPanel(
     selectInput('tool_selected', "Select some analysis things:",
                 choices = tools$tool, multiple = T,
                 selected = 'Excel'),
     selectInput('departments_selected', "Select some departments:",
                 choices = unique(narrow_tool_counts$job_department), multiple = T,
                 selected = "DfE"),
     selectInput('professions_selected', "Select some professions:",
                 choices = unique(narrow_tool_counts$roles), multiple = T,
                 selected = "Statistics")
    ),
    
    mainPanel(plotOutput("plot"))
  )
)

# Server logic
server <- function(input, output) {
  get_data <- reactive(
    narrow_tool_counts %>%
      filter(job_department %in% input$departments_selected,
             tool %in% input$tool_selected,
             roles %in% input$professions_selected) %>%
      group_by(job_department, tool) %>%
      summarise(sum = sum(count), 
                job_count = sum(count>0), 
                total_word_count = sum(description_word_count),
                total_job_count = length(description_word_count)) %>%
      mutate(proportion_of_jobs = job_count/total_job_count) %>%
      ungroup())

  output$plot <- renderPlot(ggplot(
    data = get_data(),
    aes(x = job_department , y = proportion_of_jobs)) +
    geom_bar(aes(fill = tool), stat="identity", position = "dodge") +
    coord_flip()
  )
}

# Run the app
shinyApp(ui, server)
