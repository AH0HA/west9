#
#https://www.kaggle.com/users/219229/hugom/predict-west-nile-virus/find-the-closest-weather-station
#
library(readr)
library(ggmap)
library(geosphere)

distance <- function(longitude, latitude) {
  
  #Euclidian distances aren't accurate because we are on a sphere
  #dist1 <- sqrt((stations[1,]$Latitude-latitude)^2+(stations[1,]$Longitude-longitude)^2)
  #dist2 <- sqrt((stations[2,]$Latitude-latitude)^2+(stations[2,]$Longitude-longitude)^2)
  
  #Instead, let's use distHaversine from geosphere
  #Haversine distance : http://en.wikipedia.org/wiki/Haversine_formula
  
  dist1 <- distHaversine(c(stations[1,]$Longitude,stations[1,]$Latitude),c(longitude,latitude))
  dist2 <- distHaversine(c(stations[2,]$Longitude,stations[2,]$Latitude),c(longitude,latitude))
  
  
  if(dist1<dist2){
    return(1)
  }
  return(2)
}