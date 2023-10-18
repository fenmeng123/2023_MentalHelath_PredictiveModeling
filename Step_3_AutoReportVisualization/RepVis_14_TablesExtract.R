library(bruceR)
set.wd()
rm(list=ls())
gc()

ResDir = '../Res_2_Results/'
if (!dir.exists('../Res_4_Reports_for_Manuscript/Table_Manuscript/')){
  dir.create('../Res_4_Reports_for_Manuscript/Table_Manuscript/',recursive = T)
}
if (!dir.exists('../Res_4_Reports_for_Manuscript/Table_Supp_doc/')){
  dir.create('../Res_4_Reports_for_Manuscript/Table_Supp_doc/',recursive = T)
}
if (!dir.exists('../Res_4_Reports_for_Manuscript/Table_Supp_xlsx/')){
  dir.create('../Res_4_Reports_for_Manuscript/Table_Supp_xlsx/',recursive = T)
}
fig.comp.ls = list(Table_Manuscript = c('Table_1.doc',
                                        'Table_1.xlsx'),
                   Table_Supp_doc = c('Res_CrossTab_RPSD_NationWiseData.xlsx',
                                  'DescrTab_CarelessGroup_OOSD.doc',
                                  'DescrTab_CarelessGroup_RPSD.doc',
                                  'Table_S3.doc',
                                  'Table_S4.doc',
                                  'Table_S5.doc',
                                  'Table_S6.doc',
                                  'Table_S7.doc',
                                  'Table_S8.doc',
                                  'Table_S9.doc',
                                  'Table_S10.doc',
                                  'Table_S11.doc',
                                  'Table_S12.doc'),
                   Table_Supp_xlsx = c('Res_CrossTab_RPSD_NationWiseData.xlsx',
                                      'DescrTab_CarelessGroup_OOSD.xlsx',
                                      'DescrTab_CarelessGroup_RPSD.xlsx',
                                      'Table_S3.xlsx',
                                      'Table_S4.xlsx',
                                      'Table_S5.xlsx',
                                      'Table_S6.xlsx',
                                      'Table_S7.xlsx',
                                      'Table_S8.xlsx',
                                      'Table_S9.xlsx',
                                      'Table_S10.xlsx',
                                      'Table_S11.xlsx',
                                      'Table_S12.xlsx'))
fig.name.ls = list(Table_Manuscript = c('Manuscript_Table_1.doc',
                                        'Manuscript_Table_1.xlsx'),
                   Table_Supp_doc = c('Table_S1.xlsx',
                                  'Table_S2_OOSD.xlsx',
                                  'Table_S2_RPDS.xlsx',
                                  'Table_S3.xlsx',
                                  'Table_S4.xlsx',
                                  'Table_S5.xlsx',
                                  'Table_S6.xlsx',
                                  'Table_S7.xlsx',
                                  'Table_S8.xlsx',
                                  'Table_S9.xlsx',
                                  'Table_S10.xlsx',
                                  'Table_S11.xlsx',
                                  'Table_S12.xlsx'),
                   Table_Supp_xlsx = c('Res_CrossTab_RPSD_NationWiseData.xlsx',
                                       'DescrTab_CarelessGroup_OOSD.xlsx',
                                       'DescrTab_CarelessGroup_RPSD.xlsx',
                                       'Table_S3.xlsx',
                                       'Table_S4.xlsx',
                                       'Table_S5.xlsx',
                                       'Table_S6.xlsx',
                                       'Table_S7.xlsx',
                                       'Table_S8.xlsx',
                                       'Table_S9.xlsx',
                                       'Table_S10.xlsx',
                                       'Table_S11.xlsx',
                                       'Table_S12.xlsx'))
T_Tables = data.frame()

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
    if (is.null(source.file.dir)){
      next
    }
    source.file.dir = normalizePath(source.file.dir,
                                    winslash = '/',
                                    mustWork = T) 
    Index = which(fig.comp.ls[[i]] %in% j)
    new.file.name = fig.name.ls[[i]][Index]
    destination.file.dir = normalizePath(paste(out.folder,new.file.name,sep = '/'),
                                         winslash = '/',
                                         mustWork = F)
    T_single = data.frame(Table = i, Component = j,
                          `Table Name` = new.file.name,
                          Source = source.file.dir,
                          Destination = destination.file.dir)
    T_tmp = rbind(T_tmp,T_single)
  }
  T_Tables = rbind(T_Tables,T_tmp)
}

for (i in 1:nrow(T_Tables)){
  file.copy(T_Tables$Source[i],
            T_Tables$Destination[i])
}

for (i in 1:nrow(T_Tables)){
  unlink(T_Tables$Source[i])
}

T_Tables$Source %>%
  str_remove_all(dirname(getwd())) -> T_Tables$Source
T_Tables$Destination %>%
  str_remove_all(dirname(getwd())) -> T_Tables$Destination

export(T_Tables,'../Res_4_Reports_for_Manuscript/Table_TablesSummary.xlsx')

