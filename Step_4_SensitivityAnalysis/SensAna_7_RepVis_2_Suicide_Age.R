library(bruceR)
library(ggridges)
library(svglite)
set.wd()
source("../Supp_0_Subfunctions/s_SensitivityAnalysis_RepVis.R")


# Plot Balanced ACC -------------------------------------------------------

FileList_MdlRes <- list.files(
  path = "../Res_2_Results/ResSensAna_AgeStratified_Suicide/",
  pattern = "Res.*xlsx",
  full.names = T)

Results <- load.AgeStratified.ModelResults(FileList_MdlRes)

ResMain <- load.ResMain.Suicide()

ResMain$Age <- "Total Sample"
ResMain$Grade <- "All"

AllRes <- rbind(ResMain,Results)

AllRes$Age <- AllRes$Age %>% factor(
  levels = c("Total Sample",
             "9-10","10-11","11-12","12-13",
             "13-14","14-15","15-16","16-17",
             "17-18"))
AllRes$Grade <- AllRes$Grade %>% factor(
  levels = c("All", 
             "4","5","6","7","8",
             "9","10","11","12"))
AllRes$balacc <- AllRes$balacc * 100

p <- AllRes %>%
  ggplot(aes(x = balacc,
             y = Age, fill = after_stat(x))) +
  geom_density_ridges_gradient(scale = 1.8,
                               rel_min_height = 0.01,
                               panel_scaling = F) +
  geom_vline(aes(xintercept=mean(AllRes$balacc[AllRes$Age == 'Total Sample'])),
             colour='black',
             linetype='dashed',
             linewidth=1.1,
             alpha=0.5)+
  theme_ridges()+
  scale_fill_viridis_c(name = "Balanced ACC", option = "C")+
  scale_x_continuous(limits = c(83.5, 86)) +  # 设置Y轴的值范围
  # labs(title = 'Predicting Suicidal Ideation Age stratified by One-year old')+
  xlab('Balanced ACC (%)')+
  ylab('Age (years old)')+
  theme(legend.position = "None",
        axis.title.x = element_text(hjust = 0.5),
        axis.title.y = element_text(hjust = 0.5))
p
ggsave('../Res_2_Results/ResSensAna_AgeStratified_Suicide/SensRes_BalanACC_Age_Suicide.svg',
       width = 6,
       height = 6,
       plot = p)


# Plot Feature Importance (Regression Coefficient) ------------------------
FileList_Coef <- list.files(
  path = "../Res_2_Results/ResSensAna_AgeStratified_Suicide/",
  pattern = "Coef.*xlsx",
  full.names = T)
Coefs <- load.AgeStratified.Feature.Coefficients(FileList_Coef)

CoefMain <- load.CoefMain.Suicide()

CoefMain$Age <- "Total Sample"
CoefMain$Grade <- "All"

AllCoefs <- rbind(CoefMain,Coefs)


AllCoefs$Predictors <- AllCoefs$Predictors %>% 
  str_replace_all(
    c("Anx_Sum" = "Anxiety",
      "Stress_Sum" = "Perceived Stress",
      "AcadBO_Sum" = "Academic Burn-out",
      "IAT_Sum" = "Internet Addiction",
      "SelfInjury_Sum" = "Non-suicidal Self-injury")
  ) %>%
  factor(
    levels = c('Anxiety',
               'Non-suicidal Self-injury',
               'Perceived Stress',
               'Internet Addiction',
               'Academic Burn-out'))

AllCoefs$Age <- AllCoefs$Age %>% factor(
  levels = c("Total Sample",
             "9-10","10-11","11-12","12-13",
             "13-14","14-15","15-16","16-17",
             "17-18"))
AllCoefs$Grade <- AllCoefs$Grade %>% factor(
  levels = c("All", 
             "4","5","6","7","8",
             "9","10","11","12"))

p <- AllCoefs %>%
  ggplot(aes(x=Predictors,
             y=`Feature Importance [Regression Coefficient]`,
             fill=Age))+
  geom_boxplot(outlier.shape = NA,width = 0.5,alpha=0.85,
               position = position_dodge(width = 0.5))+
  theme_bruce()+
  theme(axis.text.x = element_text(angle = 15,hjust = 1),
        panel.grid.major.y = element_line(colour = 'gray80',
                                          linewidth = 0.2,
                                          linetype = 'dashed'),
        legend.position = 'top',
        legend.title = element_blank())+
  scale_color_brewer(palette = "Set3")
p

ggsave('../Res_2_Results/ResSensAna_AgeStratified_Suicide/SensRes_Coef_Age_Suicide.svg',
       width = 10,
       height = 8,
       plot = p)

Coefs_95CI <- AllCoefs %>%
  summarise(M = median(`Feature Importance [Regression Coefficient]`),
            Up = quantile(`Feature Importance [Regression Coefficient]`,0.95),
            Low = quantile(`Feature Importance [Regression Coefficient]`,0.05),
            .by = c(Age,Predictors)) %>%
  as.data.frame() %>%
  arrange(pick(c(Age,Predictors)))

p <- Coefs_95CI %>%
  ggplot(aes(fill = Age, color = Age)) +
  geom_errorbar(aes(y = M, x = Predictors,
                    ymin = Low,
                    ymax = Up),
                width = 0.5,
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

ggsave('../Res_2_Results/ResSensAna_AgeStratified_Suicide/SensRes_CoefErrorBar_Age_Suicide.svg',
       width = 10,
       height = 8,
       plot = p)
