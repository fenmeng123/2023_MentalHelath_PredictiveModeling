library(bruceR)
library(openxlsx)
library(ggridges)
library(ggsci)
library(svglite)
rm(list=ls())
gc()
set.wd()
source('../Supp_0_Subfunctions/s_OOSD_ResStats.R')
source('../Supp_0_Subfunctions/s_SubG_ResStats.R')

# Generate Coef Comparison Summary Table ----------------------------------

MdlMethod = 'DownSampMdl'
Subgroup = c('Boy','Girl')
Input_Dir = '../Res_2_Results/ResML_Subgroup_Dep/'
Res_Sex <- Get.Dep.SubG.Summary.Table(MdlMethod,Subgroup,Input_Dir)

Subgroup = c('PrimarySchool','JuniorSchool','SeniorSchool')
Res_Phase <- Get.Dep.SubG.Summary.Table(MdlMethod,Subgroup,Input_Dir)

Subgroup = c('Eastern','Northeast','Central','Western')
Res_Area <- Get.Dep.SubG.Summary.Table(MdlMethod,Subgroup,Input_Dir)

rename(Res_Sex$Compact,
       'Effect Size (Sex)' = 'Difference',
       'p-value (Sex)' = 'pval') -> T_sex
rename(Res_Phase$Compact,
       'Effect Size (Phase of studying)' = 'η²p [90% CI of η²p]',
       'p-value (Phase of studying)' = 'pval') -> T_Phase
rename(Res_Area$Compact,
       'Effect Size (Geographic Area)' = 'η²p [90% CI of η²p]',
       'p-value (Geographic Area)' = 'pval') -> T_Area

All_T <- merge(T_sex,T_Phase,by = 'Index')
All_T <- merge(All_T,T_Area,by = 'Index')
All_T %>% 
  arrange(factor(Index,levels=c('ACC','Sensitivity','Specificity',
                                'Balanced ACC','F1-score','PPV','NPV',
                                'Anxiety','Perceived Stress','Academic Burn-out',
                                'Internet Addiction','Non-suicidal Self-injury',
                                'Be Bullied','Education Level (Grade)'))) -> All_T
All_T$`p-value (Sex)`[All_T$`p-value (Sex)`<0.001] <- '<0.001'
All_T$`p-value (Phase of studying)`[All_T$`p-value (Phase of studying)`<0.001] <- '<0.001'
All_T$`p-value (Geographic Area)`[All_T$`p-value (Geographic Area)`<0.001] <- '<0.001'

write.xlsx(All_T,
            file = '../Res_2_Results/Res_SummaryT_Subgroup_Dep.xlsx')

All_T %>%
  select(-c(`Effect Size (Sex)`,`p-value (Sex)`,
            `Effect Size (Phase of studying)`,`p-value (Phase of studying)`,
            `Effect Size (Geographic Area)`,`p-value (Geographic Area)`)) %>%
  print_table(file = '../Res_2_Results/Res_SummaryT_Subgroup_Dep.doc',
              row.names = F)

# Plot Coefs and Balanced ACC: Sex-Subgroup -------------------------------
MdlMethod = 'DownSampMdl'
Subgroup = c('Boy','Girl')
Input_Dir = '../Res_2_Results/ResML_Subgroup_Dep/'
data <- Extract.Res.Coef(MdlMethod,Subgroup,Input_Dir)
pivot_longer(data,cols = c(Anxiety,`Perceived Stress`,`Academic Burn-out`,
                           `Internet Addiction`,`Non-suicidal Self-injury`,
                           `Be Bullied`,`Education Level (Grade)`),
             values_to = 'Feature Importance',
             names_to = 'Predictors') %>%
  select(`Feature Importance`,Predictors,Group) -> data_coef
data_coef$Predictors <- factor(data_coef$Predictors,
                               levels=c('Anxiety','Perceived Stress','Academic Burn-out',
                                        'Internet Addiction','Non-suicidal Self-injury',
                                        'Be Bullied','Education Level (Grade)'))
data_coef %>%
  ggplot(aes(x=Predictors,y=`Feature Importance`,fill=Group))+
  geom_violin(width=0.4,alpha=0.5,trim = T,scale = 'width')+
  geom_boxplot(outlier.shape = NA,width = 0.15,alpha=0.1,
               position = position_dodge(width = 0.4))+
  ggpubr::stat_anova_test(aes(group = Group),
                          label = 'p.adj.signif',
                          label.y = c(7.7,1,2),
                          method = 'one_way',
                          p.adjust.method = 'bonferroni',
                          significance = list(cutpoints = c(0, 0.001, 0.01, 0.05, Inf),
                                              symbols = c("***", "**", "*", "ns")))+
  theme_bruce()+theme(axis.text.x = element_text(angle = 15,hjust = 1),
                      panel.grid.major.y = element_line(colour = 'gray80',
                                                        linewidth = 0.2,
                                                        linetype = 'dashed'),
                      legend.position = 'top',
                      legend.title = element_blank())+
  ggsci::scale_fill_npg() -> p
p
ggsave('../Res_2_Results/Res_SexSubgroup_Coef_Dep.png',
       width = 8,
       height = 6,
       plot = p)
ggsave('../Res_2_Results/Res_SexSubgroup_Coef_Dep.svg',
       width = 8,
       height = 6,
       plot = p)

data %>%
  ggplot(aes(x=`Balanced ACC`*100,y=Group,fill=Group))+
  geom_density_ridges_gradient(scale = 0.8,
                               rel_min_height = 0.001,
                               panel_scaling = T)+
  theme_ridges()+ggsci::scale_fill_npg(alpha=0.5)+
  theme(legend.position = 'none',
        axis.title.y = element_blank(),
        axis.title.x = element_text(hjust = 0.5))+xlim(85.5,88)+
  xlab('Balanced ACC (%)')+
  geom_vline(aes(xintercept=mean(`Balanced ACC`[Group=='Boy'])*100),
             colour=ggpubr::get_palette("npg",2)[1],
             linetype='dashed',
             linewidth=1.5,
             alpha=0.5)+
  geom_vline(aes(xintercept=mean(`Balanced ACC`[Group=='Girl'])*100),
             colour=ggpubr::get_palette("npg",2)[2],
             linetype='dashed',
             linewidth=1.5,
             alpha=0.5)+
  annotate('text',
           x=mean(data$`Balanced ACC`[data$Group=='Boy'])*100+0.01,
           y=1.6,
           colour = ggpubr::get_palette("npg",2)[1],
           size=5,
           hjust=0,
           label=sprintf("Boy=%.2f%%",
                         mean(data$`Balanced ACC`[data$Group=='Boy'])*100))+
  annotate('text',
           x=mean(data$`Balanced ACC`[data$Group=='Girl'])*100-0.01,
           y=1.9,
           colour = ggpubr::get_palette("npg",2)[2],
           size=5,
           hjust=1,
           label=sprintf("Girl=%.2f%%",
                         mean(data$`Balanced ACC`[data$Group=='Girl'])*100)) -> p
p
ggsave('../Res_2_Results/Res_SexSubgroup_BalaACC_Dep.png',
       bg = 'white',
       width = 6,
       height = 4,
       plot = p)
ggsave('../Res_2_Results/Res_SexSubgroup_BalaACC_Dep.svg',
       width = 6,
       height = 4,
       plot = p)

# Plot Coefs and Balanced ACC: Phase of studying-Subgroup -----------------
MdlMethod = 'DownSampMdl'
Subgroup = c('PrimarySchool','JuniorSchool','SeniorSchool')
Input_Dir = '../Res_2_Results/ResML_Subgroup_Dep/'
data <- Extract.Res.Coef(MdlMethod,Subgroup,Input_Dir)
data$Group <- factor(data$Group,
                     levels = c('PrimarySchool','JuniorSchool','SeniorSchool'))
pivot_longer(data,cols = c(Anxiety,`Perceived Stress`,`Academic Burn-out`,
                           `Internet Addiction`,`Non-suicidal Self-injury`,
                           `Be Bullied`,`Education Level (Grade)`),
             values_to = 'Feature Importance',
             names_to = 'Predictors') %>%
  select(`Feature Importance`,Predictors,Group) -> data_coef
data_coef$Predictors <- factor(data_coef$Predictors,
                               levels=c('Anxiety','Perceived Stress','Academic Burn-out',
                                        'Internet Addiction','Non-suicidal Self-injury',
                                        'Be Bullied','Education Level (Grade)'))
data_coef %>%
  ggplot(aes(x=Predictors,y=`Feature Importance`,fill=Group))+
  geom_violin(width=0.4,alpha=0.5,trim = T,scale = 'width')+
  geom_boxplot(outlier.shape = NA,width = 0.15,alpha=0.1,
               position = position_dodge(width = 0.4))+
  ggpubr::stat_anova_test(aes(group = Group),
                          label = 'p.adj.signif',
                          label.y = 7.6,
                          method = 'one_way',
                          p.adjust.method = 'bonferroni',
                          significance = list(cutpoints = c(0, 0.001, 0.01, 0.05, Inf),
                                              symbols = c("***", "**", "*", "ns")))+
  theme_bruce()+theme(axis.text.x = element_text(angle = 15,hjust = 1),
                      panel.grid.major.y = element_line(colour = 'gray80',
                                                        linewidth = 0.2,
                                                        linetype = 'dashed'),
                      legend.position = 'top',
                      legend.title = element_blank())+
  scale_fill_manual(values=ggpubr::get_palette("npg",5)[-1:-2]) -> p
p
ggsave('../Res_2_Results/Res_PhaseSubgroup_Coef_Dep.png',
       width = 8,
       height = 6,
       plot = p)
ggsave('../Res_2_Results/Res_PhaseSubgroup_Coef_Dep.svg',
       width = 8,
       height = 6,
       plot = p)
data$Group <- forcats::fct_rev(data$Group)
data %>%
  ggplot(aes(x=`Balanced ACC`*100,y=Group,fill=Group))+
  geom_density_ridges_gradient(scale = 0.8,
                               rel_min_height = 0.001,
                               panel_scaling = T)+
  theme_ridges()+ scale_fill_manual(values=alpha(ggpubr::get_palette("npg",5)[-1:-2],0.5))+
  theme(legend.position = 'none',
        axis.title.y = element_blank(),
        axis.title.x = element_text(hjust = 0.5),
        axis.text.y = element_text(angle=90,hjust=0.5,size = 7))+
  xlim(85.4,87.6)+
  xlab('Balanced ACC (%)')+
  geom_vline(aes(xintercept=mean(`Balanced ACC`[Group=='PrimarySchool'])*100),
             colour=ggpubr::get_palette("npg",5)[5],
             linetype='dashed',
             linewidth=1.5,
             alpha=0.5)+
  geom_vline(aes(xintercept=mean(`Balanced ACC`[Group=='JuniorSchool'])*100),
             colour=ggpubr::get_palette("npg",5)[4],
             linetype='dashed',
             linewidth=1.5,
             alpha=0.5)+
  geom_vline(aes(xintercept=mean(`Balanced ACC`[Group=='SeniorSchool'])*100),
             colour=ggpubr::get_palette("npg",5)[3],
             linetype='dashed',
             linewidth=1.5,
             alpha=0.5)+
  annotate('text',
           x=mean(data$`Balanced ACC`[data$Group=='PrimarySchool'])*100,
           y=3.5,
           colour = ggpubr::get_palette("npg",5)[5],
           size=4,
           hjust=1,
           label=sprintf("Primary School=%.2f%%",
                         mean(data$`Balanced ACC`[data$Group=='PrimarySchool'])*100))+
  annotate('text',
           x=mean(data$`Balanced ACC`[data$Group=='JuniorSchool'])*100-0.01,
           y=2.7,
           colour = ggpubr::get_palette("npg",5)[4],
           size=4,
           hjust=1,
           label=sprintf("Junior School=%.2f%%",
                         mean(data$`Balanced ACC`[data$Group=='JuniorSchool'])*100))+
  annotate('text',
           x=mean(data$`Balanced ACC`[data$Group=='SeniorSchool'])*100+0.01,
           y=1.85,
           colour = ggpubr::get_palette("npg",5)[3],
           size=4,
           hjust=0,
           label=sprintf("Senior School=%.2f%%",
                         mean(data$`Balanced ACC`[data$Group=='SeniorSchool'])*100))->p

p
ggsave('../Res_2_Results/Res_PhaseSubgroup_BalaACC_Dep.png',
       bg = 'white',
       width = 6,
       height = 4,
       plot = p)
ggsave('../Res_2_Results/Res_PhaseSubgroup_BalaACC_Dep.svg',
       width = 6,
       height = 4,
       plot = p)

# Plot Coefs and Balanced ACC: Geographic Area-Subgroup -------------------
MdlMethod = 'DownSampMdl'
Subgroup = c('Eastern','Northeast','Central','Western')
Input_Dir = '../Res_2_Results/ResML_Subgroup_Dep/'
data <- Extract.Res.Coef(MdlMethod,Subgroup,Input_Dir)
data$Group <- factor(data$Group,
                     levels =  c('Eastern','Northeast','Central','Western'))
pivot_longer(data,cols = c(Anxiety,`Perceived Stress`,`Academic Burn-out`,
                           `Internet Addiction`,`Non-suicidal Self-injury`,
                           `Be Bullied`,`Education Level (Grade)`),
             values_to = 'Feature Importance',
             names_to = 'Predictors') %>%
  select(`Feature Importance`,Predictors,Group) -> data_coef
data_coef$Predictors <- factor(data_coef$Predictors,
                               levels=c('Anxiety','Perceived Stress','Academic Burn-out',
                                        'Internet Addiction','Non-suicidal Self-injury',
                                        'Be Bullied','Education Level (Grade)'))
data_coef %>%
  ggplot(aes(x=Predictors,y=`Feature Importance`,fill=Group))+
  geom_violin(width=0.4,alpha=0.5,trim = T,scale = 'width')+
  geom_boxplot(outlier.shape = NA,width = 0.15,alpha=0.1,
               position = position_dodge(width = 0.4))+
  ggpubr::stat_anova_test(aes(group = Group),
                          label = 'p.adj.signif',
                          label.y = 7.6,
                          method = 'one_way',
                          p.adjust.method = 'bonferroni',
                          significance = list(cutpoints = c(0, 0.001, 0.01, 0.05, Inf),
                                              symbols = c("***", "**", "*", "ns")))+
  theme_bruce()+theme(axis.text.x = element_text(angle = 15,hjust = 1),
                      panel.grid.major.y = element_line(colour = 'gray80',
                                                        linewidth = 0.2,
                                                        linetype = 'dashed'),
                      legend.position = 'top',
                      legend.title = element_blank())+
  scale_fill_manual(values=ggpubr::get_palette("npg",9)[-1:-5])+ylim(0,8) -> p
p
ggsave('../Res_2_Results/Res_GeoAreaSubgroup_Coef_Dep.png',
       width = 8,
       height = 6,
       plot = p)
ggsave('../Res_2_Results/Res_GeoAreaSubgroup_Coef_Dep.svg',
       width = 8,
       height = 6,
       plot = p)
data$Group <- forcats::fct_rev(data$Group)
data %>%
  ggplot(aes(x=`Balanced ACC`*100,y=Group,fill=Group))+
  geom_density_ridges_gradient(scale = 0.8,
                               rel_min_height = 0.001,
                               panel_scaling = T)+
  theme_ridges()+ scale_fill_manual(values=alpha(ggpubr::get_palette("npg",9)[-1:-5],0.5))+
  theme(legend.position = 'none',
        axis.title.y = element_blank(),
        axis.title.x = element_text(hjust = 0.5),
        axis.text.y = element_text(angle=90,hjust=0.5,size = 7))+
  xlim(85,87.5)+
  xlab('Balanced ACC (%)')+
  geom_vline(aes(xintercept=mean(`Balanced ACC`[Group=='Eastern'])*100),
             colour=ggpubr::get_palette("npg",9)[9],
             linetype='dashed',
             linewidth=1.5,
             alpha=0.5)+
  geom_vline(aes(xintercept=mean(`Balanced ACC`[Group=='Northeast'])*100),
             colour=ggpubr::get_palette("npg",9)[8],
             linetype='dashed',
             linewidth=1.5,
             alpha=0.5)+
  geom_vline(aes(xintercept=mean(`Balanced ACC`[Group=='Central'])*100),
             colour=ggpubr::get_palette("npg",9)[7],
             linetype='dashed',
             linewidth=1.5,
             alpha=0.5)+
  geom_vline(aes(xintercept=mean(`Balanced ACC`[Group=='Western'])*100),
             colour=ggpubr::get_palette("npg",9)[6],
             linetype='dashed',
             linewidth=1.5,
             alpha=0.5)+
  annotate('text',
           x=mean(data$`Balanced ACC`[data$Group=='Eastern'])*100,
           y=3.9,
           colour = ggpubr::get_palette("npg",9)[9],
           size=4,
           hjust=0.5,
           label=sprintf("Eastern China=%.2f%%",
                         mean(data$`Balanced ACC`[data$Group=='Eastern'])*100))+
  annotate('text',
           x=mean(data$`Balanced ACC`[data$Group=='Northeast'])*100,
           y=3.5,
           colour = ggpubr::get_palette("npg",9)[8],
           size=4,
           hjust=0.5,
           label=sprintf("Northeast China=%.2f%%",
                         mean(data$`Balanced ACC`[data$Group=='Northeast'])*100))+
  annotate('text',
           x=mean(data$`Balanced ACC`[data$Group=='Central'])*100,
           y=2.75,
           colour = ggpubr::get_palette("npg",9)[7],
           size=4,
           hjust=0.5,
           label=sprintf("Central China=%.2f%%",
                         mean(data$`Balanced ACC`[data$Group=='Central'])*100))+
  annotate('text',
           x=mean(data$`Balanced ACC`[data$Group=='Western'])*100,
           y=1.85,
           colour = ggpubr::get_palette("npg",9)[6],
           size=4,
           hjust=0.5,
           label=sprintf("Western China=%.2f%%",
                         mean(data$`Balanced ACC`[data$Group=='Western'])*100)) ->p

p
ggsave('../Res_2_Results/Res_GeoAreaSubgroup_BalaACC_Dep.png',
       bg = 'white',
       width = 6,
       height = 4,
       plot = p)
ggsave('../Res_2_Results/Res_GeoAreaSubgroup_BalaACC_Dep.svg',
       width = 6,
       height = 4,
       plot = p)