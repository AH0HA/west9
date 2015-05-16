library(caret)
library(Metrics)
library(data.table)  


library(caret)

data_dir <- "C:\\Users\\c_kazum\\kaggle2\\chicago_mosq\\west_nile\\input"
outdir<-"C:\\Users\\c_kazum\\kaggle2\\chicago_mosq\\west_nile\\output"

#start prepData
prepData<-function(data_dir="D:\\kaggle2\\chicago_mosq\\west_nile\\input",infile="train.csv",outfile="test.csv"){
wnv <- read.csv(file.path(data_dir, infile))
twnv<- read.csv(file.path(data_dir, outfile))

x<-wnv
test<-twnv

## prep the species column by moving the test-only UNSPECIFIED CULEX to CULEX ERRATICUS, and re-doing the levels
## logistic regression will complain otherwise
vSpecies<-c(as.character(x$Species),as.character(test$Species))
vSpecies[vSpecies=="UNSPECIFIED CULEX"]<-"CULEX ERRATICUS"
vSpecies[-which(vSpecies == "CULEX PIPIENS" |
                  vSpecies == "CULEX PIPIENS/RESTUANS" |
                  vSpecies == "CULEX RESTUANS")] = "CULEX OTHER"
vSpecies<-factor(vSpecies,levels=unique(vSpecies))

## data.table syntax for adding a column; could overwrite the existing column as well
#x[,Species2:=factor(vSpecies[1:nrow(x)],levels=unique(vSpecies))]
x$Species2=factor(vSpecies[1:nrow(x)],levels=unique(vSpecies))
#test[,Species2:=factor(vSpecies[(nrow(x)+1):length(vSpecies)],levels=unique(vSpecies))]
test$Species2=factor(vSpecies[(nrow(x)+1):length(vSpecies)],levels=unique(vSpecies))

## also add some fields for components of the date using simple substrings
#x[,dMonth:=as.factor(paste(substr(x$Date,6,7)))]
x$dMonth=as.factor(paste(substr(x$Date,6,7)))
#x[,dYear:=as.factor(paste(substr(x$Date,1,4)))]
x$dYear=as.factor(paste(substr(x$Date,1,4)))
x$Date = as.Date(x$Date, format="%Y-%m-%d")
xsDate = as.Date(paste0(x$dYear, "0101"), format="%Y%m%d")
x$dWeek = as.numeric(paste(floor((x$Date - xsDate + 1)/7)))

test$dMonth=as.factor(paste(substr(test$Date,6,7)))
test$dYear=as.factor(paste(substr(test$Date,1,4)))
test$Date = as.Date(test$Date, format="%Y-%m-%d")
tsDate = as.Date(paste0(test$dYear, "0101"), format="%Y%m%d")
test$dWeek = as.numeric(paste(floor((test$Date - tsDate + 1)/7)))

# we'll set aside 2011 data as test, and train on the remaining
my.x = data.frame(x[,c("WnvPresent", "dWeek", "Species2", "Latitude", "Longitude")])



zero<-my.x[my.x$WnvPresent==0,]
one<-my.x[!my.x$WnvPresent==0,]

#trainIndex <- createDataPartition(iris$Species, p = .8,
#                                  list = FALSE,
#                                  times = 1)

zztrainIndex <- createDataPartition(zero$Species2, p = .2,
                                  list = FALSE,
                                  times = 1)

zzTrain <- zero[ zztrainIndex,]
#irisTest  <- iris[-trainIndex,]

strain=rbind(zzTrain,one)

sstrain<-strain[sample(nrow(strain)),]

df<-list("train"=my.x,"test"=test,"aug"=x,"strain"=sstrain)


return (df)
}

#end prepData


