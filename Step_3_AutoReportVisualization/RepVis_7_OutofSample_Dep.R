library(bruceR)
library(openxlsx)
library(ggridges)
library(svglite)
rm(list=ls())
gc()
set.wd()
source('../Supp_0_Subfunctions/s_OOSD_ResStats.R')

anchor <- read.xlsx('../Res_2_Results/ResML_OOSD_Dep/Res_OOSD_weighted_Dep.xlsx')

ResDown <- read.xlsx('../Res_2_Results/ResML_OOSD_Dep/Res_OOSD_Down1000_Dep.xlsx')

ResUp <- read.xlsx('../Res_2_Results/ResML_OOSD_Dep/Res_OOSD_Up1000_Dep.xlsx')

anchor %>% subset(name=='External') %>% select(-c(X1,name)) -> anchor_Ext
ResDown %>% subset(name=='External') %>% select(-c(X1,name)) -> ResDown_Ext
ResUp %>% subset(name=='External') %>% select(-c(X1,name)) -> ResUp_Ext
# Generate Summary Tables for Prediction Performance ----------------------
Comp_Table <- Loop.Comp.Res(c('ACC','Sensitivity','Specificity','balacc',
                              'F1_score','PPV','NPV'),
                            ResDown_Ext,ResUp_Ext,anchor_Ext)
Comp_Table %>% select(c(Index,Contrast,t,pval,
                        diff,llci,ulci,
                        Cohen_d,LLCI,ULCI)) %>%
  print_table(row.names = F,
              file = '../Res_2_Results/ResML_OOSD_Dep/Res_IndexComp_Dep.doc',
              digits = 4)

Get.Res.Sum(ResDown_Ext) %>%
  rename('Downsampling (1,000 times)'='Value') -> ResDown_Ext_Table
Get.Res.Sum(ResUp_Ext) %>%
  rename('Upsampling (1,000 times)'='Value') -> ResUp_Ext_Table
Get.Res.Sum(anchor_Ext) %>%
  merge(ResDown_Ext_Table,by = 'Index') %>%
  merge(ResUp_Ext_Table,by='Index') %>%
  arrange(factor(Index,levels=c('ACC','Sensitivity','Specificity',
                                'Balanced ACC','F1-score','PPV','NPV'))) %>%
  print_table(file = '../Res_2_Results/ResML_OOSD_Dep/Res_SummaryT_OOSD_Dep.doc')

# Ridge Plot for Balanced ACC ---------------------------------------------
ResDown_Ext$Method <- 'Downsampling'
ResUp_Ext$Method <- 'Upsampling'
Res_Ext <- rbind(ResDown_Ext,ResUp_Ext)
Res_Ext[,
        c("ACC","Sensitivity","Specificity",
          "balacc","PPV","NPV")] <- Res_Ext[,c("ACC","Sensitivity","Specificity",
                                               "balacc","PPV","NPV")]*100

Res_Ext %>%
  ggplot(aes(x = balacc,
             y = Method, fill = after_stat(x))) +
  geom_density_ridges_gradient(scale = 1.8,
                               rel_min_height = 0.01,
                               panel_scaling = F) +
  theme_ridges()+scale_fill_viridis_c(name = "Balanced ACC", option = "C")+
  geom_vline(aes(xintercept=anchor_Ext$balacc*100),
             colour='black',
             linetype='dashed',
             linewidth=1.5,
             alpha=0.5)+
  annotate('segment',
           x=mean(ResDown_Ext$balacc*100),
           xend = mean(ResDown_Ext$balacc*100),
           y = 1,
           yend = 1.98)+
  annotate('segment',
           x=mean(ResUp_Ext$balacc*100),
           xend = mean(ResUp_Ext$balacc*100),
           y = 2,
           yend = 3.78)+
  annotate('segment',
           x=mean(ResDown_Ext$balacc*100),
           xend = anchor_Ext$balacc*100,
           y = 1.8,yend = 1.8,
           size=1.2,
           arrow = arrow(ends = "both",angle = 30,length = unit(.2,"cm")))+
  annotate('segment',
           x=mean(ResUp_Ext$balacc*100),
           xend = anchor_Ext$balacc*100,
           y = 3.2,yend = 3.2,
           size=1.2,
           arrow = arrow(ends = "both",angle = 30,length = unit(.2,"cm")))+
  annotate('text',x = anchor_Ext$balacc*100+0.001,
           y = 0.5,label=sprintf('Weighted Model=%.3f%%',anchor_Ext$balacc*100),
           hjust=0,
           colour='gray50')+
  annotate('text',x = (anchor_Ext$balacc+mean(ResDown_Ext$balacc))/2*100,
           size=8,
           y = 1.85,label='***',
           hjust=0.5)+
  annotate('text',x = (anchor_Ext$balacc+mean(ResUp_Ext$balacc))/2*100,
           size=8,
           y = 3.25,label='***',
           hjust=0.5)+
  labs(title = 'Out-of-Sample Prediction Performance: Depression')+
  xlab('Balanced ACC (%)')+
  theme(legend.position = 'None',
        axis.title.x = element_text(hjust = 0.5),
        axis.title.y = element_blank()) -> p
p
ggsave('../Res_2_Results/ResML_OOSD_Dep/Res_RidgesBalacc_OOSD_Dep.png',
       bg="#ffffff",
       plot = p)
ggsave('../Res_2_Results/Res_RidgesBalacc_OOSD_Dep.svg',
       plot = p) 
# Compare Feature Importance: Generate Summary Tables ---------------------
rm(list=ls())
gc()
source('../Supp_0_Subfunctions/s_OOSD_ResStats.R')
ResDown <- read.xlsx('../Res_2_Results/ResML_OOSD_Dep/Coef_OOSD_Down1000_Dep.xlsx')
ResUp <- read.xlsx('../Res_2_Results/ResML_OOSD_Dep/Coef_OOSD_Up1000_Dep.xlsx')
ResDown %>% select(-c(X1)) -> ResDown
ResUp  %>% select(-c(X1)) -> ResUp
ResDown %>% Get.Coef.Table() %>%
  print_table(digits = 2,
            file = '../Res_2_Results/ResML_OOSD_Dep/Coef_Downsample_SummaryT_Dep.doc')
ResUp %>% Get.Coef.Table() %>%
  print_table(digits = 2,
              file = '../Res_2_Results/ResML_OOSD_Dep/Coef_Upsample_SummaryT_Dep.doc')

# Compare Feature Importance: Ridges Plot ---------------------------------
ResDown %>% Coef.Transform() %>% 
  pivot_longer(cols = everything(),
               names_to = 'Predictors',
               values_to = 'Feature Importance [Regression Coefficients]') -> ResDown
ResUp %>% Coef.Transform() %>% 
  pivot_longer(cols = everything(),
               names_to = 'Predictors',
               values_to = 'Feature Importance [Regression Coefficients]') -> ResUp
ResDown$Method <- 'Downsampling'
ResUp$Method <- 'Upsampling'
Res_Coef <- rbind(ResDown,ResUp)
Res_Coef$Method <- factor(Res_Coef$Method,
                         level=c('Upsampling','Downsampling'))
Res_Coef$Predictors %>%
  str_replace('Anx_Sum','Anxiety') %>%
  str_replace('Stress_Sum','Perceived Stress') %>%
  str_replace('AcadBO_Sum','Academic Burn-out') %>%
  str_replace('IAT_Sum','Internet Addiction') %>%
  str_replace('SelfInjury_Sum','Non-suicidal Self-injury') %>%
  str_replace('BeBully_Bin','Be Bullied')%>%
  str_replace('Grade','Education Level (Grade)') %>%
  str_replace('Gender_Girl','Biological Sex') -> Res_Coef$Predictors
Res_Coef$Predictors <-forcats::fct_rev(factor(Res_Coef$Predictors,
                             level = c('Anxiety',
                                        'Perceived Stress',
                                        'Academic Burn-out',
                                        'Internet Addiction',
                                        'Non-suicidal Self-injury',
                                        'Be Bullied',
                                        'Education Level (Grade)')))
Res_Coef$`Feature Importance [Regression Coefficients]` <- as.numeric(Res_Coef$`Feature Importance [Regression Coefficients]`)
Res_Coef %>%
  ggplot(aes(x = `Feature Importance [Regression Coefficients]`,
             y = Predictors, fill = after_stat(x))) +
  geom_density_ridges_gradient(scale = 3,
                               rel_min_height = 0.005,
                               panel_scaling = T) +
  scale_fill_viridis_c(name = "Coefs",
                       option = "H",
                       alpha = 1)+
  theme_ridges()+
  geom_vline(aes(xintercept=0),
             colour='black',
             linetype='dashed',
             linewidth=1,
             alpha=0.5)+
  facet_grid(Method~.)+
  theme(legend.position = 'None')+
  labs(title = 'Out-of-sample Predicting Depression: Feature Importance') -> p
ggsave('../Res_2_Results/ResML_OOSD_Dep/Res_CoefRidges_OOSD_Dep.png',
       width = 8.74,
       height = 7.72,
       bg="#ffffff",
       plot = p)
ggsave('../Res_2_Results/ResML_OOSD_Dep/Res_CoefRidges_OOSD_Dep.svg',
       width = 8.74,
       height = 7.72,
       plot = p)
