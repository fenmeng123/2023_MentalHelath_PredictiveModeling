library(bruceR)
set.wd()
rm(list=ls())
gc()

ResDir = '../Res_2_Results/'

if (!dir.exists('../Res_4_Reports_for_Manuscript/Table_SensAna/')){
  dir.create('../Res_4_Reports_for_Manuscript/Table_SensAna/',recursive = T)
}
comp.ls = list(Table_SensAna = c('DescrTab_Age_COVID19_RPSD_OOSD.xlsx',
                                 'DescrTab_RPSD_AgeInOneYear.doc',
                                 'DescrTab_OOSD_AgeInOneYear.doc',
                                 'DescrTab_DemosByCOVID19_RPSD.xlsx',
                                 'DescrTab_DemosByCOVID19_OOSD.xlsx'))
name.ls = list(Table_SensAna = c('Table_S13.xlsx',
                                 'Table_S14_Part1.doc',
                                 'Table_S14_Part2.doc',
                                 'Table_S15_Part1.xlsx',
                                 'Table_S15_Part2.xlsx'))
T_Tables = data.frame()

for (i in names(comp.ls)){
  out.folder = normalizePath(paste('../Res_4_Reports_for_Manuscript',i,sep = '/'),
                             winslash = '/',
                             mustWork = F)
  if(!dir.exists(out.folder)){
    dir.create(out.folder,recursive = T)
  }
  T_tmp = data.frame()
  for (j in comp.ls[[i]]){
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
    Index = which(comp.ls[[i]] %in% j)
    new.file.name = name.ls[[i]][Index]
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
            T_Tables$Destination[i],
            overwrite = T)
}

T_Tables$Source %>%
  str_remove_all(dirname(getwd())) -> T_Tables$Source
T_Tables$Destination %>%
  str_remove_all(dirname(getwd())) -> T_Tables$Destination

export(T_Tables,'../Res_4_Reports_for_Manuscript/Table_SensAna_TablesSummary.xlsx')

