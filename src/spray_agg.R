
library(readr)
library(ggmap)
library(geosphere)

data_dir="D:\\kaggle2\\chicago_mosq\\west_nile\\input"
ispray="spray.csv"





tspray<- read.csv(file.path(data_dir, ispray))


library(caret)
set.seed(3456)
trainIndex <- createDataPartition(dflist$aug$WnvPresent, p = .9,
                                  list = FALSE,
                                  times = 1)
head(trainIndex)
Resample1
[1,]         1
[2,]         2
[3,]         4
[4,]         5
[5,]         6
[6,]         8
ssTrain <- dflist$aug[ trainIndex,]
ssTest  <- dflist$aug[-trainIndex,]



#grouped_data <- aggregate(data, by=list(data$column1, data$column2, data$column3), FUN=length);


#grouped_data <- aggregate(tspray, by=list(tspray$Latitude, tspray$Longitude), FUN=length);

names(tspray)
names(dflist$aug)
names(dflist$test)
dflist$aug$Date


which(is.na(tspray$Latitude)|is.na(tspray$Longitude))


#dist1 <- distHaversine(c(stations[1,]$Longitude,stations[1,]$Latitude),c(longitude,latitude))
#dist1 <- distHaversine(c(stations[1,]$Longitude,stations[1,]$Latitude),c(longitude,latitude))
#names(dflist$aug)
#c(dflist$aug$Latitude,dflist$aug$Longitude)

tspray$Date = as.Date(tspray$Date, format="%Y-%m-%d")

total1 <- merge(x=dflist$aug,y=tspray,by="Date",all.x=TRUE)

total1spray<-total1[-which(is.na(total1$Latitude.y)),]

total1spray$spraydist<-distHaversine(as.matrix(total1spray[,c("Latitude.x","Longitude.x")]),as.matrix(total1spray[,c("Latitude.y","Longitude.y")]))

summary(total1spray)

total1spray[total1spray$Trap == 'T001',]

studentdata[studentdata$Drink == 'water',]

avg_spray<- aggregate(total1spray$spraydist, data = total1spray, by=list(total1spray$Trap),FUN=mean)


names(avg_spray) <- c("Trap","avg_spray_dist")

#Outer join: merge(x = df1, y = df2, by = "CustomerId", all = TRUE)

#Left outer: merge(x = df1, y = df2, by = "CustomerId", all.x=TRUE)

#Right outer: merge(x = df1, y = df2, by = "CustomerId", all.y=TRUE)

#Cross join: merge(x = df1, y = df2, by = NULL)

xtrain<-merge(x=dflist$aug,y=avg_spray,by=c("Trap"),all.x=TRUE)

xtrain[,c("Trap","Latitude","Longitude","avg_spray_dist")]

#cleanAlgae <- centralImputation(algae)

#xtrain.imp0[,c("Trap","avg_spray_dist")]

xtrain.imp0<-centralImputation(xtrain[,c("Trap","Latitude","Longitude","avg_spray_dist")])


xtrain.d<-subset(xtrain.imp0,!duplicated(xtrain.imp0$Trap))

xtrain.c<-merge(x=xtrain.d[,c("Trap","avg_spray_dist")],y=dflist$aug,by=c("Trap"),all.y=TRUE)

xtest.c<-merge(x=xtrain.d[,c("Trap","avg_spray_dist")],y=dflist$test,by=c("Trap"),all.y=TRUE)

xtest.imp0<-centralImputation(xtest.c[,c("Trap","Latitude","Longitude","avg_spray_dist")])

xtest.d<-subset(xtest.imp0,!duplicated(xtest.imp0$Trap))

xtest.cc<-merge(x=xtest.d[,c("Trap","avg_spray_dist")],y=xtest.c,by=c("Trap"),all.y=TRUE)


colnames(xtest.cc)[2] <- "avg_spray_dist"

xtrain.s<-xtrain.c[,c(names(dflist$train),"avg_spray_dist")]

xtrain.c[which(!is.na(xtrain.c$avg_spray_dist)),]


library(DMwR)

dim(xtrain[-which(is.na(xtrain$avg_spray)),])

no_spray_dist=xtrain[which(is.na(xtrain$avg_spray)),]

dim(xtrain)

   #distHaversine(c(total1$Latitude.x,total1$Longitude.x),c(total1$Latitude.y,total1$Longitude.y))

#apply(total1, 1,distHaversine(,total1["Longitude.x"])),as.matrix(c(total1["Latitude.y"],total1["Longitude.y"]))) )

names(total1)

total1[,c("Date")=="2011-8-29"]


which(total1$Date=="2013-07-25")

dim(total1)

total1[1:10,]



#distHaversine(c(0,0),c(90,90))

#grouped_data <- aggregate(total1, by=list(total1$Date, total1$Address,total1$Species2), FUN=length);

library(mice)
library(VIM)
library(lattice)
library(ggplot2)


fitm <- with(imp1, lm(y1 ~ y4 + x1))
summary(fitm)


names(dflist$train)
xtrain.imp = data.frame(xtrain[,c("Latitude", "Longitude","avg_spray_dist")])

xtrain_s = data.frame(xtrain[,c("WnvPresent" ,"dWeek"     , "Species2" ,  "Latitude" ,  "Longitude" ,"avg_spray_dist")])
  
#imp1 <- mice(xtrain.imp, m = 5)
imp1 <- mice(xtrain_s, m = 5)

imp1

imp1$imp$avg_spray_dist


require(gam)
fitCv = with(imp1,gam(WnvPresent ~ s(dWeek) + Species2 + lo(Latitude, Longitude)+avg_spray_dist,
             family="binomial"))

xtest<-merge(x=dflist$test,y=avg_spray,by="Address",all.x=TRUE)


imp_tot2 <- complete(imp1, "long", inc = TRUE)


no_spray_dist_pos=xtrain[which(is.na(xtrain$avg_spray)&xtrain$WnvPresent==1),]

no_spray_dist_pos=xtrain[which(is.na(xtrain$avg_spray)&xtrain$WnvPresent==1),]

dim(no_spray_dist_pos)

no_spray_dist=xtrain[which(is.na(xtrain$avg_spray)),]

yes_spray_dist=xtrain[-which(is.na(xtrain$avg_spray)),]

length(which(yes_spray_dist$WnvPresent==1))

length(xtrain$WnvPresent==1)

length(xtrain$WnvPresent==0)

studentdata[studentdata$Drink == 'water',]

dim(yes_spray_dist[yes_spray_dist$WnvPresent ==0 ,])

dim(yes_spray_dist[yes_spray_dist$WnvPresent ==1,])

dim(no_spray_dist[no_spray_dist$WnvPresent ==0 ,])

dim(no_spray_dist[no_spray_dist$WnvPresent ==1,])

dim(no_spray_dist)



length(no_spray_dist_pos$WnvPresent==1)


subset(data,!duplicated(data$ID))

subset(imp_tot2,!duplicated(imp_tot2,by=c("Latitude","Longitude")))

length(which(is.na(imp_tot2$avg_spray)))

length(which(is.na(xtrain$avg_spray)))


xtrain.imp2<-merge(x=dflist$aug,y=imp_tot2,by=c("Latitude","Longitude"),all.x=TRUE)

avg_spray<- aggregate(total1$spraydist, data = total1, by=list(total1$Address),FUN=mean)


