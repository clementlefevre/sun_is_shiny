library(lubridate)
library(maptools)

positions.sun <- read.csv('positions_sun_berlin.csv')
positions.sun$date <- as.POSIXct(positions.sun$date)
start.date <- min(positions.sun$date)
end.date <- max(positions.sun$date)

print (start.date)
print(end.date)

## convert to degrees
positions.sun$sun.altitude <- positions.sun$altitude*180/pi
positions.sun$sun.azimuth <- positions.sun$azimuth*180/pi

distance.geso.gericht15 <- 28
oppoBuildingHeight <- 23
floor.height <- 3.2

## compute height of a given floor
get.height.floor <- function(floor,gesoHeight,floorHeight){
  return (gesoHeight-floor*floorHeight)
}

## compute 
geso.altitude.degrees.from.floor <-  function(floor,gesoDistance,gesoHeight,floorHeight){
  floor.height.meter <- get.height.floor(floor,gesoHeight,floorHeight)
  
  height.geso.degrees <- (atan(floor.height.meter/gesoDistance))*180/pi
  
  return (height.geso.degrees)
}

getAzimuthToOppositeBuilding <- function(buildingLat,
                                         buildingLon,
                                         oppoBuildingLat.1,
                                         oppoBuildingLon.1,
                                         oppoBuildingLat.2,
                                         oppoBuildingLon.2){
  
  name <- c("building","oppoBuilding.1","oppoBuilding.2")
  lat <- c(buildingLat,
           oppoBuildingLat.1,
           oppoBuildingLat.2)
  long <- c(buildingLon,
            oppoBuildingLon.1,
            oppoBuildingLon.2)
  
  x <- cbind(long, lat)
  row.names(x) <- name
  
  r1 <- gzAzimuth(x[1:3,], x[1,])
  
  return (r1)
}

computeShadow <- function(windowLat,
                          windowLon,
                          oppoLat.1,
                          oppoLon.1,
                          oppoLat.2,
                          oppoLon.2,
                          floors,
                          gesoDistance,
                          gesoHeight,
                          floorHeight){
  
  azimuth <-getAzimuthToOppositeBuilding(windowLat,windowLon,oppoLat.1,oppoLon.1,oppoLat.2,oppoLon.2)
  gesoEast.azimuth <- azimuth[2]
  gesoWest.azimuth <- azimuth[3]
  
  for (floor in floors){
    floor <- as.numeric(floor)
    positions.sun[,paste0('floor.',as.character(floor))] <- ifelse(positions.sun$sun.azimuth>=gesoEast.azimuth & 
                                                                     positions.sun$sun.azimuth<=gesoWest.azimuth &
                                                                     positions.sun$sun.altitude<geso.altitude.degrees.from.floor(floor,gesoDistance,gesoHeight,floorHeight),
                                                                   1,0)
  }
  

  gato <- positions.sun %>% select(date, paste('floor',floors,sep='.')) %>% gather(key,value,-date)
  gato <-gato %>% group_by(dato=date(date),key,value) %>% dplyr::summarise(start= min(date), end= max(date))
  gato$duration.shadow.minutes <- (gato$end - gato$start)/60
  gato <- gato %>% filter(value==1)
  
  return (gato)
  
}

