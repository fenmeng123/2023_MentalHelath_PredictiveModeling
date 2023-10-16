library(bruceR)
set.wd()

ResDir = '../Res_2_Results/'

fig.comp.ls = list(Table_Manuscript = c('Table_1.doc',
                                        'Table_1.xlsx'),
                   Table_Supp = c('Table_S1.xlsx',
                                  'Table_S2.xlsx',
                                  'Table_S3.doc',
                                  'Table_S3.xlsx',
                                  'Res_SummaryT_CompMdl_Dep.doc',
                                  'Res_SummaryT_CompMdl_Suicide.doc',
                                  'Table_S4.doc',
                                  'Table_S5.doc',
                                  'Table_S6.doc',
                                  'Table_S7.doc',
                                  'Table_S8.doc',
                                  'Table_S9.doc',
                                  'Table_S10.doc',
                                  'Table_S11.doc',
                                  'Table_S12.doc'))
fig.name.ls = list(Table_Manuscript = c('Manuscript_Table_1.doc',
                                        'Manuscript_Table_1.xlsx'),
                   Table_Supp = c('Table_S1.xlsx',
                                  'Table_S2.xlsx',
                                  'Table_S3.doc',
                                  'Table_S3.xlsx',
                                  'Table_S4.doc',                              
                                  'Table_S5.doc',
                                  'Table_S6.doc',
                                  'Table_S7.doc',
                                  'Table_S8.doc',
                                  'Table_S9.doc',
                                  'Table_S10.doc',
                                  'Table_S11.doc',
                                  'Table_S12.doc',
                                  'Table_S13.doc',
                                  'Table_S14.doc'))
T_Tables = data.frame()

for (i in names(fig.comp.ls)){
  out.folder = normalizePath(paste(ResDir,i,sep = '/'),
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
    T_single = data.frame(Figure = i, Component = j,
                          `File Name` = new.file.name,
                          Source = source.file.dir,
                          Destination = destination.file.dir)
    T_tmp = rbind(T_tmp,T_single)
  }
  T_Tables = rbind(T_Tables,T_tmp)
}

T_Tables$File.Name %>%
  stringr::str_extract('_[A-H,S].*') %>%
  stringr::str_remove_all('^_') %>%
  stringr::str_remove_all('(.svg)|(.png)|(.wmf)') %>%
  stringr::str_replace_all('(_@_)|(_@)','.') %>%
  stringr::str_remove_all('S\\d_') %>%
  stringr::str_remove_all('_[L,R]') %>%
  stringr::str_replace_all('-',': ') -> T_Tables$Comp.Name
export(T_Tables,'../Res_2_Results/Table_TablesSummary.xlsx')

for (i in 1:nrow(T_Tables)){
  file.rename(T_Tables$Source[i],
            T_Tables$Destination[i])
}
