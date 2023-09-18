library(bruceR)
rm(list=ls())
gc()
set.wd()

data <- readRDS('../Res_3_IntermediateData/181w_recoded_QC_listwiseDemo.rds')
data <- select(data,c(Gender,Grade,StudyPhase,CIER_Flag,Region_4L,
                      BeBully,Bully,
                      Stress_Sum,AcadBO_Sum,IAT_Sum,Anx_Sum,Dep_Sum,
                      SuiciIdea_Sum,SelfInjury_Sum))
data <- subset(data,Grade != '3TH GRADE')
data$Grade <- droplevels(data$Grade,'3TH GRADE')
# Dummy Coding ------------------------------------------------------------
data <- mltools::one_hot(data,cols = c('Gender','StudyPhase'))
data$Grade <- as.numeric(data$Grade)
data$CIER_Flag <- as.numeric(data$CIER_Flag) - 2
data$CIER_Flag[data$CIER_Flag==-1] = 1

data$Depression_Label <- as.numeric(data$Dep_Sum >= 16)
data$SuiciIdea_Label <- as.numeric(data$SuiciIdea_Sum >= 43)

# Min-max Normalization ---------------------------------------------------
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

saveRDS(data,'../Res_3_IntermediateData/181w_MLdata_prepared.rds')
fwrite(data,file = '../Res_3_IntermediateData/181w_MLdata_prepared.csv')
