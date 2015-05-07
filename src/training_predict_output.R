
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