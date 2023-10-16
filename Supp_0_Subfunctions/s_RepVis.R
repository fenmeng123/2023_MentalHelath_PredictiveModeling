s_extract_reliability <- function(Docx.Obj){
  docx_extract_all_tbls(Docx.Obj) %>%
    as.data.frame() %>%
    select(-V1) -> T_df
  colnames(T_df) <- T_df[1,]
  T_df[-1,] %>%
    select(-c(`McDonald's Omega_t`,
              Alpha_LowCI,Alpha_UpCI)) %>%
    unite(`Crobach's Alpha [95% CI]`,c(`Crobach's Alpha`,alpha_CI),sep = ' ') %>%
    mutate(across('Measurement',stringr::str_replace_all,
                  c('Stress' = 'PSS',
                    'AcadBO' = 'ACBI',
                    'Anx' = 'SAS',
                    'Dep' = 'CES-D',
                    'SelfInjury' = 'ANSAQ',
                    'SuiciIdea' = 'PANSI',
                    'BullyVict' = 'OBVQ-R'))) %>%
    rename(`Assessment`=`Measurement`,
           `Corrected Item-whole Correlation` = `ITC_Mean`) -> T_df
  T_df$Assessment %>%
    RECODE("'PSS' = 'Stress';
          'ACBI' = 'Academic Burn-out';
          'SAS' = 'Anxiety';
          'CES-D' = 'Depression';
          'ANSAQ' = 'Non-suicidal Self-injury';
          'PANSI' = 'Suicidal Ideation';
          'OBVQ-R' = 'Bullying/Being Bullied';") -> T_df$`Behavioral Problems`
  T_df %>%
    select(c(`Behavioral Problems`,`Assessment`,
             `Crobach's Alpha [95% CI]`,`McDonald's Omega_h`,
             `Signal/Noise Ratio`,everything())) -> T_df
  return(T_df)
}
s_extract_MdlComp <- function(Docx.Obj){
  docx_extract_all_tbls(Docx.Obj) %>%
    as.data.frame() -> T_df
  colnames(T_df) <- T_df[1,]
  T_df <- T_df[-1,]
  T_df$Model %>%
    stringr::str_replace('LogisticR','LogisticR*') -> T_df$Model
  T_df %>%
    rename(`Balanced ACC` = BalancedACC) -> T_df
  return(T_df)
}

s_extract_RFECV <- function(T_df){
  T_df %>%
    select(-c(N_RFEpass,N_RFEfail)) -> T_df
  str_c(sprintf("%.2f",T_df$Mean),
        ' (',
        sprintf("%.2f",T_df$SD),
        ')') -> T_df$`Importance`
  T_df$`Stability` <- 1-T_df$Freq
  T_df %>%
    select(-c(Mean,SD,Freq)) %>%
    select(c(Predictors,Stability,Importance,everything())) -> T_df
  return(T_df)
}

s_extract_updownsampling <- function(T_df){
  T_df %>%
    rename(`Model Evaluation Indices` = Index,
           `Inverse-proporation Weighted` = `Balance Weighted`,
           `Down-sampling (subset)` = `Downsampling (1,000 times)`,
           `Up-sampling (boostrap)` = `Upsampling (1,000 times)`) -> T_df
  T_df[T_df$`Model Evaluation Indices`=='F1-score','Inverse-proporation Weighted'] %>%
    stringr::str_remove_all('%') %>% 
    as.numeric()/100 -> T_df[T_df$`Model Evaluation Indices`=='F1-score','Inverse-proporation Weighted']
  return(T_df)
}

s_extract_coefs <- function(T_df){
  T_df %>%
    select(c(Predictors,`Importance [95% CI]`))->T_df
  return(T_df)
}
s_combine_coefs <- function(T_Dep,T_Suici,add_str){
  sep_1 = data.frame(' ','Predicting Depression Problem')
  colnames(sep_1) <- colnames(T_Dep)
  T_Dep = rbind(sep_1,T_Dep)
  sep_2 = data.frame(' ','Predicting Suicidal Ideation Problem')
  colnames(sep_2) <- colnames(T_Dep)
  T_Suici = rbind(sep_2,T_Suici)
  Table.all = merge(T_Dep,T_Suici,
                   by = 'Predictors',
                   all = T)
  colnames(Table.all) <- c('Predictors','Depression','Suicidal Ideation')
  Table.all[,2] <- stringr::str_replace_na(Table.all[,2],replacement = 'n.a.')
  Table.all[,3] <- stringr::str_replace_na(Table.all[,3],replacement = 'n.a.')
  Table.all[1,] <- c('Features',sprintf('Importance [95%% CI] (%s)',add_str),' ')
  Table.all$Predictors %>%
    factor(levels = c('Features','Anxiety','Perceived Stress','Academic Burn-out',
                      'Internet Addiction','Non-suicidal Self-injury',
                      'Bullying','Be Bullied','Age')) -> Table.all$Predictors
  Table.all <- arrange(Table.all,Predictors)
  return(Table.all)
}
s_extract_SubG_Coefs <- function(T_df){
  T_df %>% 
    select(c(Group,Predictors,Mean,LowCI,UpCI)) %>%
    mutate(across(c(Mean),function(.) sprintf('%.2f',.))) %>%
    mutate(across(c(LowCI),function(.) sprintf(' [%.2f, ',.))) %>%
    mutate(across(c(UpCI),function(.) sprintf('%.2f]',.))) %>%
    unite("Importance [95% CI]",c(Mean,LowCI,UpCI),sep = '') %>%
    pivot_wider(id_cols = Predictors,
                names_from = Group,
                values_from = `Importance [95% CI]`) %>%
    as.data.frame() -> T_coefs
  return(T_coefs)
}
s_combine_SubG_Coefs <- function(T_Sex,T_Edu,T_Area){
  T_df <- Hmisc::Merge(T_Sex,T_Edu,T_Area,
                       id = ~Predictors)
  T_df %>%
    select(c(Predictors,Boy,Girl,
             `Primary School`,`Middle School`,`High School`,
             `Eastern China`,`Northeast China`,`Westrern China`,`Central China`)) %>%
    rename(`Western China` = `Westrern China`) -> T_df
  T_df$Predictors %>%
    factor(levels = c('Anxiety',
                      'Perceived Stress',
                      'Academic Burn-out',
                      'Internet Addiction',
                      'Non-suicidal Self-injury',
                      'Being Bullied',
                      'Age')) -> T_df$Predictors
  T_df <- arrange(T_df,Predictors)
  T_df %>% 
    colnames() %>%
    t() %>%
    as.data.frame() -> sep_1
  colnames(sep_1) <- colnames(T_df)
  sep_1[1,1] <- 'Features'
  T_df <- rbind(sep_1,T_df)
  colnames(T_df) <- c('Predictors','Biological Sex','Biological Sex',
                      'Educational Stage','Educational Stage','Educational Stage',
                      'Geographica Area','Geographica Area','Geographica Area','Geographica Area')
  return(T_df)
}
s_SubG_Coefs_AddAnchor <- function(T_Anchor,T_df,type = 'Depression'){
 T_Anchor %>%
    select(c(Predictors,starts_with(type))) -> T_Anchor
 DownAnchorFlag = which(stringr::str_detect(T_Anchor[1,],'down-sampling'))
 UpAnchorFlag = which(stringr::str_detect(T_Anchor[1,],'up-sampling'))
 if (length(DownAnchorFlag)==0){
   DownAnchorFlag <- 2
 }
 if (length(UpAnchorFlag)==0){
   UpAnchorFlag <- 3
 }
 T_Down <- T_Anchor[,c(1,DownAnchorFlag)]
 colnames(T_Down) <- c('Anchor Predictors','Overall Model')
 sep_1 = data.frame('Down-sampling',' ')
 colnames(sep_1) <- colnames(T_Down)
 T_Up <- T_Anchor[,c(1,UpAnchorFlag)]
 colnames(T_Up) <- c('Anchor Predictors','Overall Model')
 sep_2 = data.frame('Up-sampling',' ')
 colnames(sep_2) <- colnames(T_Up)
 Long_T_Anchor <- rbind(sep_1,T_Down,
                        sep_2,T_Up)
 if (str_detect('Suicidal Ideation',type)){
   Long_T_Anchor <- subset(Long_T_Anchor,
                           `Anchor Predictors` != 'Be Bullied')
 }
 Full_T = cbind(T_df[,1],
                Long_T_Anchor,
                T_df[,-1])
 return(Full_T)
}
s_extract_SubG_Res <- function(MdlMethod,Subgroup,Input_Dir){
  for (i in Subgroup){
    str_c(Input_Dir,'Res_',MdlMethod,i,'.xlsx') %>%
      import() %>% subset(name=='External') %>%
      select(-c(`...1`,name,IterNum)) %>%
      as.data.frame() -> tmp_dat
    rbind(sapply(tmp_dat, mean),
          sapply(tmp_dat, sd),
          sapply(tmp_dat, function(x) quantile(x, 0.025)),
          sapply(tmp_dat, function(x) quantile(x, 0.975))) %>%
      as.data.frame(row.names = c('mean','sd','LowCI','UpCI')) %>%
      rename(`F1-score` = F1_score,
             `Balanced ACC` = balacc) %>%
      select(c(ACC,`Balanced ACC`,Sensitivity,Specificity,`F1-score`,PPV,NPV)) -> tmp_res

    tmp_res %>% 
      select(-`F1-score`) %>%
      sapply(function(x) sprintf('%.2f%%',x*100) ) %>%
      as.data.frame(row.names = rownames(tmp_res)) %>%
      t() %>% as.data.frame() %>%
      unite('MeanSD',c(mean,sd),sep = ' (') %>%
      unite('95% CI',c(LowCI,UpCI),sep = ', ') -> tmp_part
    tmp_part$`Prediction Performance` <- sprintf('%s) [%s]',tmp_part$MeanSD,tmp_part$`95% CI`)
    tmp_res %>% 
      select(`F1-score`) %>%
      sapply(function(x) sprintf('%.4f',x) ) %>%
      as.data.frame(row.names = rownames(tmp_res)) %>%
      t() %>% as.data.frame() %>%
      unite('MeanSD',c(mean,sd),sep = ' (') %>%
      unite('95% CI',c(LowCI,UpCI),sep = ', ') -> tmp_F1
    tmp_F1$`Prediction Performance` <- sprintf('%s) [%s]',tmp_F1$MeanSD,tmp_F1$`95% CI`)
    
    rbind(tmp_part,tmp_F1) %>%
      select(`Prediction Performance`) -> tmp_res
    colnames(tmp_res) <- i
    if (i == Subgroup[1]){
      Res_Table = tmp_res
    }else{
      Res_Table <- cbind(Res_Table,tmp_res)
    }
  }
  return(Res_Table)
}
