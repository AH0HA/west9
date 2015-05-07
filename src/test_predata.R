dflist=prepData()

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


