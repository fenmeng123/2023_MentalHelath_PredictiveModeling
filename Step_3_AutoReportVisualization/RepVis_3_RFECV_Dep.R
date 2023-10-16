library(bruceR)
library(openxlsx)
library(ggridges)
library(ggside)
library(svglite)
set.wd()
rm(list=ls())
gc()
res <- read.xlsx('../Res_2_Results/ResML_RFECV_Dep/ResML_L2Logit_RFECV_IterNum1000.xlsx')

# Generate Summary Table --------------------------------------------------
res %>% select(starts_with('coef_')) %>% Describe() -> stats_res
stats_res[[1]] %>% select(-c(`|`,Skewness,Kurtosis)) %>%
  rename(N_RFEfail = `(NA)`,
         N_RFEpass = N) %>% replace_na(list(N_RFEfail = 0)) -> stats_res
stats_res$Freq = stats_res$N_RFEfail/nrow(res)
stats_res <- arrange(stats_res,desc(Mean))
str_remove(rownames(stats_res),'coef_') %>%
  str_replace('Anx_Sum','Anxiety') %>%
  str_replace('Stress_Sum','Perceived Stress') %>%
  str_replace('AcadBO_Sum','Academic Burn-out') %>%
  str_replace('IAT_Sum','Internet Addiction') %>%
  str_replace('SelfInjury_Sum','Non-suicidal Self-injury') %>%
  str_replace('BeBully_Bin','Being Bullied')%>%
  str_replace('Grade','Age') %>%
  str_replace('Gender_Girl','Biological Sex') %>%
  str_replace('Bully_Bin','Bullying') -> stats_res$Predictors
rownames(stats_res) <- NULL
stats_res %>% select(c(Predictors,everything())) %>% 
  print_table(digits = 2,
              row.names = F,
              title = 'RFECV: Depression',
              file = '../Res_2_Results/ResML_RFECV_Dep/Res_SummaryT_Features_RFECV.doc')
stats_res %>% select(c(Predictors,everything())) %>% 
  export('../Res_2_Results/ResML_RFECV_Dep/Res_SummaryT_Features_RFECV.rda')
stats_res$Predictors -> Predictor_Order
Feature_Freq <- stats_res
Feature_Freq$Freq <- 1 - Feature_Freq$Freq
# Ridges Plot -------------------------------------------------------------
res %>% select(starts_with('coef_')) -> stats_res
str_remove(colnames(stats_res),'coef_') %>%
  str_replace('Anx_Sum','Anxiety') %>%
  str_replace('Stress_Sum','Perceived Stress') %>%
  str_replace('AcadBO_Sum','Academic Burn-out') %>%
  str_replace('IAT_Sum','Internet Addiction') %>%
  str_replace('SelfInjury_Sum','Non-suicidal Self-injury') %>%
  str_replace('BeBully_Bin','Being Bullied')%>%
  str_replace('Grade','Age') %>%
  str_replace('Gender_Girl','Biological Sex') %>%
  str_replace('Bully_Bin','Bullying') -> colnames(stats_res)
pivot_longer(stats_res,
             cols = everything(),
             names_to = 'Predictors',
             values_to = 'Feature Importance [Regression Coefficients]') -> stats_res
factor(stats_res$Predictors,
       levels = Predictor_Order) %>% forcats::fct_rev() -> stats_res$Predictors
factor(Feature_Freq$Predictors,
       levels = Predictor_Order) -> Feature_Freq$Predictors
Feature_Freq$RefVal = 0.5
stats_res %>%
  ggplot(aes(x = `Feature Importance [Regression Coefficients]`,
             y = Predictors, fill = after_stat(x))) +
  geom_density_ridges_gradient(scale = 2,
                               rel_min_height = 0.01,
                               panel_scaling = F) +
  scale_fill_viridis_c(name = "Coefs",
                       option = "H",
                       alpha = 1)+
  theme_ridges()+
  geom_vline(aes(xintercept=0),
             colour='black',
             linetype='dashed',
             linewidth=1,
             alpha=0.5)+
  geom_ysidebar(aes(x=Freq,y=Predictors,yfill=Freq),
                width = 0.5,
                stat = 'identity',
                data = Feature_Freq,
                inherit.aes = F,
                position = position_dodge()
  )+
  geom_ysideline(aes(x = RefVal,y = 1:9),
                 colour = 'black',
                 linetype = 'dashed',
                 linewidth = 0.5,
                 alpha = 1,
                 data = Feature_Freq) + 
  scale_yfill_gradient(low ="#EEEEEE", high = "#FF5500")+
  theme(ggside.axis.line.x = element_line(colour = 'black'),
        ggside.axis.line.y = element_line(colour = 'black'),
        ggside.axis.ticks.x = element_blank(),
        ggside.axis.text.x = element_text(size = 8,
                                          angle = 90),
        ggside.panel.grid.major.x = element_line(),
        ggside.panel.scale.y =0.18,
  )+
  labs(title = 'Predicting Depression: Feature Importance & Stability',
  ) + xlab('Importance [Regression Coefficient]; Stability [Feature Frequency]') -> p
ggsave('../Res_2_Results/Res_RidgesPlot_CoefsFreq_Dep.png',
       bg="#ffffff",
       plot = p)
ggsave('../Res_2_Results/Res_RidgesPlot_CoefsFreq_Dep.svg',
       plot = p)  
