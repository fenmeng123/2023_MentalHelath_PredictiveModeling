library(bruceR)
library(ggbreak)
library(ggridges)
library(svglite)
set.wd()
source("../Supp_0_Subfunctions/s_SensitivityAnalysis_RepVis.R")


MdlRes <- list.files(
  path = "../Res_2_Results/ResSensAna_Suicide_Score17/",
  pattern = "Res.*xlsx",
  full.names = T) %>%
  import(verbose = T) %>%
  filter(
    name == "External"
  ) %>%
  select(-c(`...1`,name))

MdlRes$`Cut-off` <- "PANSI >= 17"

ResMain <- load.ResMain.Suicide()
ResMain$`Cut-off` <- "PANSI >= 43"

AllRes <- rbind(ResMain,MdlRes)

AllRes$`Cut-off` <- AllRes$`Cut-off` %>%
  factor(levels = c("PANSI >= 43","PANSI >= 17"))
AllRes$balacc <- AllRes$balacc * 100

p <- AllRes %>%
  ggplot(aes(y = balacc,
             x = `Cut-off`,
             fill = `Cut-off`)) +
  geom_violin(width=0.4,alpha=0.5,trim = T,scale = 'width')+
  geom_boxplot(outlier.shape = NA,width = 0.15,alpha=0.1,
               position = position_dodge(width = 0.4))+
  scale_y_break(c(81.80,85.80))+
  theme_bruce()+
  theme(axis.text.x = element_text(angle = 0,hjust = 0.5),
        panel.grid.major.y = element_line(colour = 'gray80',
                                          linewidth = 0.2,
                                          linetype = 'dashed'),
        legend.position = 'top',
        legend.title = element_blank())+
  ggsci::scale_fill_lancet()+
  ylab('Balanced ACC (%)')+
  xlab('Cut-off Value for Suicidal Ideation Problem')+
  theme(legend.position = "None",
        axis.title.x = element_text(hjust = 0.5),
        axis.title.y = element_text(hjust = 0.5))
p
ggsave('../Res_2_Results/ResSensAna_Suicide_Score17/SensRes_BalanACC_Suicide.svg',
       width = 6,
       height = 6,
       plot = p)

MdlCoef <- list.files(
  path = "../Res_2_Results/ResSensAna_Suicide_Score17/",
  pattern = "Coef.*xlsx",
  full.names = T) %>%
  import(verbose = T) %>%
  select(-`...1`) %>%
  pivot_longer(
    cols = starts_with("Coef_"),
    names_prefix = "Coef_",
    names_to = "IterNum",
    values_to = "Feature Importance [Regression Coefficient]"
  ) %>%
  rename(Predictors = CoefName)

CoefMain <- load.CoefMain.Suicide(RemoveGradeFlag = F)

MdlCoef$`Cut-off` <- "PANSI >= 17"
CoefMain$`Cut-off` <- "PANSI >= 43"

AllCoefs <- rbind(CoefMain,MdlCoef)

AllCoefs$`Cut-off` <- AllCoefs$`Cut-off` %>%
  factor(levels = c("PANSI >= 43","PANSI >= 17"))
AllCoefs$Predictors <- factor(AllCoefs$Predictors,
                               levels = c('Anx_Sum',
                                          'SelfInjury_Sum',
                                          'Stress_Sum',
                                          'IAT_Sum',
                                          'AcadBO_Sum',
                                          'Grade'),
                               labels = c('Anxiety',
                                          'Non-suicidal Self-injury',
                                          'Perceived Stress',
                                          'Internet Addiction',
                                          'Academic Burn-out',
                                          'Age'))
Coefs_95CI <- AllCoefs %>%
  summarise(M = median(`Feature Importance [Regression Coefficient]`),
            Up = quantile(`Feature Importance [Regression Coefficient]`,0.95),
            Low = quantile(`Feature Importance [Regression Coefficient]`,0.05),
            .by = c(`Cut-off`,Predictors)) %>%
  as.data.frame() %>%
  arrange(pick(c(`Cut-off`,Predictors)))

p <- Coefs_95CI %>%
  ggplot(aes(fill = `Cut-off`, color = `Cut-off`)) +
  geom_errorbar(aes(y = M, x = Predictors,
                    ymin = Low,
                    ymax = Up),
                width = 0.2,
                linewidth = 0.6,
                position = position_dodge(width = 0.6))+
  geom_point(mapping = aes(y = M,
                           x = Predictors),
             size = 1.5,
             position = position_dodge(width = 0.6)) +
  theme_bruce()+
  theme(axis.text.x = element_text(angle = 15,hjust = 1),
        panel.grid.major.y = element_line(colour = 'gray80',
                                          linewidth = 0.2,
                                          linetype = 'dashed'),
        legend.position = 'top',
        legend.title = element_blank()) +
  ylab("Feature Importance [Regression Coefficient]")
p
ggsave('../Res_2_Results/ResSensAna_Suicide_Score17/SensRes_Coefs_Suicide.svg',
       width = 10,
       height = 8,
       plot = p)