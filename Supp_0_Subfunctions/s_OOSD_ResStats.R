<<<<<<< HEAD
Get.Comp.Res <- function(Y_Name,ResDown,ResUp,Anchor,Percent_Flag){
  TTEST(data = ResDown,y=Y_Name,
        test.value = Anchor[[Y_Name]],
        digits = 5) -> Comp_Down
  TTEST(data = ResUp,y=Y_Name,
        test.value = Anchor[[Y_Name]],
        digits = 5) -> Comp_Up
  ResDown$Method <- 'Downsampling'
  ResUp$Method <- 'Upsampling'
  Res_Combine <- rbind(ResDown,ResUp)
  TTEST(Res_Combine,x = 'Method',y = Y_Name,
        var.equal = F) -> Comp_DownUp
  rownames(Comp_Down) <- NULL
  rownames(Comp_Up) <- NULL
  Comp_Up$Contrast <- 'Upsampling - Weighted Model'
  Comp_Down$Contrast <- 'Downsampling - Weighted Model'
  rownames(Comp_DownUp) %>% str_remove('.*\\(') %>% str_remove('\\)') -> Comp_DownUp$Contrast
  rownames(Comp_DownUp) <- NULL
  Comp_Res <- rbind(Comp_Down,Comp_Up,Comp_DownUp)
  Comp_Res$pval <- Comp_Res$pval * 3
  Comp_Res$pval[Comp_Res$pval>1] <- 1
  if (Percent_Flag){
    Comp_Res[,c('diff','llci','ulci')] <- Comp_Res[,c('diff','llci','ulci')]*100
  }
  Comp_Res$Index <- Y_Name
  return(Comp_Res)
}
Loop.Comp.Res <- function(Y_List,ResDown,ResUp,Anchor){
  Res_Table <- data.frame()
  for (i in Y_List){
    tmp <- Get.Comp.Res(i,ResDown,ResUp,Anchor,i!='F1_score')
    Res_Table <- rbind(Res_Table,tmp)
  }
  Res_Table$Index %>%
    str_replace('balacc','Balanced ACC') %>%
    str_replace('F1_score','F1-score') -> Res_Table$Index
  return(Res_Table)
}
Get.Res.Sum <-function(Res){
  Res_Table <- data.frame()
  if (nrow(Res) > 1){
    psych::describe(Res) %>%
      select(mean,sd,min,max) -> Res_Sum
    Res_Sum$Index <- rownames(Res_Sum)
    rownames(Res_Sum) <- NULL 
    Res_Sum <- subset(as.data.frame(Res_Sum),Index!='IterNum')
    for (i in unique(Res_Sum$Index)){
      tmp <- subset(Res_Sum,Index==i)
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
      tmp <- select(tmp,c(Index,Value))
      Res_Table <- rbind(Res_Table,tmp)
    }
    Res_Table$Index %>%
      str_replace('balacc','Balanced ACC') %>%
      str_replace('F1_score','F1-score') -> Res_Table$Index
  }else{
    t(Res) %>% as.data.frame() %>%
      rename('Balance Weighted' = '2') -> Res
    Res$Index <- rownames(Res)
    rownames(Res) <- NULL
    Res$Index %>%
      str_replace('balacc','Balanced ACC') %>%
      str_replace('F1_score','F1-score') -> Res$Index
    for (i in unique(Res$Index)){
      tmp <- subset(Res,Index==i)
      if (i == 'F1_score'){
        tmp$`Balance Weighted` = sprintf('%.4f',tmp$`Balance Weighted`)
      }else{
        tmp$`Balance Weighted` = sprintf('%2.2f%%',tmp$`Balance Weighted`*100)
      }
      Res_Table <- rbind(Res_Table,tmp)
      }
  }
 
  return(Res_Table)
}
# Get.Comp.Res.Table <- function(Comp_Res){
#   Comp_Res <- select(Comp_Res,
#                      c(Index,Contrast,everything()))
# }
Coef.Transform <- function(Coef){
  if ('X1' %in% colnames(Coef)){
    Coef <- select(Coef,-X1)
  }
  CoefNames <- Coef$CoefName
  Coef <- as.data.frame(t(Coef))
  colnames(Coef) <- CoefNames
  rownames(Coef) <- NULL
  Coef <- Coef[-1,]
  return(Coef)
}
Get.Coef.Table <- function(Res){
  Res %>% Coef.Transform() %>% lapply(as.numeric) %>% as.data.frame() %>%
    psych::describe() %>% as.data.frame() %>%
    select(c(mean,sd,median,min,max)) -> Coef_Table
  Coef_Table$Predictors <- rownames(Coef_Table)
  rownames(Coef_Table) <- NULL
  Coef_Table$Predictors %>%
    str_replace('Anx_Sum','Anxiety') %>%
    str_replace('Stress_Sum','Perceived Stress') %>%
    str_replace('AcadBO_Sum','Academic Burn-out') %>%
    str_replace('IAT_Sum','Internet Addiction') %>%
    str_replace('SelfInjury_Sum','Non-suicidal Self-injury') %>%
    str_replace('BeBully_Bin','Be Bullied')%>%
    str_replace('Grade','Education Level (Grade)') %>%
    str_replace('Gender_Girl','Biological Sex') %>%
    str_replace('Bully_Bin','Bully') -> Coef_Table$Predictors
  Coef_Table <- select(Coef_Table,c(Predictors,everything()))
  return(Coef_Table)
}
=======
Get.Comp.Res <- function(Y_Name,ResDown,ResUp,Anchor,Percent_Flag){
  TTEST(data = ResDown,y=Y_Name,
        test.value = Anchor[[Y_Name]],
        digits = 5) -> Comp_Down
  TTEST(data = ResUp,y=Y_Name,
        test.value = Anchor[[Y_Name]],
        digits = 5) -> Comp_Up
  ResDown$Method <- 'Downsampling'
  ResUp$Method <- 'Upsampling'
  Res_Combine <- rbind(ResDown,ResUp)
  TTEST(Res_Combine,x = 'Method',y = Y_Name,
        var.equal = F) -> Comp_DownUp
  rownames(Comp_Down) <- NULL
  rownames(Comp_Up) <- NULL
  Comp_Up$Contrast <- 'Upsampling - Weighted Model'
  Comp_Down$Contrast <- 'Downsampling - Weighted Model'
  rownames(Comp_DownUp) %>% str_remove('.*\\(') %>% str_remove('\\)') -> Comp_DownUp$Contrast
  rownames(Comp_DownUp) <- NULL
  Comp_Res <- rbind(Comp_Down,Comp_Up,Comp_DownUp)
  Comp_Res$pval <- Comp_Res$pval * 3
  Comp_Res$pval[Comp_Res$pval>1] <- 1
  if (Percent_Flag){
    Comp_Res[,c('diff','llci','ulci')] <- Comp_Res[,c('diff','llci','ulci')]*100
  }
  Comp_Res$Index <- Y_Name
  return(Comp_Res)
}
Loop.Comp.Res <- function(Y_List,ResDown,ResUp,Anchor){
  Res_Table <- data.frame()
  for (i in Y_List){
    tmp <- Get.Comp.Res(i,ResDown,ResUp,Anchor,i!='F1_score')
    Res_Table <- rbind(Res_Table,tmp)
  }
  Res_Table$Index %>%
    str_replace('balacc','Balanced ACC') %>%
    str_replace('F1_score','F1-score') -> Res_Table$Index
  return(Res_Table)
}
Get.Res.Sum <-function(Res){
  Res_Table <- data.frame()
  if (nrow(Res) > 1){
    psych::describe(Res) %>%
      select(mean,sd,min,max) -> Res_Sum
    Res_Sum$Index <- rownames(Res_Sum)
    rownames(Res_Sum) <- NULL 
    Res_Sum <- subset(as.data.frame(Res_Sum),Index!='IterNum')
    for (i in unique(Res_Sum$Index)){
      tmp <- subset(Res_Sum,Index==i)
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
      tmp <- select(tmp,c(Index,Value))
      Res_Table <- rbind(Res_Table,tmp)
    }
    Res_Table$Index %>%
      str_replace('balacc','Balanced ACC') %>%
      str_replace('F1_score','F1-score') -> Res_Table$Index
  }else{
    t(Res) %>% as.data.frame() %>%
      rename('Balance Weighted' = '2') -> Res
    Res$Index <- rownames(Res)
    rownames(Res) <- NULL
    Res$Index %>%
      str_replace('balacc','Balanced ACC') %>%
      str_replace('F1_score','F1-score') -> Res$Index
    for (i in unique(Res$Index)){
      tmp <- subset(Res,Index==i)
      if (i == 'F1_score'){
        tmp$`Balance Weighted` = sprintf('%.4f',tmp$`Balance Weighted`)
      }else{
        tmp$`Balance Weighted` = sprintf('%2.2f%%',tmp$`Balance Weighted`*100)
      }
      Res_Table <- rbind(Res_Table,tmp)
      }
  }
 
  return(Res_Table)
}
# Get.Comp.Res.Table <- function(Comp_Res){
#   Comp_Res <- select(Comp_Res,
#                      c(Index,Contrast,everything()))
# }
Coef.Transform <- function(Coef){
  if ('X1' %in% colnames(Coef)){
    Coef <- select(Coef,-X1)
  }
  CoefNames <- Coef$CoefName
  Coef <- as.data.frame(t(Coef))
  colnames(Coef) <- CoefNames
  rownames(Coef) <- NULL
  Coef <- Coef[-1,]
  return(Coef)
}
Get.Coef.Table <- function(Res){
  Res %>% Coef.Transform() %>% lapply(as.numeric) %>% as.data.frame() %>%
    psych::describe() %>% as.data.frame() %>%
    select(c(mean,sd,median,min,max)) -> Coef_Table
  Coef_Table$Predictors <- rownames(Coef_Table)
  rownames(Coef_Table) <- NULL
  Coef_Table$Predictors %>%
    str_replace('Anx_Sum','Anxiety') %>%
    str_replace('Stress_Sum','Perceived Stress') %>%
    str_replace('AcadBO_Sum','Academic Burn-out') %>%
    str_replace('IAT_Sum','Internet Addiction') %>%
    str_replace('SelfInjury_Sum','Non-suicidal Self-injury') %>%
    str_replace('BeBully_Bin','Be Bullied')%>%
    str_replace('Grade','Education Level (Grade)') %>%
    str_replace('Gender_Girl','Biological Sex') %>%
    str_replace('Bully_Bin','Bully') -> Coef_Table$Predictors
  Coef_Table <- select(Coef_Table,c(Predictors,everything()))
  return(Coef_Table)
}
>>>>>>> origin/main
