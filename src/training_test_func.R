x=xtrain.y
library(doMC)
registerDoMC(cores = 5)
train<-dflist$strain
test<-dflist$test
fitrf<-fitCv
library(adabag)
library(ada)
library(gbm)
library(gam)

getresult<-function(train,test,ttype,outdir="c\\tmp"){

  #x=train
  if(ttype=="gam"){
fitCv = gam(WnvPresent ~ s(dWeek) + Species2 + lo(Latitude, Longitude)   ,    data = train, family="binomial")

pSubmit<-predict(fitCv, newdata = test, type = "response")

}
else if (ttype=="rf"){
  
  fitCv <- train(WnvPresent ~ ., data = train, method = "rf")
  pSubmit<-predict(fitCv, newdata = test)
  
}
else if (ttype=="ada"){
  gbm_algorithm <- gbm(WnvPresent~ ., data = train, distribution = "adaboost", n.trees = 5000)
  
  #gbm_predicted <- predict(gbm_algorithm, test, n.trees = 5000)  
  pSubmit<-predict(gbm_algorithm, test, n.trees = 5000, type = 'response')

}

#p2<-predict(rf_model, newdata = x2, type = "response")
## check for a reasonable AUC of the model against unseen data (2011)
#library(AUC)
#auc(x2$WnvPresent,p2)

## now fit a new model to all the data, so that our final submission includes information learned from 2011 as well
#fitSubmit <- update(fitCv, data=my.x)
#pSubmit<-predict(rf_model, newdata = test)
## look at the predicted distribution (AUC doesn't care about probabilities; just ordering. It's still a good diagnostic)
#summary(pSubmit)

submissionFile<-cbind(test$Id,pSubmit)
colnames(submissionFile)<-c("Id","WnvPresent")
options("scipen"=100, "digits"=8)
#exetime<-str(Sys.time())
#"%Y-%m-%d %H:%M:%S" 
#format(Sys.time(), "%a_%B_%d_%X_%Y")
exetime<-format(Sys.time(), "%Y-%m-%d_%H%M%S_%a")
outfile=paste(outdir,"\\submitGAM",exetime,".txt",sep="")
write.csv(submissionFile,outfile,row.names=FALSE,quote=FALSE)
}
outdir="c:\\tmp"
getresult(dflist$strain,dflist$test,"rf")