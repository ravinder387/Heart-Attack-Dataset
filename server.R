library(shiny)
library(plotly)
library(dplyr)
library(gridExtra)
library(tidyr)

dataset <- read.csv("heart_2022.csv")
diabetes <- read.csv("diabetes.csv")
dd <- read.csv("disease.csv")
dis <- gather(dd, "HeartAttack", "n", 2:3)

g1 <- ggplot(filter(dis, disease == "HadAgnina")[,2:3], aes(x="", y=n, fill=HeartAttack)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0) +
  ggtitle("People who had Angnina") +
  theme(
    plot.background = element_rect(fill = "#e3cece"),
    text = element_text(size=14)
  )

g2 <- ggplot(filter(dis, disease == "depression")[,2:3], aes(x="", y=n, fill=HeartAttack)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0) +
  ggtitle("People who had Depression") +
  theme(
    plot.background = element_rect(fill = "#e3cece"),
    text = element_text(size=14)
  )

g3 <- ggplot(filter(dis, disease == "COPD")[,2:3], aes(x="", y=n, fill=HeartAttack)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0) +
  ggtitle("People who had COPD") +
  theme(
    plot.background = element_rect(fill = "#e3cece"),
    text = element_text(size=14)
  )

g4 <- ggplot(filter(dis, disease == "kidney-disease")[,2:3], aes(x="", y=n, fill=HeartAttack)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0) +
  ggtitle("People who had Kidney disease") +
  theme(
    plot.background = element_rect(fill = "#e3cece"),
    text = element_text(size=14)
  )

g5 <- ggplot(filter(dis, disease == "skin-cancer")[,2:3], aes(x="", y=n, fill=HeartAttack)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0) +
  ggtitle("People who had Skin cancer") +
  theme(
    plot.background = element_rect(fill = "#e3cece"),
    text = element_text(size=14)
  )

df <- read.csv("demographic.csv")
df$hover <- with(df, paste(df$State))
# give state boundaries a white border
l <- list(color = toRGB("white"), width = 2)
# specify some map projection/options
g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  showlakes = TRUE,
  lakecolor = toRGB('white')
)
fig <- plot_geo(df, locationmode = 'USA-states')
fig <- fig %>% add_trace(
  z = ~sum, text = ~hover, locations = ~code,
  color = ~sum, colors =  'YlGnBu'
)
fig <- fig %>% colorbar(title = "heart attack")
fig <- fig %>% layout(
  title = 'How many people had heart attack in different States',
  geo = g
) |> 
  layout(paper_bgcolor = "#e3cece")

server <- function(input, output){
  output$mymap <- renderPlotly({
    fig
  })
  
  output$demooutput <- renderPlot({
    ggplot(dataset, aes(x = .data[[input$demoinput]],fill = "HadHeartAttack")) +
      geom_bar() +
      labs(fill = "Heart Attack") + 
      theme(
        panel.background = element_rect(fill = "#e3cece"),
        plot.background = element_rect(fill = "#e3cece")
      )
  })
  
  output$genoutput <- renderPlot({
    ggplot(dataset, aes(x = .data[[input$geninput]],fill = "HadHeartAttack")) +
      geom_bar() +
      labs(fill = "Heart Attack") + 
      theme(
        panel.background = element_rect(fill = "#e3cece"),
        plot.background = element_rect(fill = "#e3cece")
      )
  })
  
  output$dGraph1 <- 
    renderPlot({
      ggplot(data=diabetes, aes(x=x, y=sum, group=1)) +
        geom_line(color="green",linewidth=1)+
        geom_point() +
        theme(
          panel.background = element_rect(fill = "#e3cece"),
          plot.background = element_rect(fill = "#e3cece")
        )
    })
  
  output$dGraph2 <- 
    renderPlot({
       gg <- cowplot::ggdraw(grid.arrange(g1,g2,g3,g4,g5, ncol=3)) + 
        theme(plot.background = element_rect(fill="#e3cece", color = NA))
      
      # check the plot
      plot(gg)
        })
}