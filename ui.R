library(shiny)
library(plotly)


ui <- tags$html(
  tags$head(
    tags$title('My first page'),
    tags$link(
      rel = "stylesheet",
      type = "text/css",
      href = "style.css"
    ),
    tags$link(
      rel = "manifest",
      href = "manifest.json"
    ),
    tags$script(src = "js/app.js")),
    tags$body(
      # ------------- HEADER ------------
      div(id = "Header", 
          img(src="heart.png"),h1("Heart Attack Dataset Dashboard")),
      # ------------- DEMOGRAPHIC ------------
      div(id = "demographic",
          div(id = "maps",
              h2("Demographics"),
              HTML("<hr>"),
              h3("Number of people who had heart attack in different states"),
              plotlyOutput("mymap")
          ),
          h3("Correlation of other demographics factor with heart attack"),
          selectInput("demoinput", "Select:", list(Sex = "Sex",
                                                 RaceEthinicity = "RaceEthnicityCategory",
                                                 AgeCategory = "AgeCategory")),
          plotOutput("demooutput")
      ),
      # ------------- GENERAL HEALTH ------------
      div(id = "general-health",
          h2("General Health Impact on Heart Attack"),
          HTML("<hr>"),
          selectInput("geninput", "Select:", list(GeneralHealth = "GeneralHealth",
                                                  PhysicalActivities = "PhysicalActivities")),
          plotOutput("genoutput")
      ),
      # ------------- DISEASE ------------
      div(id = "disease",
          h2("How Disease related to Heart Attack"),
          HTML("<hr>"),
          plotOutput(outputId = "dGraph1"),
          plotOutput(outputId = "dGraph2")
      )
    )
)