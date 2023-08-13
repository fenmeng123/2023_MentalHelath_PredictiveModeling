library(bruceR)
library(svglite)
rm(list=ls())
gc()
set.wd()

if (!dir.exists('../Res_2_Results/RepVis_Demographics/')){
  dir.create('../Res_2_Results/RepVis_Demographics/')
}
data <- readRDS('../Res_3_IntermediateData/16w_BehavProb_Compact_AgeWinsor.rds')

p_age_gender <- ggplot(data, aes(x = Gender, y = Age_years, color = Gender)) +
  ggdist::stat_halfeye(adjust = 1.5, width = .5, .width = 0, justification = -.2, point_colour = NA) +
  geom_boxplot(width = .1, outlier.shape = NA) +
  geom_jitter(width = .05, alpha = .001) +
  labs(title = "Age Distribution (Stratified by Biological Sex)")+
  xlab('Biological Sex')+ylab('Age in years')+theme_bruce()+
  theme(panel.grid.major.y = element_line(linetype = 'dashed',linewidth = 0.8))

ggsave('../Res_2_Results/RepVis_Demographics/DistributionPlot_AgeBySex.png',p_age_gender)
ggsave('../Res_2_Results/RepVis_Demographics/DistributionPlot_AgeBySex.svg',p_age_gender)

p_age_region <- ggplot(data, aes(x = Region_4L, y = Age_years)) +
  ggdist::stat_halfeye(adjust = 1.5, width = .5, .width = 0, justification = -.2, point_colour = NA) +
  geom_boxplot(width = .1, outlier.shape = NA) +
  geom_jitter(width = .05, alpha = .001) +
  labs(title = "Age Distribution (Stratified by Geographic Area)")+
  xlab('Geographic Area')+ylab('Age in years')+theme_bruce()+
  theme(panel.grid.major.y = element_line(linetype = 'dashed',linewidth = 0.8))

ggsave('../Res_2_Results/RepVis_Demographics/DistributionPlot_AgeByArea.png',p_age_region)
ggsave('../Res_2_Results/RepVis_Demographics/DistributionPlot_AgeByArea.svg',p_age_region)


p_age_phase <- ggplot(data, aes(x = StudyPhase, y = Age_years)) +
  ggdist::stat_halfeye(adjust = 1.5, width = .5, .width = 0, justification = -.2, point_colour = NA) +
  geom_boxplot(width = .1, outlier.shape = NA) +
  geom_jitter(width = .05, alpha = .001) +
  labs(title = "Age Distribution (Stratified by Phase of Studying)")+
  xlab('Phase of Studying')+ylab('Age in years')+theme_bruce()+
  theme(panel.grid.major.y = element_line(linetype = 'dashed',linewidth = 0.8))

ggsave('../Res_2_Results/RepVis_Demographics/DistributionPlot_AgeByPhase.png',p_age_phase)
ggsave('../Res_2_Results/RepVis_Demographics/DistributionPlot_AgeByPhase.svg',p_age_phase)


p_age_grade <- ggplot(data, aes(x = Grade, y = Age_years)) +
  ggdist::stat_halfeye(adjust = 1.5, width = .5, .width = 0, justification = -.2, point_colour = NA) +
  geom_boxplot(width = .1, outlier.shape = NA) +
  geom_jitter(width = .05, alpha = .001) +
  labs(title = "Age Distribution (Stratified by Grade of Studying)")+
  xlab('Grade of Studying')+ylab('Age in years')+theme_bruce()+
  theme(panel.grid.major.y = element_line(linetype = 'dashed',linewidth = 0.8))+
  theme(axis.text.x = element_text(angle = -30))

ggsave('../Res_2_Results/RepVis_Demographics/DistributionPlot_AgeByGrade.png',p_age_grade)
ggsave('../Res_2_Results/RepVis_Demographics/DistributionPlot_AgeByGrade.svg',p_age_grade)

p_sex_grade <- ggplot(data, aes(x = Grade,color=Gender,fill=Gender)) +
  geom_bar(position="dodge",stat = 'count')+
  xlab('Grade of Studying')+ylab('counts')+theme_bruce()+
  theme(panel.grid.major.y = element_line(linetype = 'dashed',linewidth = 0.8))+
  theme(axis.text.x = element_text(angle = -30))
ggsave('../Res_2_Results/RepVis_Demographics/BarPlot_SexByGrade.png',p_sex_grade)
ggsave('../Res_2_Results/RepVis_Demographics/BarPlot_SexByGrade.svg',p_sex_grade)


p_sex_region <- ggplot(data, aes(x = Region_4L,color=Gender,fill=Gender)) +
  geom_bar(position="dodge",stat = 'count')+
  xlab('Geographic Area')+ylab('counts')+theme_bruce()+
  theme(panel.grid.major.y = element_line(linetype = 'dashed',linewidth = 0.8))
ggsave('../Res_2_Results/RepVis_Demographics/BarPlot_SexByArea.png',p_sex_region)
ggsave('../Res_2_Results/RepVis_Demographics/BarPlot_SexByArea.svg',p_sex_region)