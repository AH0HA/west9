data_dir="D:\\kaggle2\\chicago_mosq\\west_nile\\input"
ispay="spray.csv"



twet<- read.csv(file.path(data_dir, ispray))


grouped_data <- aggregate(data, by=list(data$column1, data$column2, data$column3), FUN=length);
