library(bruceR)
library(docxtractr)
rm(list=ls())
gc()
set.wd()
source('../Supp_0_Subfunctions/s_RepVis.R')


# Prepare Table S3 --------------------------------------------------------

read_docx('../Res_2_Results/DescriptiveStatRes/Res_All_Reliability_RPSD.doc') %>%
  s_extract_reliability() -> T_All
read_docx('../Res_2_Results/DescriptiveStatRes/Res_CIER_Reliabilty.doc') %>%
  s_extract_reliability() -> T_CIER
read_docx('../Res_2_Results/DescriptiveStatRes/Res_NonCIER_Reliabilty.doc') %>%
  s_extract_reliability() -> T_NonCIER
sep_1 = data.frame('Full Internal Sample N=160,962',' ',' ',' ',' ',' ',' ')
colnames(sep_1) <- colnames(T_All)
sep_2 = data.frame('C/IERs N=10,297',' ',' ',' ',' ',' ',' ')
colnames(sep_2) <- colnames(T_All)
sep_3 = data.frame('Non-C/IERs N=150,665',' ',' ',' ',' ',' ',' ')
colnames(sep_3) <- colnames(T_All)
Table_S3 = rbind(sep_1,T_All,
                 sep_2,T_CIER,
                 sep_3,T_NonCIER)
export(Table_S3,'../Res_2_Results/DescriptiveStatRes/Table_S3.xlsx')
print_table(Table_S3,
            file = '../Res_2_Results/DescriptiveStatRes/Table_S3.docx',
            title = 'Table S3. Internal Sample Reliability Analysis: Influences of C/IERs',
            digits = 4,
            row.names = F)

# Prepare Table S4 & S5 --------------------------------------------------------
read_docx('../Res_2_Results/Res_SummaryT_CompMdl_Dep.doc') %>%
  s_extract_MdlComp() -> T_Dep
read_docx('../Res_2_Results/Res_SummaryT_CompMdl_Suicide.doc') %>%
  s_extract_MdlComp() -> T_Suici
export(T_Dep,'../Res_2_Results/Table_S4.xlsx')
print_table(T_Dep,
            file = '../Res_2_Results/Table_S4.docx',
            title = 'Table S4. Internal Sample Model Comparison: Predicting Depression',
            digits = 4,
            row.names = F)
export(T_Suici,'../Res_2_Results/Table_S5.xlsx')
print_table(T_Suici,
            file = '../Res_2_Results/Table_S5.docx',
            title = 'Table S5. Internal Sample Model Comparison: Predicting Suicidal Ideation',
            digits = 4,
            row.names = F)
# Prepare Table S6 --------------------------------------------------------
import('../Res_2_Results/ResML_RFECV_Dep/Res_SummaryT_Features_RFECV.rda') %>%
  s_extract_RFECV() -> T_Dep
import('../Res_2_Results/ResML_RFECV_Suicide//Res_SummaryT_Features_RFECV.rda') %>%
  s_extract_RFECV() -> T_Suici
sep_1 = data.frame('Predicting Depression Problem',' ',' ',' ',' ',' ')
colnames(sep_1) <- colnames(T_Dep)
sep_2 = data.frame('Predicting Suicidal Ideation Problem',' ',' ',' ',' ',' ')
colnames(sep_2) <- colnames(T_Dep)

Table_S6 <- rbind(sep_1,T_Dep,
                  sep_2,T_Suici)
print_table(Table_S6,
            file = '../Res_2_Results/Table_S6.docx',
            title = 'Table S6. Internal Sample Feature Selection: Cross-validated Recursive Feature Elimination',
            digits = 4,
            row.names = F)
export(Table_S6,'../Res_2_Results/Table_S6.xlsx')

# Prepare Table S7 ---------------------------------------------------------
import('../Res_2_Results/ResML_OOSD_Dep/Res_SummaryT_OOSD_Dep.rda') %>%
  s_extract_updownsampling() -> T_Dep
import('../Res_2_Results/ResML_OOSD_Suicide/Res_SummaryT_OOSD_Suicide.rda') %>%
  s_extract_updownsampling() -> T_Suici
sep_1 = data.frame(' ','Predicting Depression Problem',' ',' ')
sep_2 = data.frame(' ','Predicting Suicidal Ideation Problem',' ',' ')
colnames(sep_1) <- colnames(T_Dep)
colnames(sep_2) <- colnames(T_Dep)
T_Dep = rbind(sep_1,T_Dep)
T_Suici = rbind(sep_2,T_Suici)
Table_S7 = rbind(T_Dep,T_Suici)
print_table(Table_S7,
            file = '../Res_2_Results/Table_S7.docx',
            title = 'Table S7. External Sample Prediction Performance: Comparison of data balancing methods',
            digits = 4,
            row.names = F)
export(Table_S7,'../Res_2_Results/Table_S7.xlsx')

# Prepare Table S8 --------------------------------------------------------

import('../Res_2_Results/ResML_OOSD_Dep/Coef_Downsample_SummaryT_Dep.rda') %>%
  s_extract_coefs() -> T_Dep
import('../Res_2_Results/ResML_OOSD_Suicide/Coef_Downsample_SummaryT_Suicide.rda') %>%
  s_extract_coefs() -> T_Suici
Table_S8_1 = s_combine_coefs(T_Dep,T_Suici,'down-sampling')
import('../Res_2_Results/ResML_OOSD_Dep/Coef_Upsample_SummaryT_Dep.rda') %>%
  s_extract_coefs() -> T_Dep
import('../Res_2_Results/ResML_OOSD_Suicide/Coef_Upsample_SummaryT_Suicide.rda') %>%
  s_extract_coefs() -> T_Suici
Table_S8_2 = s_combine_coefs(T_Dep,T_Suici,'up-sampling')
Table_S8 <- cbind(Table_S8_1,select(Table_S8_2,-Predictors))
print_table(Table_S8,
            file = '../Res_2_Results/Table_S8.docx',
            title = 'Table S8. External Sample Feature Importance: Comparison of data balancing methods',
            digits = 4,
            row.names = F)
export(Table_S8,'../Res_2_Results/Table_S8.xlsx')

# Prepare Table S9 --------------------------------------------------------
rm(list=ls())
gc()
set.wd()
Input_Dir = '../Res_2_Results/ResML_Subgroup_Dep/'
source('../Supp_0_Subfunctions/s_RepVis.R')

s_extract_SubG_Res(MdlMethod = 'DownSampMdl',
                   Subgroup = c('Boy','Girl'),
                   Input_Dir) -> T_Dep_Sex_Down
s_extract_SubG_Res(MdlMethod = 'DownSampMdl',
                   Subgroup = c('PrimarySchool','JuniorSchool','SeniorSchool'),
                   Input_Dir) -> T_Dep_Edu_Down 
s_extract_SubG_Res(MdlMethod = 'DownSampMdl',
                   Subgroup = c('Eastern','Northeast','Central','Western'),
                   Input_Dir) -> T_Dep_Area_Down 
T_Dep_Down <- cbind(T_Dep_Sex_Down,T_Dep_Edu_Down,T_Dep_Area_Down)
sep_1 = data.frame('Down-sampling',' ',' ',' ',' ',' ',' ',' ',' ')
colnames(sep_1) <- colnames(T_Dep_Down)
s_extract_SubG_Res(MdlMethod = 'UpSampMdl',
                   Subgroup = c('Boy','Girl'),
                   Input_Dir) -> T_Dep_Sex_Up 
s_extract_SubG_Res(MdlMethod = 'UpSampMdl',
                   Subgroup = c('PrimarySchool','JuniorSchool','SeniorSchool'),
                   Input_Dir) -> T_Dep_Edu_Up 
s_extract_SubG_Res(MdlMethod = 'UpSampMdl',
                   Subgroup = c('Eastern','Northeast','Central','Western'),
                   Input_Dir) -> T_Dep_Area_Up 
T_Dep_Up <- cbind(T_Dep_Sex_Up,T_Dep_Edu_Up,T_Dep_Area_Up)
sep_2 = data.frame('Up-sampling',' ',' ',' ',' ',' ',' ',' ',' ')
colnames(sep_2) <- colnames(T_Dep_Up)
Table_S9 = rbind(sep_1,T_Dep_Down,
                 sep_2,T_Dep_Up)
print_table(Table_S9,
            file = '../Res_2_Results/Table_S9.docx',
            title = 'Table S9. External Sample Subgrop Analysis: Model Performance in Depression Prediction',
            digits = 4,
            row.names = F)
export(Table_S9,'../Res_2_Results/Table_S9.xlsx')

# Prepare Table S10 -------------------------------------------------------

rm(list=ls())
gc()
set.wd()
Input_Dir = '../Res_2_Results/ResML_Subgroup_Suicide/'
source('../Supp_0_Subfunctions/s_RepVis.R')

s_extract_SubG_Res(MdlMethod = 'DownSampMdl',
                   Subgroup = c('Boy','Girl'),
                   Input_Dir) -> T_Suici_Sex_Down
s_extract_SubG_Res(MdlMethod = 'DownSampMdl',
                   Subgroup = c('PrimarySchool','JuniorSchool','SeniorSchool'),
                   Input_Dir) -> T_Suici_Edu_Down 
s_extract_SubG_Res(MdlMethod = 'DownSampMdl',
                   Subgroup = c('Eastern','Northeast','Central','Western'),
                   Input_Dir) -> T_Suici_Area_Down 
T_Suici_Down <- cbind(T_Suici_Sex_Down,T_Suici_Edu_Down,T_Suici_Area_Down)
sep_1 = data.frame('Down-sampling',' ',' ',' ',' ',' ',' ',' ',' ')
colnames(sep_1) <- colnames(T_Suici_Down)
s_extract_SubG_Res(MdlMethod = 'UpSampMdl',
                   Subgroup = c('Boy','Girl'),
                   Input_Dir) -> T_Suici_Sex_Up 
s_extract_SubG_Res(MdlMethod = 'UpSampMdl',
                   Subgroup = c('PrimarySchool','JuniorSchool','SeniorSchool'),
                   Input_Dir) -> T_Suici_Edu_Up 
s_extract_SubG_Res(MdlMethod = 'UpSampMdl',
                   Subgroup = c('Eastern','Northeast','Central','Western'),
                   Input_Dir) -> T_Suici_Area_Up 
T_Suici_Up <- cbind(T_Suici_Sex_Up,T_Suici_Edu_Up,T_Suici_Area_Up)
sep_2 = data.frame('Up-sampling',' ',' ',' ',' ',' ',' ',' ',' ')
colnames(sep_2) <- colnames(T_Suici_Up)
Table_S10 = rbind(sep_1,T_Suici_Down,
                 sep_2,T_Suici_Up)
print_table(Table_S10,
            file = '../Res_2_Results/Table_S10.docx',
            title = 'Table S10. External Sample Subgrop Analysis: Model Performance in Suicidal Ideation Prediction',
            digits = 4,
            row.names = F)
export(Table_S10,'../Res_2_Results/Table_S10.xlsx')

# Prepare Table S11 -------------------------------------------------------
rm(list=ls())
gc()
set.wd()
source('../Supp_0_Subfunctions/s_RepVis.R')

import('../Res_2_Results/ResML_OOSD_CoefTables_Dep/CoefTable_Depression_Down_SubG_Sex.rda') %>%
 s_extract_SubG_Coefs() -> T_Dep_Sex_Down
import('../Res_2_Results/ResML_OOSD_CoefTables_Dep/CoefTable_Depression_Down_SubG_Education.rda') %>%
  s_extract_SubG_Coefs() -> T_Dep_Edu_Down
import('../Res_2_Results/ResML_OOSD_CoefTables_Dep/CoefTable_Depression_Down_SubG_Area.rda') %>%
  s_extract_SubG_Coefs() -> T_Dep_Area_Down
T_Dep_Down = s_combine_SubG_Coefs(T_Dep_Sex_Down,T_Dep_Edu_Down,T_Dep_Area_Down)
sep_1 = data.frame('Down-sampling',' ',' ',' ',' ',' ',' ',' ',' ',' ')
colnames(sep_1) <- colnames(T_Dep_Down)
import('../Res_2_Results/ResML_OOSD_CoefTables_Dep/CoefTable_Depression_Up_SubG_Sex.rda') %>%
  s_extract_SubG_Coefs() -> T_Dep_Sex_Up
import('../Res_2_Results/ResML_OOSD_CoefTables_Dep/CoefTable_Depression_Up_SubG_Education.rda') %>%
  s_extract_SubG_Coefs() -> T_Dep_Edu_Up
import('../Res_2_Results/ResML_OOSD_CoefTables_Dep/CoefTable_Depression_Up_SubG_Area.rda') %>%
  s_extract_SubG_Coefs() -> T_Dep_Area_Up
T_Dep_Up = s_combine_SubG_Coefs(T_Dep_Sex_Up,T_Dep_Edu_Up,T_Dep_Area_Up)
sep_2 = data.frame('Up-sampling',' ',' ',' ',' ',' ',' ',' ',' ',' ')
colnames(sep_2) <- colnames(T_Dep_Up)
T_Dep = rbind(sep_1,T_Dep_Down,
              sep_2,T_Dep_Up)
import('../Res_2_Results/Table_S8.xlsx') %>%
  s_SubG_Coefs_AddAnchor(T_Dep) -> Table_S11

print_table(Table_S11,
            file = '../Res_2_Results/Table_S11.docx',
            title = 'Table S11. External Sample Subgrop Analysis: Feature Importance in Depression Prediction',
            digits = 4,
            row.names = F)
export(Table_S11,'../Res_2_Results/Table_S11.xlsx')

# Prepare Table S12 -------------------------------------------------------

import('../Res_2_Results/ResML_OOSD_CoefTables_Suicide/CoefTable_Suicide_Down_SubG_Sex.rda') %>%
  s_extract_SubG_Coefs() -> T_Suici_Sex_Down
import('../Res_2_Results/ResML_OOSD_CoefTables_Suicide/CoefTable_Suicide_Down_SubG_Education.rda') %>%
  s_extract_SubG_Coefs() -> T_Suici_Edu_Down
import('../Res_2_Results/ResML_OOSD_CoefTables_Suicide/CoefTable_Suicide_Down_SubG_Area.rda') %>%
  s_extract_SubG_Coefs() -> T_Suici_Area_Down
T_Suici_Down = s_combine_SubG_Coefs(T_Suici_Sex_Down,T_Suici_Edu_Down,T_Suici_Area_Down)
sep_1 = data.frame('Down-sampling',' ',' ',' ',' ',' ',' ',' ',' ',' ')
colnames(sep_1) <- colnames(T_Suici_Down)
import('../Res_2_Results/ResML_OOSD_CoefTables_Suicide/CoefTable_Suicide_Up_SubG_Sex.rda') %>%
  s_extract_SubG_Coefs() -> T_Suici_Sex_Up
import('../Res_2_Results/ResML_OOSD_CoefTables_Suicide/CoefTable_Suicide_Up_SubG_Education.rda') %>%
  s_extract_SubG_Coefs() -> T_Suici_Edu_Up
import('../Res_2_Results/ResML_OOSD_CoefTables_Suicide/CoefTable_Suicide_Up_SubG_Area.rda') %>%
  s_extract_SubG_Coefs() -> T_Suici_Area_Up
T_Suici_Up = s_combine_SubG_Coefs(T_Suici_Sex_Up,T_Suici_Edu_Up,T_Suici_Area_Up)
sep_2 = data.frame('Up-sampling',' ',' ',' ',' ',' ',' ',' ',' ',' ')
colnames(sep_2) <- colnames(T_Suici_Up)
T_Dep = rbind(sep_1,T_Suici_Down,
              sep_2,T_Suici_Up)
import('../Res_2_Results/Table_S8.xlsx') %>%
  s_SubG_Coefs_AddAnchor(T_Dep,type = 'Suicidal') -> Table_S12

print_table(Table_S12,
            file = '../Res_2_Results/Table_S12.docx',
            title = 'Table S12. External Sample Subgrop Analysis: Feature Importance in Suicidal Ideation Prediction',
            digits = 4,
            row.names = F)
export(Table_S12,'../Res_2_Results/Table_S12.xlsx')

