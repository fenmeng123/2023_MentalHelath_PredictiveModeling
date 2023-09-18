<<<<<<< HEAD
library(bruceR)
library(psych)
set.wd()
rm(list=ls())
gc()

data <- readRDS('../Res_3_IntermediateData/16w_BehavProb_Compact_AgeWinsor.rds')

data <- subset(data,CIER_Flag==F,-c(RT_TPI,MLS_Sum,IRV_WSum_Z,EOC,MahaD_SQ,
                                    RT_Bully,RT_Stress,RT_AcadBO,RT_IAT,
                                    RT_Anx,RT_Dep,RT_SuiciIdea,RT_SelfInjury,
                                    MLS_Stress,MLS_AcadBO,MLS_IAT,MLS_Anx,
                                    MLS_Dep,MLS_SuiciIdea,MLS_SelfInjury,
                                    IRV_Stress,IRV_AcadBO,IRV_IAT,IRV_Anx,
                                    IRV_Dep,IRV_SuiciIdea,IRV_SelfInjury,
                                    IRV_WSum,IRV_Num,RT_BehavioralProblem))


var.ls <- c('Stress_','AcadBO_','IAT_','Anx_','Dep_','SelfInjury_','SuiciIdea_')
item.ls <- list(1:14,1:16,1:20,1:20,1:10,1:9,1:14)

ReliaRes <- data.frame()
for (i in 1:length(var.ls)){
  tmpres <- Alpha(data,var = var.ls[[i]],items = item.ls[[i]])
  
  res <- select(tmpres$alpha$total,-c(std.alpha,ase,mean,sd,median_r))
  res$SCaleName <- str_replace(var.ls[[i]],'_','')
  res$raw_alpha.lowCI = as.numeric(tmpres$alpha$feldt$lower.ci)
  res$raw_alpha.upCI = as.numeric(tmpres$alpha$feldt$upper.ci)
  
  res$omega_h <- tmpres$omega$omega_h
  res$omega_t <- tmpres$omega$omega.tot
  ReliaRes <- rbind(ReliaRes,res)  
}

ReliaRes$alpha_CI <- str_c('[',
                           sprintf('%.4f',ReliaRes$raw_alpha.lowCI),
                           ', ',
                           sprintf('%.4f',ReliaRes$raw_alpha.upCI),
                           ']')
ReliaRes <- select(ReliaRes,
                   c(SCaleName,raw_alpha,alpha_CI,'G6(smc)',
                     average_r,'S/N',omega_h,omega_t,
                     raw_alpha.lowCI,raw_alpha.upCI))

ReliaRes %>% rename("Crobach's Alpha"=raw_alpha,
                    "Guttman's Lambda 6"='G6(smc)',
                    "ITC_Mean"=average_r,
                    "Signal/Noise Ratio"='S/N',
                    'Measurement'=SCaleName,
                    'Alpha_LowCI'=raw_alpha.lowCI,
                    'Alpha_UpCI'=raw_alpha.upCI,
                    "McDonald's Omega_h"=omega_h,
                    "McDonald's Omega_t"=omega_t) -> ReliaRes
print(ReliaRes)
print_table(ReliaRes,file = '../Res_2_Results/Res_Reliability_RPSD.doc',
            digits = 4,title = 'Reliability Analysis of Psychometric Scales')
=======
library(bruceR)
library(psych)
set.wd()
rm(list=ls())
gc()

data <- readRDS('../Res_3_IntermediateData/16w_BehavProb_Compact_AgeWinsor.rds')

data <- subset(data,CIER_Flag==F,-c(RT_TPI,MLS_Sum,IRV_WSum_Z,EOC,MahaD_SQ,
                                    RT_Bully,RT_Stress,RT_AcadBO,RT_IAT,
                                    RT_Anx,RT_Dep,RT_SuiciIdea,RT_SelfInjury,
                                    MLS_Stress,MLS_AcadBO,MLS_IAT,MLS_Anx,
                                    MLS_Dep,MLS_SuiciIdea,MLS_SelfInjury,
                                    IRV_Stress,IRV_AcadBO,IRV_IAT,IRV_Anx,
                                    IRV_Dep,IRV_SuiciIdea,IRV_SelfInjury,
                                    IRV_WSum,IRV_Num,RT_BehavioralProblem))


var.ls <- c('Stress_','AcadBO_','IAT_','Anx_','Dep_','SelfInjury_','SuiciIdea_')
item.ls <- list(1:14,1:16,1:20,1:20,1:10,1:9,1:14)

ReliaRes <- data.frame()
for (i in 1:length(var.ls)){
  tmpres <- Alpha(data,var = var.ls[[i]],items = item.ls[[i]])
  
  res <- select(tmpres$alpha$total,-c(std.alpha,ase,mean,sd,median_r))
  res$SCaleName <- str_replace(var.ls[[i]],'_','')
  res$raw_alpha.lowCI = as.numeric(tmpres$alpha$feldt$lower.ci)
  res$raw_alpha.upCI = as.numeric(tmpres$alpha$feldt$upper.ci)
  
  res$omega_h <- tmpres$omega$omega_h
  res$omega_t <- tmpres$omega$omega.tot
  ReliaRes <- rbind(ReliaRes,res)  
}

ReliaRes$alpha_CI <- str_c('[',
                           sprintf('%.4f',ReliaRes$raw_alpha.lowCI),
                           ', ',
                           sprintf('%.4f',ReliaRes$raw_alpha.upCI),
                           ']')
ReliaRes <- select(ReliaRes,
                   c(SCaleName,raw_alpha,alpha_CI,'G6(smc)',
                     average_r,'S/N',omega_h,omega_t,
                     raw_alpha.lowCI,raw_alpha.upCI))

ReliaRes %>% rename("Crobach's Alpha"=raw_alpha,
                    "Guttman's Lambda 6"='G6(smc)',
                    "ITC_Mean"=average_r,
                    "Signal/Noise Ratio"='S/N',
                    'Measurement'=SCaleName,
                    'Alpha_LowCI'=raw_alpha.lowCI,
                    'Alpha_UpCI'=raw_alpha.upCI,
                    "McDonald's Omega_h"=omega_h,
                    "McDonald's Omega_t"=omega_t) -> ReliaRes
print(ReliaRes)
print_table(ReliaRes,file = '../Res_2_Results/Res_Reliability_RPSD.doc',
            digits = 4,title = 'Reliability Analysis of Psychometric Scales')
>>>>>>> origin/main
