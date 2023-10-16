library(bruceR)
rm(list=ls())
gc()
set.wd()
if (!dir.exists('../Res_2_Results/ResML_OOSD_CoefTables_Suicide')){
  dir.create('../Res_2_Results/ResML_OOSD_CoefTables_Suicide',recursive = T)
}

source('../Supp_0_Subfunctions/s_OOSD_ResStats.R')
source('../Supp_0_Subfunctions/s_SubG_ResStats.R')
source('../Supp_0_Subfunctions/s_RepVis.R')
Input_Dir = '../Res_2_Results/ResML_Subgroup_Suicide/'

# Extract Biological Sex Subgroup -----------------------------------------

s_get_Subgroup_Coefs(MdlMethod = 'UpSampMdl',
                     Subgroup = c('Boy','Girl'),
                     Input_Dir) -> T_Coef
export(T_Coef,'../Res_2_Results/ResML_OOSD_CoefTables_Suicide/CoefTable_Suicide_Up_SubG_Sex.rda')
export(T_Coef,'../Res_2_Results/ResML_OOSD_CoefTables_Suicide/CoefTable_Suicide_Up_SubG_Sex.xlsx')
s_get_Subgroup_Coefs(MdlMethod = 'DownSampMdl',
                     Subgroup = c('Boy','Girl'),
                     Input_Dir) -> T_Coef
export(T_Coef,'../Res_2_Results/ResML_OOSD_CoefTables_Suicide/CoefTable_Suicide_Down_SubG_Sex.rda')
export(T_Coef,'../Res_2_Results/ResML_OOSD_CoefTables_Suicide/CoefTable_Suicide_Down_SubG_Sex.xlsx')

# Extract Educational Stage Subgroup -----------------------------------------

s_get_Subgroup_Coefs(MdlMethod = 'UpSampMdl',
                     Subgroup = c('PrimarySchool','JuniorSchool','SeniorSchool'),
                     Input_Dir) -> T_Coef
T_Coef$Group %>% 
  stringr::str_replace_all(c(PrimarySchool = 'Primary School',
                             JuniorSchool = 'Middle School',
                             SeniorSchool = 'High School')) -> T_Coef$Group
export(T_Coef,'../Res_2_Results/ResML_OOSD_CoefTables_Suicide/CoefTable_Suicide_Up_SubG_Education.rda')
export(T_Coef,'../Res_2_Results/ResML_OOSD_CoefTables_Suicide/CoefTable_Suicide_Up_SubG_Education.xlsx')
s_get_Subgroup_Coefs(MdlMethod = 'DownSampMdl',
                     Subgroup = c('PrimarySchool','JuniorSchool','SeniorSchool'),
                     Input_Dir) -> T_Coef
T_Coef$Group %>% 
  stringr::str_replace_all(c(PrimarySchool = 'Primary School',
                             JuniorSchool = 'Middle School',
                             SeniorSchool = 'High School')) -> T_Coef$Group
export(T_Coef,'../Res_2_Results/ResML_OOSD_CoefTables_Suicide/CoefTable_Suicide_Down_SubG_Education.rda')
export(T_Coef,'../Res_2_Results/ResML_OOSD_CoefTables_Suicide/CoefTable_Suicide_Down_SubG_Education.xlsx')
# Extract Geographic Area Subgroup -----------------------------------------
s_get_Subgroup_Coefs(MdlMethod = 'UpSampMdl',
                     Subgroup = c('Eastern','Northeast','Central','Western'),
                     Input_Dir) -> T_Coef
T_Coef$Group %>% 
  stringr::str_replace_all(c(Eastern = 'Eastern China',
                             Northeast = 'Northeast China',
                             Central = 'Central China',
                             Western = 'Westrern China')) -> T_Coef$Group

export(T_Coef,'../Res_2_Results/ResML_OOSD_CoefTables_Suicide/CoefTable_Suicide_Up_SubG_Area.rda')
export(T_Coef,'../Res_2_Results/ResML_OOSD_CoefTables_Suicide/CoefTable_Suicide_Up_SubG_Area.xlsx')

s_get_Subgroup_Coefs(MdlMethod = 'DownSampMdl',
                     Subgroup = c('Eastern','Northeast','Central','Western'),
                     Input_Dir) -> T_Coef
T_Coef$Group %>% 
  stringr::str_replace_all(c(Eastern = 'Eastern China',
                             Northeast = 'Northeast China',
                             Central = 'Central China',
                             Western = 'Westrern China')) -> T_Coef$Group
export(T_Coef,'../Res_2_Results/ResML_OOSD_CoefTables_Suicide/CoefTable_Suicide_Down_SubG_Area.rda')
export(T_Coef,'../Res_2_Results/ResML_OOSD_CoefTables_Suicide/CoefTable_Suicide_Down_SubG_Area.xlsx')


