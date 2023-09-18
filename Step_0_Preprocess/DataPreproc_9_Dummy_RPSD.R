library(bruceR)
set.wd()

data <- readRDS('../Res_3_IntermediateData/16w_BehavProb_Compact_AgeWinsor.rds')
data <- select(data,c(Gender,Grade,StudyPhase,CIER_Flag,
                      BeBully,Bully,
                      Stress_Sum,AcadBO_Sum,IAT_Sum,Anx_Sum,Dep_Sum,
                      SuiciIdea_Sum,SelfInjury_Sum))

dat <- mltools::one_hot(data,cols = c('Gender','StudyPhase'))
dat$Grade <- as.numeric(dat$Grade)
dat$CIER_Flag <- as.numeric(data$CIER_Flag)

dat$Depression_Label <- as.numeric(dat$Dep_Sum >= 16)
dat$SuiciIdea_Label <- as.numeric(dat$SuiciIdea_Sum >= 43)

saveRDS(dat,'../Res_3_IntermediateData/16w_MLdata_DummyCoded.rds')