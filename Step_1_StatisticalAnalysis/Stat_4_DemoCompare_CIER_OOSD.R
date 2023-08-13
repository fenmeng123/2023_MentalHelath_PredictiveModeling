library(bruceR)
library(compareGroups)
rm(list=ls())
gc()
set.wd()
data <- readRDS('../Res_3_IntermediateData/181w_recoded_QC_listwiseDemo.rds')

data <- subset(data,Grade != '3TH GRADE')
data$Grade <- droplevels(data$Grade,'3TH GRADE')

data$CIER_Group <- data$CIER_Flag

data$CIER_Flag <- as.numeric(data$CIER_Flag)
data$CIER_Flag <- data$CIER_Flag-2
data$CIER_Flag[data$CIER_Flag==-1] <- 1


saveRDS(data,'../Res_3_IntermediateData/179w_recoded_QC.rds')

bivar.T <- compareGroups(CIER_Group~Gender+StudyPhase+Region_4L+
                           MLS_Sum+IRV_WSum_Z+EOC+MahaD_SQ+
                           BeBully+Bully+Stress_Sum+AcadBO_Sum+IAT_Sum+Anx_Sum+Dep_Sum+
                           SuiciIdea_Sum+SelfInjury_Sum,
                         data,
                         include.miss = TRUE)
demo.T <- createTable(bivar.T, show.n = F, show.ci = F,show.ratio = F)
print(demo.T)
export2xls(demo.T,
           file = '../Res_2_Results/DescriptiveStatRes/DescrTab_CarelessGroup_OOSD.xlsx')