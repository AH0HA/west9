
library(caret)
library(Metrics)
library(data.table)   ## load data in quickly with fread
#C:\\Users\\c_kazum\\kaggle2\\chicago_mosq\\west_nile\\input
#x <- fread("C:\\Users\\c_kazum\\kaggle2\\chicago_mosq\\west_nile\\input\\train.csv")
x <- read.csv("C:\\Users\\c_kazum\\kaggle2\\chicago_mosq\\west_nile\\input\\train.csv")
test <- fread("C:\\Users\\c_kazum\\kaggle2\\chicago_mosq\\west_nile\\input\\test.csv")



data_dir <- "C:\\Users\\c_kazum\\kaggle2\\chicago_mosq\\west_nile\\input"
outdir<-"C:\\Users\\c_kazum\\kaggle2\\chicago_mosq\\west_nile\\output"
wnv <- read.csv(file.path(data_dir, "train.csv"))
twnv<- read.csv(file.path(data_dir, "test.csv"))

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
x1<-my.x[x$dYear!=2011,]
x2<-my.x[x$dYear==2011,]

#parallel random forest start
#library(doMC)
library(foreach)

rfParam <- expand.grid(mtry=3, importance=TRUE)

#m <- train(x, y, method="parRF", tuneGrid=rfParam)
#registerDoMC(cores = 5)
## All subsequent models are then run in parallel
fitrf <- train(WnvPresent ~ dWeek + Species2 + Latitude+Longitude,
               data = x1, method = "parRF", tuneGrid=rfParam,)
 
rf_model<-train(WnvPresent ~ .,data=my.x,method="rf",
                trControl=trainControl(method="cv",number=10),
                prox=TRUE,allowParallel=TRUE)

#parallel random forest end


## GAM modelling
require(gam)
fitCv = gam(WnvPresent ~ s(dWeek) + Species2 + lo(Latitude, Longitude),
           data = x1, family="binomial")
p2<-predict(fitCv, newdata = x2, type = "response")
p2<-predict(rf_model, newdata = x2, type = "response")
## check for a reasonable AUC of the model against unseen data (2011)
library(AUC)
auc(x2$WnvPresent,p2)

## now fit a new model to all the data, so that our final submission includes information learned from 2011 as well
fitSubmit <- update(fitCv, data=my.x)
pSubmit<-predict(fitSubmit, newdata = test, type = "response")
pSubmit<-predict(rf_model, newdata = test)
## look at the predicted distribution (AUC doesn't care about probabilities; just ordering. It's still a good diagnostic)
summary(pSubmit)

submissionFile<-cbind(test$Id,pSubmit)
colnames(submissionFile)<-c("Id","WnvPresent")
options("scipen"=100, "digits"=8)
#exetime<-str(Sys.time())
#"%Y-%m-%d %H:%M:%S" 
#format(Sys.time(), "%a_%B_%d_%X_%Y")
exetime<-format(Sys.time(), "%Y-%m-%d_%H:%M:%S_%a")
outfile=paste(outdir,"\\submitGAM",exetime,".txt",sep="")
write.csv(submissionFile,"C:\\Users\\c_kazum\\kaggle2\\chicago_mosq\\west_nile\\output\\submitGAM.csv",row.names=FALSE,quote=FALSE)
