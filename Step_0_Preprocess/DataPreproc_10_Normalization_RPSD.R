library(bruceR)
rm(list=ls())
gc()
set.wd()
data <- readRDS('../Res_3_IntermediateData/16w_MLdata_DummyCoded.rds')
data$Grade <- ( data$Grade - min(data$Grade) )/(max(data$Grade) - min(data$Grade) )

var.ls <- c('BeBully','Bully','Stress_Sum','AcadBO_Sum','IAT_Sum','Anx_Sum',
            'Dep_Sum','SuiciIdea_Sum','SelfInjury_Sum')
dat_prob <- data[,..var.ls]

var.min <- apply(dat_prob,2,min)
var.max <- apply(dat_prob,2,max)

for (i in 1:ncol(dat_prob)){
  dat_prob[[i]] = (dat_prob[[i]] - var.min[[i]]) / (var.max[[i]] - var.min[[i]])
  dat_prob[[i]] = dat_prob[[i]]*1
}
data[,var.ls] <- dat_prob

data$BeBully_Bin <- as.numeric(data$BeBully!=0)
data$Bully_Bin <- as.numeric(data$Bully!=0)


saveRDS(data,'../Res_3_IntermediateData/16w_MLdata_prepared.rds')
fwrite(data,file = '../Res_3_IntermediateData/16w_MLdata_prepared.csv')
