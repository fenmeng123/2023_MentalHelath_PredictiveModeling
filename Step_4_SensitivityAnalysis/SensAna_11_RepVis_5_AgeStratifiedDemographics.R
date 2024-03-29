library(bruceR)
# library(compareGroups)
library(forcats)
set.wd()

fprintf <- function(STR,...){
  cat(
    sprintf(STR,...)
  )
}

# Generate Age Stratified Descriptive Statistics Table --------------------


CountsAgeGroups <- function(dat){
  concat_num_prop <- function(num, prop, total) {
    prop_percent <- round(prop*100, 2)  # 计算百分比
    str_c(num, " (", prop_percent, "%)")  # 拼接字符串
  }
  
  concat_mean_sd <- function(mean, sd) {
    str_c(round(mean, 2), " (", round(sd, 2), ")")  # 拼接字符串
  }
  
dat_summarised <-  dat %>%
    group_by(Age) %>%
    summarise(
      Total = n(), 
      Boys_Num = sum(Gender_Boy),
      Boys_Prop = Boys_Num / Total ,
      Girls_Num = sum(Gender_Girl),
      Girls_Prop = Girls_Num / Total,
      Region_East_Num = sum(str_detect(Region_4L,"Eastern")),
      Region_NorE_Num = sum(str_detect(Region_4L,"Northeast")),
      Region_Cent_Num = sum(str_detect(Region_4L,"Central")),
      Region_West_Num = sum(str_detect(Region_4L,"Western")),
      Region_East_Prop = Region_East_Num / Total,
      Region_NorE_Prop = Region_NorE_Num / Total,
      Region_Cent_Prop = Region_Cent_Num / Total,
      Region_West_Prop = Region_West_Num / Total,
      SP_Primary_Num = sum(`StudyPhase_Primary Education`),
      SP_Primary_Prop = SP_Primary_Num / Total,
      SP_Middle_Num = sum(`StudyPhase_Junior Secondary Education`),
      SP_Middle_Prop = SP_Middle_Num / Total,
      SP_High_Num = sum(`StudyPhase_Senior Secondary Education`),
      SP_High_Prop = SP_High_Num / Total,
      CIER_Yes_Num = sum(CIER_Flag),
      CIER_Yes_Prop = CIER_Yes_Num / Total,
      CIER_No_Num = sum(!CIER_Flag),
      CIER_No_Prop = CIER_No_Num / Total,
      Dep_Pos_Num = sum(Depression_Label),
      Dep_Pos_Prop = Dep_Pos_Num / Total,
      Dep_Neg_Num = sum(!Depression_Label),
      Dep_Neg_Prop = Dep_Neg_Num / Total,
      Suicide_Pos_Num = sum(SuiciIdea_Label),
      Suicide_Pos_Prop = Suicide_Pos_Num / Total,
      Suicide_Neg_Num = sum(!SuiciIdea_Label),
      Suicide_Neg_Prop = Suicide_Neg_Num / Total,
      Dep_Num = sum(Depression_Label),
      Dep_Prop = Dep_Num/Total,
      Sui_Num = sum(SuiciIdea_Label),
      Sui_Prop = Sui_Num/Total,
      Depression_M = mean(Dep_Sum),
      Depression_SD = sd(Dep_Sum),
      `Suicidal Ideation_M` = mean(SuiciIdea_Sum),
      `Suicidal Ideation_SD` = sd(SuiciIdea_Sum),
      Stress_M = mean(Stress_Sum),
      Stress_SD = sd(Stress_Sum),
      `Academic Burn-out_M` = mean(AcadBO_Sum),
      `Academic Burn-out_SD` = sd(AcadBO_Sum),
      `Internet Addiction_M` = mean(IAT_Sum),
      `Internet Addiction_SD` = sd(IAT_Sum),
      Anxiety_M = mean(Anx_Sum),
      Anxiety_SD = sd(Anx_Sum),
      `Non-suicidal Self-injury_M` = mean(SelfInjury_Sum),
      `Non-suicidal Self-injury_SD` = sd(SelfInjury_Sum),
      Bullying_Yes_Num = sum(Bully_Bin),
      Bullying_Yes_Prop = Bullying_Yes_Num/Total,
      Bullying_No_Num = sum(!Bully_Bin),
      Bullying_No_Prop = Bullying_No_Num/Total,
      `Being Bullied_Yes_Num` = sum(BeBully_Bin),
      `Being Bullied_Yes_Prop` = `Being Bullied_Yes_Num`/Total,
      `Being Bullied_No_Num` = sum(!BeBully_Bin),
      `Being Bullied_No_Prop` = `Being Bullied_Yes_Num`/Total,
    ) %>%
    mutate(
      Boys = concat_num_prop(Boys_Num, Boys_Prop, Total),
      Girls = concat_num_prop(Girls_Num, Girls_Prop, Total),
      Region_East = concat_num_prop(Region_East_Num, Region_East_Prop, Total),
      Region_NorE = concat_num_prop(Region_NorE_Num, Region_NorE_Prop, Total),
      Region_Cent = concat_num_prop(Region_Cent_Num, Region_Cent_Prop, Total),
      Region_West = concat_num_prop(Region_West_Num, Region_West_Prop, Total),
      SP_Primary = concat_num_prop(SP_Primary_Num, SP_Primary_Prop, Total),
      SP_Middle = concat_num_prop(SP_Middle_Num, SP_Middle_Prop, Total),
      SP_High = concat_num_prop(SP_High_Num, SP_High_Prop, Total),
      CIER_Yes = concat_num_prop(CIER_Yes_Num, CIER_Yes_Prop, Total),
      CIER_No = concat_num_prop(CIER_No_Num, CIER_No_Prop, Total),
      Dep_Pos = concat_num_prop(Dep_Pos_Num,Dep_Pos_Prop,Total),
      Dep_Neg = concat_num_prop(Dep_Neg_Num,Dep_Neg_Prop,Total),
      SuiciIdea_Pos = concat_num_prop(Suicide_Pos_Num,Suicide_Pos_Prop,Total),
      SuiciIdea_Neg = concat_num_prop(Suicide_Neg_Num,Suicide_Neg_Prop,Total),
      Depression = concat_mean_sd(Depression_M, Depression_SD),
      `Suicidal Ideation` = concat_mean_sd(`Suicidal Ideation_M`, `Suicidal Ideation_SD`),
      Stress = concat_mean_sd(Stress_M, Stress_SD),
      `Academic Burn-out` = concat_mean_sd(`Academic Burn-out_M`, `Academic Burn-out_SD`),
      `Internet Addiction` = concat_mean_sd(`Internet Addiction_M`, `Internet Addiction_SD`),
      Anxiety = concat_mean_sd(Anxiety_M, Anxiety_SD),
      `Non-suicidal Self-injury` = concat_mean_sd(`Non-suicidal Self-injury_M`, `Non-suicidal Self-injury_SD`),
      Bullying_Yes = concat_num_prop(Bullying_Yes_Num,Bullying_Yes_Prop, Total),
      Bullying_No = concat_num_prop(Bullying_No_Num,Bullying_No_Prop, Total),
      `Being Bullied_Yes` = concat_num_prop(`Being Bullied_Yes_Num`,`Being Bullied_Yes_Prop`, Total),
      `Being Bullied_No` = concat_num_prop(`Being Bullied_No_Num`,`Being Bullied_No_Prop`, Total),
    ) %>%
    select(Age, Boys, Girls, Region_East, Region_NorE, Region_Cent, Region_West,
           SP_Primary, SP_Middle, SP_High, CIER_Yes, CIER_No,
           Dep_Pos,Dep_Neg,SuiciIdea_Pos,SuiciIdea_Neg,
           Depression, `Suicidal Ideation`,
           Stress, `Academic Burn-out`, `Internet Addiction`, Anxiety, `Non-suicidal Self-injury`,
           Bullying_Yes,Bullying_No,`Being Bullied_Yes`,`Being Bullied_No`) %>%
    t() %>%
    as.data.frame()
  
  print(dat_summarised)
  return(dat_summarised)
}

RecoveryRawData <- function(dat){
  dat$Age <- sprintf("%d-%d",
                     dat$Grade*8+9,dat$Grade*8+10) %>%
    factor(levels = c("9-10","10-11","11-12","12-13",
                      "13-14","14-15","15-16","16-17",
                      "17-18"))
  
  dat$StudyPhase <- NA
  dat$StudyPhase[dat$`StudyPhase_Primary Education` == 1] <- "Primary School"
  dat$StudyPhase[dat$`StudyPhase_Junior Secondary Education` == 1] <- "Middle School"
  dat$StudyPhase[dat$`StudyPhase_Senior Secondary Education` == 1] <- "High School"
  dat$StudyPhase <- dat$StudyPhase %>%
    factor(levels = c("Primary School",
                      "Middle School",
                      "High School"))
  
  dat$Gender <- NA
  dat$Gender[dat$Gender_Boy == 1] <- "Boy"
  dat$Gender[dat$Gender_Girl == 1] <- "Girl"
  dat$Gender <- dat$Gender %>%
    factor(levels = c("Girl","Boy"))
  
  dat$Dep_Sum <- dat$Dep_Sum * (30 - 0) + 0
  dat$SuiciIdea_Sum <- dat$SuiciIdea_Sum * (70 - 14) + 14
  dat$Stress_Sum <- dat$Stress_Sum * (56 - 0) + 0
  dat$AcadBO_Sum <- dat$AcadBO_Sum * (80 - 16) + 16
  dat$IAT_Sum <- dat$IAT_Sum * (100 - 20) + 20
  dat$Anx_Sum <- dat$Anx_Sum * (100 - 25) + 25
  dat$SelfInjury_Sum <- dat$SelfInjury_Sum * (54 - 0) + 0
  return(dat)
}



data_16w <- import(file = "../Res_3_IntermediateData/16w_data_for_SensAna.csv") %>%
  RecoveryRawData()
data_181w <- import(file = "../Res_3_IntermediateData/181w_data_for_SensAna.csv") %>%
  RecoveryRawData()

data_16w %>%
  CountsAgeGroups() %>%
  print_table(digits = 2,
              row.names = T,
              file = "../Res_2_Results/DescriptiveStatRes/DescrTab_RPSD_AgeInOneYear.doc")


data_181w %>%
  CountsAgeGroups() %>%
  print_table(digits = 2,
              row.names = T,
              file = "../Res_2_Results/DescriptiveStatRes/DescrTab_OOSD_AgeInOneYear.doc")


# Compare Internal and External Sample by COVID19 & Age -------------------------


data_16w$SampleType <- "Internal Sample"
data_181w$SampleType <- "External Sample"
CompT <- rbind(
  select(data_181w,
         c(Age,COVID19_Flag,SampleType)),
  select(data_16w,
         c(Age,COVID19_Flag,SampleType))
) %>%
  compareGroups(SampleType ~ Age + COVID19_Flag,
                                data = .,
                                method = 3) %>%
  createTable(show.n = F, show.ci = F,show.ratio = F,
              digits = 2)
print(CompT)
export2xls(CompT,
           file = '../Res_2_Results/DescriptiveStatRes/DescrTab_Age_COVID19_RPSD_OOSD.xlsx',
           header.labels = c(p.overall = 'p'))


# Generate the Full Table for COVID-19 Comparison -------------------------
COVID19_CompT_RPSD <- data_16w %>%
  compareGroups(COVID19_Flag ~ Age + Gender +  StudyPhase + Region_4L + CIER_Flag +
                  Depression_Label + SuiciIdea_Label + 
                  Dep_Sum + SuiciIdea_Sum + Stress_Sum + AcadBO_Sum + 
                  IAT_Sum + Anx_Sum + SelfInjury_Sum +
                  Bully_Bin + BeBully_Bin,
                data = .,
                method = c(3,3,3,3,3,
                           3,3,
                           1,1,1,1,
                           1,1,1,
                           3,3)) %>%
  createTable(show.n = F, show.ci = F,show.ratio = F,
                      digits = 2)
print(COVID19_CompT_RPSD)
export2xls(COVID19_CompT_RPSD,
           file = '../Res_2_Results/DescriptiveStatRes/DescrTab_DemosByCOVID19_RPSD.xlsx',
           header.labels = c(p.overall = 'p'))


COVID19_CompT_OOSD <- data_181w %>%
  compareGroups(COVID19_Flag ~ Age + Gender +  StudyPhase + Region_4L + CIER_Flag +
                  Depression_Label + SuiciIdea_Label + 
                  Dep_Sum + SuiciIdea_Sum + Stress_Sum + AcadBO_Sum + 
                  IAT_Sum + Anx_Sum + SelfInjury_Sum +
                  Bully_Bin + BeBully_Bin,
                data = .,
                method = c(3,3,3,3,3,
                           3,3,
                           1,1,1,1,
                           1,1,1,
                           3,3)) %>%
  createTable(show.n = F, show.ci = F,show.ratio = F,
              digits = 2)
print(COVID19_CompT_OOSD)
export2xls(COVID19_CompT_OOSD,
           file = '../Res_2_Results/DescriptiveStatRes/DescrTab_DemosByCOVID19_OOSD.xlsx',
           header.labels = c(p.overall = 'p'))



# Deprecated Codes --------------------------------------------------------


# dat$StudyPhase <- NA
# dat$StudyPhase[dat$`StudyPhase_Primary Education` == 1] <- "Primary School"
# dat$StudyPhase[dat$`StudyPhase_Junior Secondary Education` == 1] <- "Middle School"
# dat$StudyPhase[dat$`StudyPhase_Senior Secondary Education` == 1] <- "High School"
# 
# dat$StudyPhase <- dat$StudyPhase %>%
#   factor(levels = c("Primary School",
#                     "Middle School",
#                     "High School"))
# fprintf("|Demographic Table for RPSD, grouped by Age in One year old:      |\n")
# res <- dat %>%
#   compareGroups(Age ~ Gender_Boy + Region_4L + CIER_Flag + StudyPhase + Depression_Label + SuiciIdea_Label,
#                 data = .,
#                 method = 3)
# demo.T <- createTable(res, 
#                       show.n = F, show.ci = F,show.ratio = F,
#                       digits = 2)
# print(demo.T)
# export2xls(demo.T,
#            file = '../Res_2_Results/DescriptiveStatRes/DescrTab_AgeInOneYear_RPSD.xlsx',
#            header.labels = c(p.overall = 'p'))

