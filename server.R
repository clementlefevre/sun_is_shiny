library(leaflet)
library(tidyverse)

source("helpers.R")

server <- function(input, output,session) {
  
  dataShadow  <- reactive({
    computeShadow(input$houseLat,
                  input$houseLon,
                  input$oppoLat.1,
                  input$oppoLon.1,
                  input$oppoLat.2,
                  input$oppoLon.2,
                  input$floors,
                  input$gesoDistance,
                  input$gesoHeight,
                  input$floorHeight)
  })
  
  output$plot2 <- renderPlot({
    ggplot(dataShadow(),aes(dato,as.numeric(duration.shadow.minutes),color=key))+  geom_line()+ theme(plot.title = element_text(size=40), axis.text.y=element_text(size=20),axis.title=element_text(size=15),axis.text.x = element_text(size=15,angle = 90, hjust = 1))+theme(legend.position="bottom",legend.direction="horizontal") +
      theme(legend.title=element_blank())+ylim(0,500)+ ylab("minutes")+ xlab("") +xlim(as.Date("2018-07-01"), as.Date("2019-07-01")) 
  })
  
  output$table <- renderDataTable(dataShadow())
  
  
  output$map <- renderLeaflet({
    
    leaflet() %>% 
      addProviderTiles(providers$OpenStreetMap) %>% 
      setView(lng = input$houseLon, lat = input$houseLat, zoom = 18) %>%
      addMarkers(lng = c(input$houseLon,input$oppoLon.1,input$oppoLon.2),
                 lat = c(input$houseLat,input$oppoLat.1,input$oppoLat.2),
                 popup = c('house','oppo1','oppo2'),
                 options = markerOptions(draggable = TRUE, riseOnHover = TRUE, layerId=c('house','oppo1','oppo2')))   %>%
      addPolylines(lat=c(input$oppoLat.1,input$oppoLat.2),lng=c(input$oppoLon.1,input$oppoLon.2))
    
  })

  observeEvent( input$map_marker_click, {
    
    clicka <- input$map_marker_click
    
    if(clicka$id =='house'){
      updateNumericInput(session, 'houseLat',value=clicka$lat)
      updateNumericInput(session, 'houseLon',value=clicka$lng)
    }
    if(clicka$id =='oppo1'){
      updateNumericInput(session, 'oppoLat.1',value=clicka$lat)
      updateNumericInput(session, 'oppoLon.1',value=clicka$lng)
    }
    
    if(clicka$id =='oppo2'){
      updateNumericInput(session, 'oppoLat.2',value=clicka$lat)
      updateNumericInput(session, 'oppoLon.2',value=clicka$lng)
    }
  })
}
  
  