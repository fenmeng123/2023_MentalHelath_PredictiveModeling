<<<<<<< HEAD
library(bruceR)
library(svglite)
library(openxlsx)
set.wd()

file.list <- dir(path = '../Res_2_Results/ResML_CompareAlogrithm_Suicide/',
                 pattern = '.*M.*xlsx$',
                 full.names = T)

# Generate Bar Plot for 4 key performance indices -------------------------

res <- data.frame()

for (i in 1:length(file.list)){
  read.xlsx(file.list[[i]]) %>% 
    select(c(name,ACC,balacc,
             Sensitivity,Specificity)) %>% 
    rename(Model = name,
           'BalancedACC' = balacc) -> tmp
  res <- rbind(res,tmp)
}
str_remove(res$Model,'M[0-9]_') %>%
  str_remove('M[0-9][0-9]_') %>%
  str_replace_all('L2Logit','LogisticR') %>%
  str_replace_all('LinearLDA','LDA') %>%
  str_replace_all('RidgeClassifer','RidgeC') %>%
  str_replace_all('LinearSVC','SVM-linear') %>%
  str_replace_all('Perceptron','Perceptron') %>%
  str_replace_all('PassiaveAggressiveClassifier','PAC') %>%
  str_replace_all('DecisionTree','DT') %>%
  str_replace_all('Naive_Bayes','NB') %>%
  str_replace_all('rbfSVC','SVM-rbf') %>%
  str_replace_all('polySVC','SVM-poly') %>%
  str_replace_all('sigmoidSVC','SVM-sigmoid') %>%
  str_replace_all('GradientBoost','GBDT') %>%
  str_replace_all('RandomForest','RF') -> res$Model
res$Model <- factor(res$Model,
                    levels = c('LDA',
                               'LogisticR',
                               'RidgeC',
                               'SVM-linear',
                               'PAC',
                               'Perceptron',
                               'KNN',
                               'SVM-poly',
                               'SVM-rbf',
                               'SVM-sigmoid',
                               'DT',
                               'NB',
                               'MLP',
                               'GBDT',
                               'RF'))
# Box plot+violin plot ----------------------------------------------------

res %>% pivot_longer(c(ACC,BalancedACC,Sensitivity,Specificity),
                     names_to = 'IdxType',values_to = 'Performance') -> long_res
long_res$IdxType <- factor(long_res$IdxType,
                           levels = c('ACC','BalancedACC',
                                      'Sensitivity','Specificity'))


p <- ggplot(long_res, aes(x = Model,y = Performance,
                          colour = Model)) +
  geom_boxplot(position = position_dodge(width=0.9),
               width = 0.7,outlier.shape=NA,
               notchwidth = 0.3)+
  coord_cartesian(ylim = c(0.25, 1),expand = T)+
  scale_y_continuous(breaks=c(0.25,0.5,0.75,1), labels = c('25%','50%','75%','100%'))+
  theme_bruce()+
  theme(panel.grid.major.y = element_line(linetype = 'dashed',linewidth = 0.8))+
  theme(axis.text.x = element_text(angle = 0))+
  theme(axis.ticks.x = element_blank(),axis.text.x = element_blank())+
  ggsci::scale_color_simpsons()+
  xlab('Model Evaluation Indices')+
  ylab('Prediction Performance')+
  labs(title = 'Predictive Models for Suicidal Ideation')+
  facet_grid(cols = vars(IdxType))
p

ggsave(filename = '../Res_2_Results/Res_Boxplot_CompMdl_Suicide.png',
       plot = p)
ggsave(filename = '../Res_2_Results/Res_Boxplot_CompMdl_Suicide.svg',
       plot = p)

# Separate four indices into four plots -----------------------------------
# Balanced ACC
psych::describeBy(BalancedACC~Model,mat = T,
                  data = dplyr::select(res,c(BalancedACC,Model))) -> Sum_BACC
Sum_BACC$MdlType <- c('Linear','Linear','Linear','Linear','Linear','Linear',
                      'Non-linear','Non-linear','Non-linear',
                      'Tree Model','Generative Model')
Sum_BACC$group1 <- factor(Sum_BACC$group1,
                          levels = c('LDA',
                                     'LogisticR',
                                     'RidgeC',
                                     'SVM-linear',
                                     'PAC',
                                     'Perceptron',
                                     'KNN',
                                     'SVM-poly',
                                     'SVM-rbf',
                                     'DT',
                                     'NB'))

p <- ggplot(Sum_BACC, aes(x = group1, y = mean, color = group1,fill = group1)) +
  geom_bar(stat = 'identity',alpha=0.5,width = 0.7)+
  geom_point(size=2)+
  geom_errorbar(aes(ymin=mean-sd,ymax=mean+sd),width=0.25,linewidth=1)+
  labs(title = "Spilt-half Prediction Performance")+
  xlab('Machine Learning Model (Algorithm)')+ylab('Balanced Accuracy')+theme_bruce()+
  theme(panel.grid.major.y = element_line(linetype = 'dashed',linewidth = 0.8))+
  theme(axis.text.x = element_text(angle = -15))+
  coord_cartesian(ylim = c(0.7, 0.9))+
  ggsci::scale_color_igv()+
  ggsci::scale_fill_igv()+
  theme(legend.position = "none")
ggsave(filename = '../Res_2_Results/Res_Barplot_BACC_CompMdl_Suicide.png',
       plot = p)
ggsave(filename = '../Res_2_Results/Res_Barplot_BACC_CompMdl_Suicide.svg',
       plot = p)
# ACC
psych::describeBy(ACC~Model,mat = T,
                  data = dplyr::select(res,c(ACC,Model))) -> Sum_ACC
Sum_ACC$MdlType <- c('Linear','Linear','Linear','Linear','Linear','Linear',
                     'Non-linear','Non-linear','Non-linear',
                     'Tree Model','Generative Model')
Sum_ACC$group1 <- factor(Sum_ACC$group1,
                         levels = c('LDA',
                                    'LogisticR',
                                    'RidgeC',
                                    'SVM-linear',
                                    'PAC',
                                    'Perceptron',
                                    'KNN',
                                    'SVM-poly',
                                    'SVM-rbf',
                                    'DT',
                                    'NB'))
p <- ggplot(Sum_ACC, aes(x = group1, y = mean, color = group1,fill = group1)) +
  geom_bar(stat = 'identity',alpha=0.5,width = 0.7)+
  geom_point(size=2)+
  geom_errorbar(aes(ymin=mean-sd,ymax=mean+sd),width=0.25,linewidth=1)+
  labs(title = "Spilt-half Prediction Performance")+
  xlab('Machine Learning Model (Algorithm)')+ylab('Accuracy')+theme_bruce()+
  theme(panel.grid.major.y = element_line(linetype = 'dashed',linewidth = 0.8))+
  theme(axis.text.x = element_text(angle = -15))+
  coord_cartesian(ylim = c(0.7, 1))+
  ggsci::scale_color_igv()+
  ggsci::scale_fill_igv()+
  theme(legend.position = "none")
ggsave(filename = '../Res_2_Results/Res_Barplot_ACC_CompMdl_Suicide.png',
       plot = p)
ggsave(filename = '../Res_2_Results/Res_Barplot_ACC_CompMdl_Suicide.svg',
       plot = p)
# Sensitivity
psych::describeBy(Sensitivity~Model,mat = T,
                  data = dplyr::select(res,c(Sensitivity,Model))) -> Sum_Sen
Sum_Sen$MdlType <- c('Linear','Linear','Linear','Linear','Linear','Linear',
                     'Non-linear','Non-linear','Non-linear',
                     'Tree Model','Generative Model')
Sum_Sen$group1 <- factor(Sum_Sen$group1,
                         levels = c('LDA',
                                    'LogisticR',
                                    'RidgeC',
                                    'SVM-linear',
                                    'PAC',
                                    'Perceptron',
                                    'KNN',
                                    'SVM-poly',
                                    'SVM-rbf',
                                    'DT',
                                    'NB'))
p <- ggplot(Sum_Sen, aes(x = group1, y = mean, color = group1,fill = group1)) +
  geom_bar(stat = 'identity',alpha=0.5,width = 0.7)+
  geom_point(size=2)+
  geom_errorbar(aes(ymin=mean-sd,ymax=mean+sd),width=0.25,linewidth=1)+
  labs(title = "Spilt-half Prediction Performance")+
  xlab('Machine Learning Model (Algorithm)')+ylab('Sensitivity')+theme_bruce()+
  theme(panel.grid.major.y = element_line(linetype = 'dashed',linewidth = 0.8))+
  theme(axis.text.x = element_text(angle = -15))+
  coord_cartesian(ylim = c(0.5, 1))+
  ggsci::scale_color_igv()+
  ggsci::scale_fill_igv()+
  theme(legend.position = "none")
ggsave(filename = '../Res_2_Results/Res_Barplot_Sen_CompMdl_Suicide.png',
       plot = p)
ggsave(filename = '../Res_2_Results/Res_Barplot_Sen_CompMdl_Suicide.svg',
       plot = p)
# Specificity
psych::describeBy(Specificity~Model,mat = T,
                  data = dplyr::select(res,c(Specificity,Model))) -> Sum_Spe
Sum_Spe$MdlType <- c('Linear','Linear','Linear','Linear','Linear','Linear',
                     'Non-linear','Non-linear','Non-linear',
                     'Tree Model','Generative Model')
Sum_Spe$group1 <- factor(Sum_Spe$group1,
                         levels = c('LDA',
                                    'LogisticR',
                                    'RidgeC',
                                    'SVM-linear',
                                    'PAC',
                                    'Perceptron',
                                    'KNN',
                                    'SVM-poly',
                                    'SVM-rbf',
                                    'DT',
                                    'NB'))
p <- ggplot(Sum_Spe, aes(x = group1, y = mean, color = group1,fill = group1)) +
  geom_bar(stat = 'identity',alpha=0.5,width = 0.7)+
  geom_point(size=2)+
  geom_errorbar(aes(ymin=mean-sd,ymax=mean+sd),width=0.25,linewidth=1)+
  labs(title = "Spilt-half Prediction Performance")+
  xlab('Machine Learning Model (Algorithm)')+ylab('Specificity')+theme_bruce()+
  theme(panel.grid.major.y = element_line(linetype = 'dashed',linewidth = 0.8))+
  theme(axis.text.x = element_text(angle = -15))+
  coord_cartesian(ylim = c(0.5, 1))+
  ggsci::scale_color_igv()+
  ggsci::scale_fill_igv()+
  theme(legend.position = "none")
ggsave(filename = '../Res_2_Results/Res_Barplot_Spe_CompMdl_Suicide.png',
       plot = p)
ggsave(filename = '../Res_2_Results/Res_Barplot_Spe_CompMdl_Suicide.svg',
       plot = p)

# Generate Result Summary Table -------------------------------------------

res <- data.frame()

for (i in 1:length(file.list)){
  read.xlsx(file.list[[i]]) %>%
    select(-c(X1,IterNum)) %>%
    rename(Model = name,
           'BalancedACC' = balacc) -> tmp
  res <- rbind(res,tmp)
}
str_remove(res$Model,'M[0-9]_') %>%
  str_remove('M[0-9][0-9]_') %>%
  str_replace_all('L2Logit','LogisticR') %>%
  str_replace_all('LinearLDA','LDA') %>%
  str_replace_all('RidgeClassifer','RidgeC') %>%
  str_replace_all('LinearSVC','SVM-linear') %>%
  str_replace_all('Perceptron','Perceptron') %>%
  str_replace_all('PassiaveAggressiveClassifier','PAC') %>%
  str_replace_all('DecisionTree','DT') %>%
  str_replace_all('Naive_Bayes','NB') %>%
  str_replace_all('rbfSVC','SVM-rbf') %>%
  str_replace_all('polySVC','SVM-poly') %>%
  str_replace_all('sigmoidSVC','SVM-sigmoid') %>%
  str_replace_all('GradientBoost','GBDT') %>%
  str_replace_all('RandomForest','RF') -> res$Model
res$Model <- factor(res$Model,
                    levels = c('LDA',
                               'LogisticR',
                               'RidgeC',
                               'SVM-linear',
                               'PAC',
                               'Perceptron',
                               'KNN',
                               'SVM-poly',
                               'SVM-rbf',
                               'SVM-sigmoid',
                               'DT',
                               'NB',
                               'MLP',
                               'GBDT',
                               'RF'))
psych::describeBy(ACC+BalancedACC+Specificity+Sensitivity+F1_score+PPV+NPV~Model,mat = T,
                  data = res) -> Sum_Res

select(Sum_Res,c(group1,mean,sd,min,max)) %>%
  rename(Model = group1) -> Sum_Res
Sum_Res$Index <- rownames(Sum_Res)
rownames(Sum_Res) <- NULL
Sum_Res$Index <- str_remove(Sum_Res$Index,'\\d{1,}$')
Res_Table <- data.frame(Num=1:length(unique(Sum_Res$Model)))
for (i in unique(Sum_Res$Index)){
  tmp <- subset(Sum_Res,Index==i)
  if (i == 'F1_score'){
    tmp$mean = sprintf('%.4f',tmp$mean)
    tmp$sd = sprintf('%.4f',tmp$sd)
    tmp$min = sprintf('%.4f',tmp$min)
    tmp$max = sprintf('%.4f',tmp$max)
  }else{
    tmp$mean = sprintf('%2.2f%%',tmp$mean*100)
    tmp$sd = sprintf('%2.2f%%',tmp$sd*100)
    tmp$min = sprintf('%2.2f%%',tmp$min*100)
    tmp$max = sprintf('%2.2f%%',tmp$max*100)
  }
  tmp$MeanSD <- str_c(tmp$mean,' (',tmp$sd,')')
  tmp$MinMax <- str_c('[',tmp$min,', ',tmp$max,']')
  tmp$Value <- str_c(tmp$MeanSD,' ',tmp$MinMax)
  ModelName <- tmp$Model
  Index <- unique(tmp$Index)
  tmp <- select(tmp,Value)
  colnames(tmp) <- Index
  Res_Table <- cbind(Res_Table,tmp)
}
Res_Table$Model <- ModelName
Res_Table <- select(Res_Table,c(Model,everything()))
Res_Table <- select(Res_Table,-Num)                  
print_table(Res_Table,digits = 4,row.names = F,
            file = '../Res_2_Results/Res_SummaryT_CompMdl_Suicide.doc')
=======
library(bruceR)
library(svglite)
library(openxlsx)
set.wd()

file.list <- dir(path = '../Res_2_Results/ResML_CompareAlogrithm_Suicide/',
                 pattern = '.*M.*xlsx$',
                 full.names = T)

# Generate Bar Plot for 4 key performance indices -------------------------

res <- data.frame()

for (i in 1:length(file.list)){
  read.xlsx(file.list[[i]]) %>% 
    select(c(name,ACC,balacc,
             Sensitivity,Specificity)) %>% 
    rename(Model = name,
           'BalancedACC' = balacc) -> tmp
  res <- rbind(res,tmp)
}
str_remove(res$Model,'M[0-9]_') %>%
  str_remove('M[0-9][0-9]_') %>%
  str_replace_all('L2Logit','LogisticR') %>%
  str_replace_all('LinearLDA','LDA') %>%
  str_replace_all('RidgeClassifer','RidgeC') %>%
  str_replace_all('LinearSVC','SVM-linear') %>%
  str_replace_all('Perceptron','Perceptron') %>%
  str_replace_all('PassiaveAggressiveClassifier','PAC') %>%
  str_replace_all('DecisionTree','DT') %>%
  str_replace_all('Naive_Bayes','NB') %>%
  str_replace_all('rbfSVC','SVM-rbf') %>%
  str_replace_all('polySVC','SVM-poly') %>%
  str_replace_all('sigmoidSVC','SVM-sigmoid') %>%
  str_replace_all('GradientBoost','GBDT') %>%
  str_replace_all('RandomForest','RF') -> res$Model
res$Model <- factor(res$Model,
                    levels = c('LDA',
                               'LogisticR',
                               'RidgeC',
                               'SVM-linear',
                               'PAC',
                               'Perceptron',
                               'KNN',
                               'SVM-poly',
                               'SVM-rbf',
                               'SVM-sigmoid',
                               'DT',
                               'NB',
                               'MLP',
                               'GBDT',
                               'RF'))
# Box plot+violin plot ----------------------------------------------------

res %>% pivot_longer(c(ACC,BalancedACC,Sensitivity,Specificity),
                     names_to = 'IdxType',values_to = 'Performance') -> long_res
long_res$IdxType <- factor(long_res$IdxType,
                           levels = c('ACC','BalancedACC',
                                      'Sensitivity','Specificity'))


p <- ggplot(long_res, aes(x = Model,y = Performance,
                          colour = Model)) +
  geom_boxplot(position = position_dodge(width=0.9),
               width = 0.7,outlier.shape=NA,
               notchwidth = 0.3)+
  coord_cartesian(ylim = c(0.25, 1),expand = T)+
  scale_y_continuous(breaks=c(0.25,0.5,0.75,1), labels = c('25%','50%','75%','100%'))+
  theme_bruce()+
  theme(panel.grid.major.y = element_line(linetype = 'dashed',linewidth = 0.8))+
  theme(axis.text.x = element_text(angle = 0))+
  theme(axis.ticks.x = element_blank(),axis.text.x = element_blank())+
  ggsci::scale_color_simpsons()+
  xlab('Model Evaluation Indices')+
  ylab('Prediction Performance')+
  labs(title = 'Predictive Models for Suicidal Ideation')+
  facet_grid(cols = vars(IdxType))
p

ggsave(filename = '../Res_2_Results/Res_Boxplot_CompMdl_Suicide.png',
       plot = p)
ggsave(filename = '../Res_2_Results/Res_Boxplot_CompMdl_Suicide.svg',
       plot = p)

# Separate four indices into four plots -----------------------------------
# Balanced ACC
psych::describeBy(BalancedACC~Model,mat = T,
                  data = dplyr::select(res,c(BalancedACC,Model))) -> Sum_BACC
Sum_BACC$MdlType <- c('Linear','Linear','Linear','Linear','Linear','Linear',
                      'Non-linear','Non-linear','Non-linear',
                      'Tree Model','Generative Model')
Sum_BACC$group1 <- factor(Sum_BACC$group1,
                          levels = c('LDA',
                                     'LogisticR',
                                     'RidgeC',
                                     'SVM-linear',
                                     'PAC',
                                     'Perceptron',
                                     'KNN',
                                     'SVM-poly',
                                     'SVM-rbf',
                                     'DT',
                                     'NB'))

p <- ggplot(Sum_BACC, aes(x = group1, y = mean, color = group1,fill = group1)) +
  geom_bar(stat = 'identity',alpha=0.5,width = 0.7)+
  geom_point(size=2)+
  geom_errorbar(aes(ymin=mean-sd,ymax=mean+sd),width=0.25,linewidth=1)+
  labs(title = "Spilt-half Prediction Performance")+
  xlab('Machine Learning Model (Algorithm)')+ylab('Balanced Accuracy')+theme_bruce()+
  theme(panel.grid.major.y = element_line(linetype = 'dashed',linewidth = 0.8))+
  theme(axis.text.x = element_text(angle = -15))+
  coord_cartesian(ylim = c(0.7, 0.9))+
  ggsci::scale_color_igv()+
  ggsci::scale_fill_igv()+
  theme(legend.position = "none")
ggsave(filename = '../Res_2_Results/Res_Barplot_BACC_CompMdl_Suicide.png',
       plot = p)
ggsave(filename = '../Res_2_Results/Res_Barplot_BACC_CompMdl_Suicide.svg',
       plot = p)
# ACC
psych::describeBy(ACC~Model,mat = T,
                  data = dplyr::select(res,c(ACC,Model))) -> Sum_ACC
Sum_ACC$MdlType <- c('Linear','Linear','Linear','Linear','Linear','Linear',
                     'Non-linear','Non-linear','Non-linear',
                     'Tree Model','Generative Model')
Sum_ACC$group1 <- factor(Sum_ACC$group1,
                         levels = c('LDA',
                                    'LogisticR',
                                    'RidgeC',
                                    'SVM-linear',
                                    'PAC',
                                    'Perceptron',
                                    'KNN',
                                    'SVM-poly',
                                    'SVM-rbf',
                                    'DT',
                                    'NB'))
p <- ggplot(Sum_ACC, aes(x = group1, y = mean, color = group1,fill = group1)) +
  geom_bar(stat = 'identity',alpha=0.5,width = 0.7)+
  geom_point(size=2)+
  geom_errorbar(aes(ymin=mean-sd,ymax=mean+sd),width=0.25,linewidth=1)+
  labs(title = "Spilt-half Prediction Performance")+
  xlab('Machine Learning Model (Algorithm)')+ylab('Accuracy')+theme_bruce()+
  theme(panel.grid.major.y = element_line(linetype = 'dashed',linewidth = 0.8))+
  theme(axis.text.x = element_text(angle = -15))+
  coord_cartesian(ylim = c(0.7, 1))+
  ggsci::scale_color_igv()+
  ggsci::scale_fill_igv()+
  theme(legend.position = "none")
ggsave(filename = '../Res_2_Results/Res_Barplot_ACC_CompMdl_Suicide.png',
       plot = p)
ggsave(filename = '../Res_2_Results/Res_Barplot_ACC_CompMdl_Suicide.svg',
       plot = p)
# Sensitivity
psych::describeBy(Sensitivity~Model,mat = T,
                  data = dplyr::select(res,c(Sensitivity,Model))) -> Sum_Sen
Sum_Sen$MdlType <- c('Linear','Linear','Linear','Linear','Linear','Linear',
                     'Non-linear','Non-linear','Non-linear',
                     'Tree Model','Generative Model')
Sum_Sen$group1 <- factor(Sum_Sen$group1,
                         levels = c('LDA',
                                    'LogisticR',
                                    'RidgeC',
                                    'SVM-linear',
                                    'PAC',
                                    'Perceptron',
                                    'KNN',
                                    'SVM-poly',
                                    'SVM-rbf',
                                    'DT',
                                    'NB'))
p <- ggplot(Sum_Sen, aes(x = group1, y = mean, color = group1,fill = group1)) +
  geom_bar(stat = 'identity',alpha=0.5,width = 0.7)+
  geom_point(size=2)+
  geom_errorbar(aes(ymin=mean-sd,ymax=mean+sd),width=0.25,linewidth=1)+
  labs(title = "Spilt-half Prediction Performance")+
  xlab('Machine Learning Model (Algorithm)')+ylab('Sensitivity')+theme_bruce()+
  theme(panel.grid.major.y = element_line(linetype = 'dashed',linewidth = 0.8))+
  theme(axis.text.x = element_text(angle = -15))+
  coord_cartesian(ylim = c(0.5, 1))+
  ggsci::scale_color_igv()+
  ggsci::scale_fill_igv()+
  theme(legend.position = "none")
ggsave(filename = '../Res_2_Results/Res_Barplot_Sen_CompMdl_Suicide.png',
       plot = p)
ggsave(filename = '../Res_2_Results/Res_Barplot_Sen_CompMdl_Suicide.svg',
       plot = p)
# Specificity
psych::describeBy(Specificity~Model,mat = T,
                  data = dplyr::select(res,c(Specificity,Model))) -> Sum_Spe
Sum_Spe$MdlType <- c('Linear','Linear','Linear','Linear','Linear','Linear',
                     'Non-linear','Non-linear','Non-linear',
                     'Tree Model','Generative Model')
Sum_Spe$group1 <- factor(Sum_Spe$group1,
                         levels = c('LDA',
                                    'LogisticR',
                                    'RidgeC',
                                    'SVM-linear',
                                    'PAC',
                                    'Perceptron',
                                    'KNN',
                                    'SVM-poly',
                                    'SVM-rbf',
                                    'DT',
                                    'NB'))
p <- ggplot(Sum_Spe, aes(x = group1, y = mean, color = group1,fill = group1)) +
  geom_bar(stat = 'identity',alpha=0.5,width = 0.7)+
  geom_point(size=2)+
  geom_errorbar(aes(ymin=mean-sd,ymax=mean+sd),width=0.25,linewidth=1)+
  labs(title = "Spilt-half Prediction Performance")+
  xlab('Machine Learning Model (Algorithm)')+ylab('Specificity')+theme_bruce()+
  theme(panel.grid.major.y = element_line(linetype = 'dashed',linewidth = 0.8))+
  theme(axis.text.x = element_text(angle = -15))+
  coord_cartesian(ylim = c(0.5, 1))+
  ggsci::scale_color_igv()+
  ggsci::scale_fill_igv()+
  theme(legend.position = "none")
ggsave(filename = '../Res_2_Results/Res_Barplot_Spe_CompMdl_Suicide.png',
       plot = p)
ggsave(filename = '../Res_2_Results/Res_Barplot_Spe_CompMdl_Suicide.svg',
       plot = p)

# Generate Result Summary Table -------------------------------------------

res <- data.frame()

for (i in 1:length(file.list)){
  read.xlsx(file.list[[i]]) %>%
    select(-c(X1,IterNum)) %>%
    rename(Model = name,
           'BalancedACC' = balacc) -> tmp
  res <- rbind(res,tmp)
}
str_remove(res$Model,'M[0-9]_') %>%
  str_remove('M[0-9][0-9]_') %>%
  str_replace_all('L2Logit','LogisticR') %>%
  str_replace_all('LinearLDA','LDA') %>%
  str_replace_all('RidgeClassifer','RidgeC') %>%
  str_replace_all('LinearSVC','SVM-linear') %>%
  str_replace_all('Perceptron','Perceptron') %>%
  str_replace_all('PassiaveAggressiveClassifier','PAC') %>%
  str_replace_all('DecisionTree','DT') %>%
  str_replace_all('Naive_Bayes','NB') %>%
  str_replace_all('rbfSVC','SVM-rbf') %>%
  str_replace_all('polySVC','SVM-poly') %>%
  str_replace_all('sigmoidSVC','SVM-sigmoid') %>%
  str_replace_all('GradientBoost','GBDT') %>%
  str_replace_all('RandomForest','RF') -> res$Model
res$Model <- factor(res$Model,
                    levels = c('LDA',
                               'LogisticR',
                               'RidgeC',
                               'SVM-linear',
                               'PAC',
                               'Perceptron',
                               'KNN',
                               'SVM-poly',
                               'SVM-rbf',
                               'SVM-sigmoid',
                               'DT',
                               'NB',
                               'MLP',
                               'GBDT',
                               'RF'))
psych::describeBy(ACC+BalancedACC+Specificity+Sensitivity+F1_score+PPV+NPV~Model,mat = T,
                  data = res) -> Sum_Res

select(Sum_Res,c(group1,mean,sd,min,max)) %>%
  rename(Model = group1) -> Sum_Res
Sum_Res$Index <- rownames(Sum_Res)
rownames(Sum_Res) <- NULL
Sum_Res$Index <- str_remove(Sum_Res$Index,'\\d{1,}$')
Res_Table <- data.frame(Num=1:length(unique(Sum_Res$Model)))
for (i in unique(Sum_Res$Index)){
  tmp <- subset(Sum_Res,Index==i)
  if (i == 'F1_score'){
    tmp$mean = sprintf('%.4f',tmp$mean)
    tmp$sd = sprintf('%.4f',tmp$sd)
    tmp$min = sprintf('%.4f',tmp$min)
    tmp$max = sprintf('%.4f',tmp$max)
  }else{
    tmp$mean = sprintf('%2.2f%%',tmp$mean*100)
    tmp$sd = sprintf('%2.2f%%',tmp$sd*100)
    tmp$min = sprintf('%2.2f%%',tmp$min*100)
    tmp$max = sprintf('%2.2f%%',tmp$max*100)
  }
  tmp$MeanSD <- str_c(tmp$mean,' (',tmp$sd,')')
  tmp$MinMax <- str_c('[',tmp$min,', ',tmp$max,']')
  tmp$Value <- str_c(tmp$MeanSD,' ',tmp$MinMax)
  ModelName <- tmp$Model
  Index <- unique(tmp$Index)
  tmp <- select(tmp,Value)
  colnames(tmp) <- Index
  Res_Table <- cbind(Res_Table,tmp)
}
Res_Table$Model <- ModelName
Res_Table <- select(Res_Table,c(Model,everything()))
Res_Table <- select(Res_Table,-Num)                  
print_table(Res_Table,digits = 4,row.names = F,
            file = '../Res_2_Results/Res_SummaryT_CompMdl_Suicide.doc')
>>>>>>> origin/main
