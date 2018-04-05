library(suncalc)


create.sun.position <- function(cityname, lat,lon,timestep='5 min'){
  
  ## create a year time interval 
  z <- seq.POSIXt(as.POSIXct(ymd(20180701)), as.POSIXct(ymd(20190630)), by = timestep)
  
  ## compute sun altitude and azimuth in radians for each datetime
  positions.sun <- getSunlightPosition(date = z,lat = lat, lon = lon)
  
  ## convert radians to degrees
  positions.sun$sun.altitude <- positions.sun$altitude*180/pi
  positions.sun$sun.azimuth <- positions.sun$azimuth*180/pi
  
  write.csv(positions.sun,paste0("positions_sun_",cityname,".csv"))
  
}
