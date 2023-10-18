library(bruceR)
library(officer)
library(compareGroups)
set.wd()
sink('../Res_1_Logs/Log_Table_1.txt',
     type = 'output',
     append = F)
# Table 1. ----------------------------------------------------------------

 
RPSD = import('../Res_3_IntermediateData/16w_BehavProb_Compact_AgeWinsor.rds')
OOSD = import('../Res_3_IntermediateData/181w_recoded_QC_listwiseDemo.rds')

RPSD %>% 
  select(
    c(Gender,StudyPhase,Region_4L,
      CIER_Flag,IRV_Num,EOC,MahaD_SQ,
      ends_with('Sum'),
      Bully,BeBully)) -> RPSD
RPSD$CIER_Flag <- as.numeric(RPSD$CIER_Flag)

RPSD$CIER_Flag <- RECODE(RPSD$CIER_Flag,
                             "0='Non-C/IER';
                          1='C/IER';
                          else=NA;")
RPSD$CIER_Flag <- factor(RPSD$CIER_Flag,
                             levels = c('C/IER',
                                        'Non-C/IER'))
OOSD %>%
  select(
    c(Gender,StudyPhase,Region_4L,
      CIER_Flag,IRV_Num,EOC,MahaD_SQ,
      ends_with('Sum'),
      Bully,BeBully)) -> OOSD
RPSD$SampleType <- 'Internal Sample'
OOSD$SampleType <- 'External Sample'
all.dat = rbind(RPSD,OOSD)

all.dat$StudyPhase <- forcats::fct_recode(all.dat$StudyPhase,
                                          `Primary School` = "Primary Education",
                                          `Middle School` = "Junior Secondary Education",
                                          `High School` = "Senior Secondary Education")
all.dat$Region_4L <- forcats::fct_relabel(all.dat$Region_4L,
                                          function(.) stringr::str_replace_all(.,'Region','China'))

all.dat$Dep_Sum %>% RECODE("lo:15 = 'Negative';
                            16:hi = 'Positive';") %>%
  factor(levels = c('Positive','Negative')) -> all.dat$Dep_Bin
all.dat$SuiciIdea_Sum %>% RECODE("lo:42 = 'Negative';
                            43:hi = 'Positive';") %>%
  factor(levels = c('Positive','Negative')) -> all.dat$SuiciIdea_Bin
all.dat$BeBully %>%
  RECODE("1 = 'No';
         2:5 = 'Yes';") %>%
  factor(levels = c('Yes','No')) -> all.dat$BeBully_Bin
all.dat$Bully %>%
  RECODE("1 = 'No';
         2:5 = 'Yes';") %>%
  factor(levels = c('Yes','No')) -> all.dat$Bully_Bin
all.dat$SampleType %>%
  factor(levels = c('Internal Sample','External Sample')) -> all.dat$SampleType

all.dat %>% rename(
  `Biological Sex` = Gender,
  `Educational Stage` = StudyPhase,
  `Geographic Area` = Region_4L,
  `C/IER Flag` = CIER_Flag,
  `Weighted Itra-Individual Variance` = IRV_WSum,
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
  `Being Bullied` = BeBully_Bin) -> all.dat

export(all.dat,'../Res_3_IntermediateData/197w_RPSD_OOSD_KeyVars.rda')

bivar.T <- compareGroups(SampleType~`Biological Sex`+
                           `Educational Stage`+
                           `Geographic Area`+
                           `C/IER Flag`+
                           `Weighted Itra-Individual Variance`+
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
                         data = all.dat,
                         method = NA,
                         include.miss = F)
demo.T <- createTable(bivar.T, 
                      show.n = F, show.ci = F,show.ratio = F,
                      digits = 2)

print(demo.T,
      header.labels = c(p.overall = 'p'))
export(demo.T,'../Res_2_Results/DescriptiveStatRes/Res_DemoCompare_RPSD_OOSD_T.rds')
export2xls(demo.T,'../Res_2_Results/DescriptiveStatRes/Table_1.xlsx',
           header.labels = c(p.overall = 'p'))
export2word(demo.T,'G:/ProfFang_Data/DataAnalysis_OpenSource_Codes/Res_2_Results/DescriptiveStatRes/Table_1.doc',
           header.labels = c(p.overall = 'p'))
sink()
