submitGAM2015-05-15_164929_Fri.txt
submitGAM2015-05-15_170745_Fri.txt
submitGAM2015-05-15_171133_Fri.txt

dir="c:\\tmp"
setwd(dir)
filename = paste(directory,"\\",ii,".csv",sep="")

files=list.files(path = ".", pattern = ".txt")
lst<-strsplit(files, " ")
tables <- lapply(lst, read.csv)
dfzzz<-do.call(rbind, tables) 
dfzz<-na.omit(dfzzz)

#aggregate(df$WnvPresent,list(df2$Id),mean,data=df2)

#pSubmit<-aggregate(df2$WnvPresent~df2$Id.,FUN=mean,data=df2)

pSubmit<-aggregate(df2$WnvPresent, by=list(dfzz$Id),FUN=mean,data=df2)

colnames(pSubmit)<-c("Id","WnvPresent")


submissionFile<-pSubmit