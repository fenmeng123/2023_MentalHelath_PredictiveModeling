library(bruceR)
library(ggridges)
library(svglite)
set.wd()
source("../Supp_0_Subfunctions/s_SensitivityAnalysis_RepVis.R")


# Plot Balanced ACC -------------------------------------------------------


Results <- list.files(
  path = "../Res_2_Results/ResSensAna_PrePost_COVID19_Dep/",
  pattern = "Res.*xlsx",
  full.names = T) %>%
  load.COVID19.ModelResults()
ResMain <- load.ResMain.Dep()

ResMain$Flag <- "Total Sample"

AllRes <- rbind(ResMain,Results)

AllRes$Flag <- AllRes$Flag %>% factor(
  levels = c("Total Sample",
             "Pre",
             "Post"),
  labels = c("Total Sample",
             "Pre-COVID19 (Before Jan 12, 2020)",
             "During COVID19 (Jan 13, 2020 - Nov 16, 2021)"))

AllRes$balacc <- AllRes$balacc * 100

p <- AllRes %>%
  ggplot(aes(x = balacc,
             y = Flag, fill = after_stat(x))) +
  geom_density_ridges_gradient(scale = 1.8,
                               rel_min_height = 0.01,
                               panel_scaling = F) +
  geom_vline(aes(xintercept=mean(AllRes$balacc[AllRes$Flag == 'Total Sample'])),
             colour='black',
             linetype='dashed',
             linewidth=1.1,
             alpha=0.5)+
  theme_ridges()+
  scale_fill_viridis_c(name = "Balanced ACC", option = "C")+
  scale_x_continuous(limits = c(85.5, 87.6)) +  # 设置Y轴的值范围
  scale_y_discrete(labels = c("Pre-COVID19 (Before Jan 12, 2020)" = "Pre-COVID19\n(Before Jan 12, 2020)", 
                              "During COVID19 (Jan 13, 2020 - Nov 16, 2021)" = "During COVID19\n(Jan 13, 2020 - Nov 16, 2021)")) +
  xlab('Balanced ACC (%)')+
  ylab('Data Collection Time')+
  theme(legend.position = "None",
        axis.title.x = element_text(hjust = 0.5),
        axis.title.y = element_text(hjust = 0.5),
        axis.text.y = element_text(hjust = 0.5))
p

ggsave('../Res_2_Results/ResSensAna_PrePost_COVID19_Dep/SensRes_Res_COVID19_Dep.svg',
       width = 8,
       height = 6,
       plot = p)

# Plot Feature Importance -------------------------------------------------


Coefs <- list.files(
  path = "../Res_2_Results/ResSensAna_PrePost_COVID19_Dep/",
  pattern = "Coef.*xlsx",
  full.names = T) %>%
  load.COVID19.Feature.Coefficients

CoefMain <- load.CoefMain.Dep(RemoveGradeFlag = F)

CoefMain$Flag <- "Total Sample"

AllCoefs <- rbind(CoefMain,Coefs)

AllCoefs$Predictors <- AllCoefs$Predictors %>% 
  str_replace_all(
    c("Anx_Sum" = "Anxiety",
      "Stress_Sum" = "Perceived Stress",
      "AcadBO_Sum" = "Academic Burn-out",
      "IAT_Sum" = "Internet Addiction",
      "SelfInjury_Sum" = "Non-suicidal Self-injury",
      "BeBully_Bin" = "Being Bullied",
      "Grade" = "Age")
  ) %>%
  factor(
    levels = c('Anxiety','Perceived Stress','Academic Burn-out',
               'Internet Addiction','Non-suicidal Self-injury',
               'Being Bullied','Age'))
AllCoefs$Flag <- AllCoefs$Flag %>% factor(
  levels = c("Total Sample",
             "Pre",
             "Post"),
  labels = c("Total Sample",
             "Pre-COVID19 (Before Jan 12, 2020)",
             "During COVID19 (Jan 13, 2020 - Nov 16, 2021)"))

Coefs_95CI <- AllCoefs %>%
  summarise(M = median(`Feature Importance [Regression Coefficient]`),
            Up = quantile(`Feature Importance [Regression Coefficient]`,0.95),
            Low = quantile(`Feature Importance [Regression Coefficient]`,0.05),
            .by = c(Flag,Predictors)) %>%
  as.data.frame() %>%
  arrange(pick(c(Flag,Predictors)))

p <- Coefs_95CI %>%
  ggplot(aes(color = Flag)) +
  geom_errorbar(aes(y = M, x = Predictors,
                    ymin = Low,
                    ymax = Up),
                width = 0.4,
                linewidth = 0.6,
                position = position_dodge(width = 0.6))+
  geom_point(mapping = aes(y = M,
                           x = Predictors),
             size = 1.7,
             position = position_dodge(width = 0.6)) +
  ggsci::scale_color_d3()+
  theme_bruce()+
  theme(axis.text.x = element_text(angle = 15,hjust = 1),
        panel.grid.major.y = element_line(colour = 'gray80',
                                          linewidth = 0.2,
                                          linetype = 'dashed'),
        legend.position = 'top',
        legend.title = element_blank()) +
  ylab("Feature Importance [Regression Coefficient]")
p

ggsave('../Res_2_Results/ResSensAna_PrePost_COVID19_Dep/SensRes_CoefErrorBar_COVID19_Dep.svg',
       width = 10,
       height = 8,
       plot = p)