library(leaflet)

step_coord <- 0.0001


shinyUI(fluidPage(
  titlePanel("Sun is Shiny : Impact of a neightbouring building."),
  
  sidebarLayout(
    sidebarPanel(
      fluidRow(
        column(5,
               numericInput("houseLat", "House Latitude", 52.543594,min=0,max=90, step=step_coord)),
        column(5,
               numericInput("houseLon", "House Longitude", 13.374924,min=0,max=90, step=step_coord)),
        column(5,
               numericInput("oppoLat.1", "Opposite building Eastern Latitude", 52.543346,min=0,max=90, step=step_coord)),
        column(5,numericInput("oppoLon.1", "Opposite building Eastern Longitude", 13.374697,min=0,max=90, step=step_coord)),
        column(5,
               numericInput("oppoLat.2", "Opposite building Western Latitude", 52.543464,min=0,max=90, step=step_coord)),
        column(5,numericInput("oppoLon.2", "Opposite building Western Longitude", 13.374266,min=0,max=90, step=step_coord))
        
     ),
      
      checkboxGroupInput("floors", "Floors :",
                         choiceNames = paste('floor.',seq(0,5),sep=''),choiceValues =seq(0,5),  selected = seq(0,5)),
      numericInput( "gesoHeight", "Opposite building height",23,min=0,max=90, step=.5),
      numericInput( "gesoDistance", "Opposite building to House",28,min=0,max=90, step=.5),
      numericInput("floorHeight","House's floor height",  3.2,min=0,max=4, step=.1)
      
    ),
    
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("A propos",  includeMarkdown("include.md")),
                  tabPanel( "Map&Chart", br(),leafletOutput("map"),br(),plotOutput("plot2")),
                  tabPanel("Table", br(),  dataTableOutput('table'))
      )
    ))
))
  