library(bruceR)
library(naniar)
set.wd()
rm(list=ls())
gc()

source('../Supp_0_Subfunctions/s_CIER_functions.R')
data <- readRDS('../Res_3_IntermediateData/181w_recoded_QC.rds')
miss_var_summary(data) %>% as.data.frame() %>%
  print_table(file = '../Res_2_Results/PreprocRes/181w_缺失值报告_QC后_Recoding后.doc')

data$EOC <- replace_na(data$EOC,-1)
threshold = list(ChiSQ=0.999,ChiSQ_DF=(16+14+20+10+20+9+14),
                 EOC=0.7,
                 MLS=(round((16+14+20+10+20+9+14)*0.6)),
                 IRV=-2,
                 NumFlagThreshold=2)
CIER_Flag <- ApplyCIERthreshold(data,threshold)
CIER_Flag <- as.numeric(CIER_Flag)
CIER_Flag <- RECODE(CIER_Flag,
                    "0 = 'Non-C/IER';
                    1 = 'C/IER';")
CIER_Flag <- factor(CIER_Flag,
                    levels = c('C/IER','Non-C/IER'))
data$CIER_Flag <- CIER_Flag
data <- na.omit(data)
saveRDS(data,'../Res_3_IntermediateData/181w_recoded_QC_listwiseDemo.rds')
