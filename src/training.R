require(gam)

summary(xtrain.s)

      




library(doMC)
registerDoMC(cores = 5)

#xtest.cimp0[,c("Trap","avg_spray_dist")]

#xtest.imp0<-centralImputation(xtest.c[,c("Trap","Latitude","Longitude","avg_spray_dist")])

#xtest.cc<-merge(x=xtest.imp0[,c("Trap","avg_spray_dist")],y=xtest.c,by=c("Trap"),all.y=TRUE)


pSubmit<-predict(fitCv, newdata = xtest.cc, type = "response")

#pSubmit<-predict(rf_model, newdata = test)
## look at the predicted distribution (AUC doesn't care about probabilities; just ordering. It's still a good diagnostic)

submissionFile<-cbind(xtest.c$Id,pSubmit)
colnames(submissionFile)<-c("Id","WnvPresent")
options("scipen"=100, "digits"=8)
#exetime<-str(Sys.time())
#"%Y-%m-%d %H:%M:%S" 
#format(Sys.time(), "%a_%B_%d_%X_%Y")
exetime<-format(Sys.time(), "%Y-%m-%d_%H_%M_%S_%a")
outdir<-"C:\\Users\\c_kazum\\kaggle2\\chicago_mosq\\west_nile\\output"

outfile=paste(outdir,"\\submitGAM",exetime,".txt",sep="")
write.csv(submissionFile,outfile,row.names=FALSE,quote=FALSE)
xtest.c[xtest.c$Id==32834,]
