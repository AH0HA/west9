dflist=prepData()
df<-dflist
my.x<-df$train

data_dir="D:\\kaggle2\\chicago_mosq\\west_nile\\input"
inweather="weather.csv"



twet<- read.csv(file.path(data_dir, inweather))
names(twet)

#train 5/29/2007 to 9/26/2013
#test 6/11/2008 to 10/2/2014
#weather 5/1/2007 to 10/31/2014

names(dflist$train)
names(dflist$test)
names(dflist$aug)

dflist$aug$stat1_long = -87.9051
dflist$aug$stat1_lati = 41.9765

dflist$aug$stat1_long = -87.933
dflist$aug$stat1_lati = 41.995

Latitude : 41.9765  Longitude : -87.9051


dflist$aug$stat2_long = -87.752
dflist$aug$stat2_lati = 41.786
Chicago Midway Airport: Latitude: 41.7858658 Longitude: -87.7522764.
dflist$aug$stat2_long = -87.7522764
dflist$aug$stat2_lati = 41.7858658


#dflist$aug$dist1 <- distHaversine(c(dflist$aug$stat1_long,dflist$aug$stat1_lati),c(dflist$aug$Longitude,dflist$aug$Latitude))

dflist$aug$dist1<-distHaversine(as.matrix(dflist$aug[,c("Latitude","Longitude")]),as.matrix(dflist$aug[,c("stat1_long","stat1_lati")]))

dflist$aug$dist2<-distHaversine(as.matrix(dflist$aug[,c("Latitude","Longitude")]),as.matrix(dflist$aug[,c("stat2_long","stat2_lati")]))

big12<-as.matrix(apply(dflist$aug[,c("dist1","dist2")],1,max))
#big12<-as.matrix(big12)


dim(dflist$aug[dflist$aug["dist2"]==big12[,1],])
dim(dflist$aug)
#dflist$aug[which(dflist$aug["dist1"]==big12[,1])]$whichstat<-1

  #Station 1: CHICAGO O'HARE INTERNATIONAL AIRPORT Lat: 41.995 Lon: -87.933 Elev: 662 ft. above sea level
41.9786° N, 87.9047° W
41.9765  Longitude : -87.9051
  #Station 2: CHICAGO MIDWAY INTL ARPT Lat: 41.786 Lon: -87.752 Elev: 612 ft. above sea level


twet2<-twet[twet$Station==1,c("Date","DewPoint","WetBulb")]

twet2$Date = as.Date(twet2$Date, format="%Y-%m-%d")

xtrainx<-merge(x = dflist$aug, y = twet2, by = "Date", x.all = TRUE)

xtrain.y = data.frame(xtrainx[,c("WnvPresent", "dWeek", "Species2", "Latitude", "Longitude","DewPoint","WetBulb")])
xtrain.y[is.na(xtrain.y$DewPoint),]


