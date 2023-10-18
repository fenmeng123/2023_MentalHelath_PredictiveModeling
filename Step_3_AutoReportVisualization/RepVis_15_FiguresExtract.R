library(bruceR)
set.wd()
rm(list=ls())
gc()
ResDir = '../Res_2_Results/'
if (!dir.exists('../Res_4_Reports_for_Manuscript/Figure1/')){
  dir.create('../Res_4_Reports_for_Manuscript/Figure1/',recursive = T)
}
if (!dir.exists('../Res_4_Reports_for_Manuscript/Figure2/')){
  dir.create('../Res_4_Reports_for_Manuscript/Figure2/',recursive = T)
}
if (!dir.exists('../Res_4_Reports_for_Manuscript/Figure3/')){
  dir.create('../Res_4_Reports_for_Manuscript/Figure3/',recursive = T)
}
if (!dir.exists('../Res_4_Reports_for_Manuscript/Figure4/')){
  dir.create('../Res_4_Reports_for_Manuscript/Figure4/',recursive = T)
}
if (!dir.exists('../Res_4_Reports_for_Manuscript/FigureS1/')){
  dir.create('../Res_4_Reports_for_Manuscript/FigureS1/',recursive = T)
}
if (!dir.exists('../Res_4_Reports_for_Manuscript/FigureS2/')){
  dir.create('../Res_4_Reports_for_Manuscript/FigureS2/',recursive = T)
}
fig.comp.ls = list(Figure1 = c('Figure_1_Analysis_Flowchart.wmf'),
                   Figure2 = c('Res_Boxplot_CompMdl_Dep.svg',
                               'Res_Boxplot_CompMdl_Suicide.svg',
                               'Res_RidgesPlot_CoefsFreq_Dep.svg',
                               'Res_RidgesPlot_CoefsFreq_Suicide.svg',
                               'Res_Lineplot_FineTune_Dep.svg',
                               'Res_Lineplot_HyperparaOptim_Dep.svg',
                               'Res_Lineplot_FineTune_Suicide.svg',
                               'Res_Lineplot_HyperparaOptim_Suicide.svg'),
                   Figure3 = c('Res_RidgesBalacc_OOSD_Dep.svg',
                               'Res_RidgesBalacc_OOSD_Suicide.svg',
                               'Res_CoefRidges_OOSD_Dep.svg',
                               'Res_CoefRidges_OOSD_Suicide.svg'),
                   Figure4 = c('Res_SexSubgroup_BalaACC_Dep.svg','Res_SexSubgroup_Coef_Dep.svg',
                               'Res_SexSubgroup_BalaACC_Suicide.svg','Res_SexSubgroup_Coef_Suicide.svg',
                               'Res_PhaseSubgroup_BalaACC_Dep.svg','Res_PhaseSubgroup_Coef_Dep.svg',
                               'Res_PhaseSubgroup_BalaACC_Suicide.svg','Res_PhaseSubgroup_Coef_Suicide.svg',
                               'Res_GeoAreaSubgroup_BalaACC_Dep.svg','Res_GeoAreaSubgroup_Coef_Dep.svg',
                               'Res_GeoAreaSubgroup_BalaACC_Suicide.svg','Res_GeoAreaSubgroup_Coef_Suicide.svg'),
                   FigureS1 = c('BarPlot_SexByArea.svg','BarPlot_SexByGrade.svg',
                                'DistributionPlot_AgeBySex.svg',
                                'DistributionPlot_AgeByGrade.svg',
                                'DistributionPlot_AgeByArea.svg'),
                   FigureS2 = c('Distribution_weightedIRV.svg',
                                'Distribution_IRVnumber.svg',
                                'Distribution_Maxlongstring.svg',
                                'Distribution_EvenOdd.svg',
                                'Distribution_D2.svg',
                                'Distribution_ResponseTime.svg',
                                'pheatmap_CarelessIndics.png',
                                'Corr_CarelessIndics.png'))
fig.name.ls = list(Figure1 = 'Figure_1_@.wmf',
                   Figure2 = c('Figure_2_A_@_Model Comparision-Depression.svg',
                               'Figure_2_C_@_Model Comparision-Suicidal Ideation.svg',
                               'Figure_2_B_@_Feature Evaluation-Depression.svg',
                               'Figure_2_D_@_Feature Evaluation-Suicidal Ideation .svg',
                               'Figure_2_E_Inner_@_Fine Tune-Depression.svg',
                               'Figure_2_E_@_Hyperparameter Optimization-Depression.svg',
                               'Figure_2_F_Inner_@_Fine Tune-Suicidal Ideation.svg',
                               'Figure_2_F_@_Hyperparameter Optimization-Suicidal Ideation.svg'),
                   Figure3 = c('Figure_3_A_@_Out_of_sample Evaluation-Depression.svg',
                               'Figure_3_B_@_Out_of_sample Evaluation-Suicidal Ideation.svg',
                               'Figure_3_C_@_Feature Importance-Depression.svg',
                               'Figure_3_D_@_Feature Importance-Suicidal Ideation.svg'),
                   Figure4 = c('Figure_4_A_R_@_Biological Sex-Balanced ACC-Depression.svg',
                               'Figure_4_A_L_@_Biological Sex-Feature Importance-Depression.svg',
                               'Figure_4_D_R_@_Biological Sex-Balanced ACC-Suicidial Ideation.svg',
                               'Figure_4_D_L_@_Biological Sex-Feature Importance-Suicidial Ideation.svg',
                               'Figure_4_B_R_@_Educational Stage-Balanced ACC-Depression.svg',
                               'Figure_4_B_L_@_Educational Stage-Feature Importance-Depression.svg',
                               'Figure_4_E_R_@_Educational Stage-Balanced ACC-Suicidial Ideation.svg',
                               'Figure_4_E_L_@_Educational Stage-Feature Importance-Suicidial Ideation.svg',
                               'Figure_4_C_R_@_Geographic Area-Balanced ACC-Depression.svg',
                               'Figure_4_C_L_@_Geographic Area-Feature Importance-Depression.svg',
                               'Figure_4_F_R_@_Geographic Area-Balanced ACC-Suicidial Ideation.svg',
                               'Figure_4_F_L_@_Geographic Area-Feature Importance-Suicidial Ideation.svg'),
                   FigureS1 = c('Figure_S1_A_@.svg','Figure_S1_B_@.svg',
                                'Figure_S1_C_@.svg',
                                'Figure_S1_D_@.svg',
                                'Figure_S1_E_@.svg'),
                   FigureS2 = c('Figure_S2_A_@.svg',
                                'Figure_S2_B_@.svg',
                                'Figure_S2_C_@.svg',
                                'Figure_S2_D_@.svg',
                                'Figure_S2_E_@.svg',
                                'Figure_S2_F_@.svg',
                                'Figure_S2_G_@.png',
                                'Figure_S2_H_@.png'))
T_Figures = data.frame()

for (i in names(fig.comp.ls)){
  out.folder = normalizePath(paste('../Res_4_Reports_for_Manuscript',i,sep = '/'),
                             winslash = '/',
                             mustWork = F)
  if(!dir.exists(out.folder)){
    dir.create(out.folder,recursive = T)
  }
  T_tmp = data.frame()
  for (j in fig.comp.ls[[i]]){
    source.file.dir = common::file.find(path = ResDir,
                                        pattern = j,
                                        up = 1,
                                        down = 5)
    source.file.dir = normalizePath(source.file.dir,
                                    winslash = '/',
                                    mustWork = T) 
    Index = which(fig.comp.ls[[i]] %in% j)
    new.file.name = fig.name.ls[[i]][Index]
    destination.file.dir = normalizePath(paste(out.folder,new.file.name,sep = '/'),
                                         winslash = '/',
                                         mustWork = F)
    T_single = data.frame(Figure = i, Component = j,
                          `File Name` = new.file.name,
                          Source = source.file.dir,
                          Destination = destination.file.dir)
    T_tmp = rbind(T_tmp,T_single)
  }
  T_Figures = rbind(T_Figures,T_tmp)
}
T_Figures$File.Name %>%
  stringr::str_extract('_[A-H,S].*') %>%
  stringr::str_remove_all('^_') %>%
  stringr::str_remove_all('(.svg)|(.png)|(.wmf)') %>%
  stringr::str_replace_all('(_@_)|(_@)','.') %>%
  stringr::str_remove_all('S\\d_') %>%
  stringr::str_remove_all('_[L,R]') %>%
  stringr::str_replace_all('-',': ') -> T_Figures$Comp.Name
for (i in 1:nrow(T_Figures)){
  file.copy(T_Figures$Source[i],
            T_Figures$Destination[i])
}

for (i in 1:nrow(T_Figures)){
  unlink(T_Figures$Source[i])
}

T_Figures$Source %>%
  str_remove_all(dirname(getwd())) -> T_Figures$Source
T_Figures$Destination %>%
  str_remove_all(dirname(getwd())) -> T_Figures$Destination
export(T_Figures,'../Res_4_Reports_for_Manuscript/Table_FiguresSummary.xlsx')

