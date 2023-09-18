<<<<<<< HEAD
library(bruceR)
library(compareGroups)
rm(list=ls())
gc()
set.wd()

if(!dir.exists('../Res_2_Results/DescriptiveStatRes')){
  dir.create('../Res_2_Results/DescriptiveStatRes')
}


data <- readRDS('../Res_3_IntermediateData/16w_BehavProb_Compact_AgeWinsor.rds')

data$CIER_Flag <- as.numeric(data$CIER_Flag)

data$CIER_Group <- RECODE(data$CIER_Flag,
                          "0='Non-C/IER';
                          1='C/IER';
                          else=NA;")
data$CIER_Group <- factor(data$CIER_Group,
                          levels = c('C/IER',
                                     'Non-C/IER'))

data$AgeMiss_Flag <- as.numeric(data$AgeMiss_Flag )
data$AgeMiss_Flag <- RECODE(data$AgeMiss_Flag,
                          "1='Age Miss';
                          0='Age Without Miss';
                          else=NA;")
data$AgeMiss_Flag <- factor(data$AgeMiss_Flag,
                          levels = c('Age Miss',
                                     'Age Without Miss'))

bivar.T <- compareGroups(CIER_Group~Age_years+AgeMiss_Flag+Gender+StudyPhase+Region_4L+
                          SingleChild+ParentsMaritalStatus_3L+ParentsHighestEdu_2L+
                          RT_TPI+MLS_Sum+IRV_WSum_Z+EOC+MahaD_SQ+
                          BeBully+Bully+Stress_Sum+AcadBO_Sum+IAT_Sum+Anx_Sum+Dep_Sum+
                          SuiciIdea_Sum+SelfInjury_Sum,
                        data,
                        include.miss = TRUE)
demo.T <- createTable(bivar.T, show.n = F, show.ci = F,show.ratio = F)
print(demo.T)
export2xls(demo.T,
           file = '../Res_2_Results/DescriptiveStatRes/DescrTab_CarelessGroup_RPSD.xlsx')
=======
library(bruceR)
library(compareGroups)
rm(list=ls())
gc()
set.wd()

if(!dir.exists('../Res_2_Results/DescriptiveStatRes')){
  dir.create('../Res_2_Results/DescriptiveStatRes')
}


data <- readRDS('../Res_3_IntermediateData/16w_BehavProb_Compact_AgeWinsor.rds')

data$CIER_Flag <- as.numeric(data$CIER_Flag)

data$CIER_Group <- RECODE(data$CIER_Flag,
                          "0='Non-C/IER';
                          1='C/IER';
                          else=NA;")
data$CIER_Group <- factor(data$CIER_Group,
                          levels = c('C/IER',
                                     'Non-C/IER'))

data$AgeMiss_Flag <- as.numeric(data$AgeMiss_Flag )
data$AgeMiss_Flag <- RECODE(data$AgeMiss_Flag,
                          "1='Age Miss';
                          0='Age Without Miss';
                          else=NA;")
data$AgeMiss_Flag <- factor(data$AgeMiss_Flag,
                          levels = c('Age Miss',
                                     'Age Without Miss'))

bivar.T <- compareGroups(CIER_Group~Age_years+AgeMiss_Flag+Gender+StudyPhase+Region_4L+
                          SingleChild+ParentsMaritalStatus_3L+ParentsHighestEdu_2L+
                          RT_TPI+MLS_Sum+IRV_WSum_Z+EOC+MahaD_SQ+
                          BeBully+Bully+Stress_Sum+AcadBO_Sum+IAT_Sum+Anx_Sum+Dep_Sum+
                          SuiciIdea_Sum+SelfInjury_Sum,
                        data,
                        include.miss = TRUE)
demo.T <- createTable(bivar.T, show.n = F, show.ci = F,show.ratio = F)
print(demo.T)
export2xls(demo.T,
           file = '../Res_2_Results/DescriptiveStatRes/DescrTab_CarelessGroup_RPSD.xlsx')
>>>>>>> origin/main
