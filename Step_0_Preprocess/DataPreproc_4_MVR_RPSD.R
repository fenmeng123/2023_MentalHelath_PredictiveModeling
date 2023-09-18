library(bruceR)
library(naniar)
set.wd()
rm(list=ls())
gc()

data <- readRDS('../Res_3_IntermediateData/16w_BehavProb_Compact.rds')


miss_var_summary(data) %>% as.data.frame() %>%
  print_table(file = '../Res_2_Results/PreprocRes/16w_缺失值报告_QC后_Recoding后.doc')
