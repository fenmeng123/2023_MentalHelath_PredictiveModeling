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
data$Dep_Sum %>% RECODE("lo:15 = 'Negative';
                            16:hi = 'Positive';") %>%
  factor(levels = c('Positive','Negative')) -> data$Dep_Bin
data$SuiciIdea_Sum %>% RECODE("lo:42 = 'Negative';
                            43:hi = 'Positive';") %>%
  factor(levels = c('Positive','Negative')) -> data$SuiciIdea_Bin
data$BeBully %>%
  RECODE("1 = 'No';
         2:5 = 'Yes';") %>%
  factor(levels = c('Yes','No')) -> data$BeBully_Bin
data$Bully %>%
  RECODE("1 = 'No';
         2:5 = 'Yes';") %>%
  factor(levels = c('Yes','No')) -> data$Bully_Bin
data$StudyPhase <- forcats::fct_recode(data$StudyPhase,
                                          `Primary School` = "Primary Education",
                                          `Middle School` = "Junior Secondary Education",
                                          `High School` = "Senior Secondary Education")
data$Region_4L <- forcats::fct_relabel(data$Region_4L,
                                          function(.) stringr::str_replace_all(.,'Region','China'))
data %>% rename(
  `Biological Sex` = Gender,
  `Educational Stage` = StudyPhase,
  `Geographic Area` = Region_4L,
  `C/IER Flag` = CIER_Flag,
  `Summed Itra-Individual Variance` = IRV_WSum,
  `No. IRV=0` = IRV_Num,
  `Summed Max Longstring` = MLS_Sum,
  `Even-Odd Consistence Index` = EOC,
  `Squared Mahalanobis Distance` = MahaD_SQ,
  `Depression Problem` = Dep_Bin,
  `Depression` = Dep_Sum,
  `Suicidal Ideation Problem` = SuiciIdea_Bin,
  `Suicidal Ideation` = SuiciIdea_Sum,
  `Stress` = Stress_Sum,
  `Academic Burn-out` = AcadBO_Sum,
  `Internet Addiction` = IAT_Sum,
  `Anxiety` = Anx_Sum,
  `Non-suicidal Self-injury` = SelfInjury_Sum,
  `Bullying` = Bully_Bin,
  `Being Bullied` = BeBully_Bin) -> data

export(data,'../Res_3_IntermediateData/16w_BehavProb_Compact_AgeWinsor_rename.rda')

bivar.T <- compareGroups(CIER_Group~`Biological Sex`+
                           `Educational Stage`+
                           `Geographic Area`+
                           `Summed Itra-Individual Variance`+
                           `Summed Max Longstring`+
                           `Even-Odd Consistence Index`+
                           `Squared Mahalanobis Distance`+
                           `Depression Problem`+`Suicidal Ideation Problem`+
                           `Depression`+
                           `Suicidal Ideation`+
                           `Stress`+
                           `Academic Burn-out`+
                           `Internet Addiction`+
                           `Anxiety`+
                           `Non-suicidal Self-injury`+
                           `Bullying`+
                           `Being Bullied`,
                         data = data,
                         include.miss = F)

demo.T <- createTable(bivar.T, 
                      show.n = F, show.ci = F,show.ratio = F,
                      digits = 2)
print(demo.T)
export2xls(demo.T,
           file = '../Res_2_Results/DescriptiveStatRes/DescrTab_CarelessGroup_RPSD.xlsx',
           header.labels = c(p.overall = 'p'))
export2word(demo.T,
           file = 'G:/ProfFang_Data/DataAnalysis_OpenSource_Codes/Res_2_Results/DescriptiveStatRes/DescrTab_CarelessGroup_RPSD.doc',
           header.labels = c(p.overall = 'p'))