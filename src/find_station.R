# Read competition data files:

#Forum topic : https://www.kaggle.com/c/predict-west-nile-virus/forums/t/14019/find-the-closest-weather-station/76993

library(readr)
library(ggmap)
library(geosphere)


distance <- function(longitude, latitude) {
  
  #Euclidian distances aren't accurate because we are on a sphere
  #dist1 <- sqrt((stations[1,]$Latitude-latitude)^2+(stations[1,]$Longitude-longitude)^2)
  #dist2 <- sqrt((stations[2,]$Latitude-latitude)^2+(stations[2,]$Longitude-longitude)^2)
  
  #Instead, let's use distHaversine from geosphere
  #Haversine distance : http://en.wikipedia.org/wiki/Haversine_formula
  
  #dist1 <- distHaversine(c(stations[1,]$Longitude,stations[1,]$Latitude),c(longitude,latitude))
  #dist2 <- distHaversine(c(stations[2,]$Longitude,stations[2,]$Latitude),c(longitude,latitude))
  
  
big12<-as.matrix(apply(dflist$aug[,c("dist1","dist2")],1,max))
big12<-as.matrix(big12)
  

dflist$aug["dist2"]==big12[,1]

mapdata <- readRDS("../input/mapdata_copyright_openstreetmap_contributors.rds")
train <- read.csv("../input/train.csv")

#Station 1: CHICAGO O'HARE INTERNATIONAL AIRPORT Lat: 41.995 Lon: -87.933 Elev: 662 ft. above sea level
#Station 2: CHICAGO MIDWAY INTL ARPT Lat: 41.786 Lon: -87.752 Elev: 612 ft. above sea level

stations<-data.frame(c(1,2),c(41.995,41.786),c(-87.933,-87.752))
names(stations)<-c("Station","Latitude","Longitude")

train$Station<-mapply(distance,train$Longitude,train$Latitude)

#Let's make a plot to see if everything is OK
pl <- ggmap(mapdata)+geom_point(data=train,aes(x=Longitude,y=Latitude,color=factor(Station)))+geom_point(data=stations,aes(x=Longitude, y=Latitude,colour=Station),colour=c("red","green"),size=4)

ggsave("rplot.png", pl, dpi = 100, width = 10, height = 15, units="in")
