set.seed(12234)
library(caret)


xtest_s = data.frame(xtest[,c( "dWeek"     , "Species2" ,  "Latitude" ,  "Longitude" ,"avg_spray_dist")])

#Articifially make some values NA
train$capAve<-train$capitalAve # Make a copy
selectNA<-rbinom(dim(train)[1], size=1, prob=0.05)==1
train$capAve[selectNA]<-NA

length(xtest_s[which(is.na(xtest_s$avg_spray_dist)),])

xtest.imp=data.frame(xtest[,c( "Latitude", "Longitude","avg_spray_dist")])

xtest_s[which(is.na(xtest_s$avg_spray_dist)),]

library(DMwR)
dim(xtest.imp2)
summary(xtest_s)

# Impute and standardize missing values
pre<-preProcess(train[,-c("")], method='knnImpute')
pre<-preProcess(xtest_s[,-2], method='knnImpute')

#install.packages("Amelia")
library(RANN)

avg_spray_dist<-predict(pre, xtest_s[,-2])$avg_spray_dist

# Standardize true values
tmp<-train$capitalAve
capAveTruth<-(tmp - mean(tmp)) / sd(tmp)

# Inspect the results
quantile(capAve - capAveTruth)

xtest_imp3<-merge(x=xtest[,-16],y=xtest.imp2,by=c("Latitude","Longitude"),all.x=TRUE)
