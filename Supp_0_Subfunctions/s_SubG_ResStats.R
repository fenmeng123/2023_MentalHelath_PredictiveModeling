Multigroup.Comp <- function(data,var.list){
  Res_Comp <- data.frame()
  Res_Comp_EMMs <- data.frame()
  for (i in var.list){
    MANOVA(data,dv = i,between = 'Group') %>% 
      EMMEANS(effect = 'Group',p.adjust = 'bonferroni') -> tmp
    tmp$EMMEANS[[1]]$sim %>% select(c(`η²p [90% CI of η²p]`,pval)) -> tmp_comp
    tmp$EMMEANS[[1]]$con %>% select(c(Contrast,Estimate,SE,t,pval,`Cohen’s d [95% CI of d]`)) -> tmp_emms
    tmp_comp$Index <- i
    tmp_emms$Index <- i
    # psych::describeBy(data[i],data$Group,mat = T) %>%
    #   select(c(group1,mean,sd))-> tmp_mean
    # rownames(tmp_mean) <- tmp_mean$group1
    # if (i=='F1_score'){
    #   tmp_mean$Value <- str_c(sprintf('%.4f',tmp_mean$mean),
    #                           ' (',
    #                           sprintf('%.4f',tmp_mean$sd),
    #                           ')')
    # }
    # 
    # tmp_mean %>% select(Value) %>% t() -> tmp_mean
    # rownames(tmp_mean) <- NULL
    # tmp_comp <- cbind(tmp_mean,tmp_comp)
    Res_Comp <- rbind(Res_Comp,tmp_comp)
    Res_Comp_EMMs <- rbind(Res_Comp_EMMs,tmp_emms)
  }
  return(list(Res_Comp = Res_Comp,Res_EMMs = Res_Comp_EMMs))
}

Extract.Res.Coef <- function(MdlMethod,Subgroup,Input_Dir){
  Coef_Combined <- data.frame()
  Res_Combined <- data.frame()
  for (i in Subgroup){
    str_c(Input_Dir,'Coef_',MdlMethod,i,'.xlsx') %>%
      read.xlsx() %>% Coef.Transform() %>%
      lapply(as.numeric) %>% as.data.frame() -> tmp_coef
    tmp_coef$Group <- i
    Coef_Combined <- rbind(Coef_Combined,tmp_coef)
    str_c(Input_Dir,'Res_',MdlMethod,i,'.xlsx') %>%
      read.xlsx() %>% subset(name=='External') %>%
      select(-c(X1,name,IterNum)) -> tmp_res
    tmp_res$Group <- i
    Res_Combined <- rbind(Res_Combined,tmp_res)
  }
  ResCoef_Combined <- cbind(Res_Combined,Coef_Combined)
  rownames(ResCoef_Combined) <- NULL
  ResCoef_Combined <- ResCoef_Combined[,-8]
  colnames(ResCoef_Combined) %>%
    str_replace('Anx_Sum','Anxiety') %>%
    str_replace('Stress_Sum','Perceived Stress') %>%
    str_replace('AcadBO_Sum','Academic Burn-out') %>%
    str_replace('IAT_Sum','Internet Addiction') %>%
    str_replace('SelfInjury_Sum','Non-suicidal Self-injury') %>%
    str_replace('BeBully_Bin','Be Bullied')%>%
    str_replace('Grade','Education Level (Grade)') %>%
    str_replace('Gender_Girl','Biological Sex') %>%
    str_replace('Bully_Bin','Bully') %>%
    str_replace('balacc','Balanced ACC') %>%
    str_replace('F1_score','F1-score') -> colnames(ResCoef_Combined)
  return(ResCoef_Combined)
}

Get.Res.Coef.MeanSD.Table <- function(MdlMethod,Subgroup,Input_Dir){
  ResCoef_Table <- data.frame()
  for (i in Subgroup){
    str_c(Input_Dir,'Coef_',MdlMethod,i,'.xlsx') %>%
      read.xlsx() %>% Get.Coef.Table() %>% 
      select(c(Predictors,mean,sd)) -> tmp_coef
    str_c(sprintf('%.2f',tmp_coef$mean),
          ' (',
          sprintf('%.2f',tmp_coef$sd),
          ')') -> tmp_coef$Value
    tmp_coef %>% select(-c(mean,sd)) %>% rename('Index' = 'Predictors') -> tmp_coef
    
    str_c(Input_Dir,'Res_',MdlMethod,i,'.xlsx') %>%
      read.xlsx() %>% subset(name=='External') %>%
      select(-c(X1,name,IterNum)) %>%
      Get.Res.Sum() -> tmp_res
    tmp_res$Value %>% str_remove('\\[.*\\]') -> tmp_res$Value
    tmp <- rbind(tmp_res,tmp_coef)
    colnames(tmp)[colnames(tmp)=='Value'] = i
    if (i == Subgroup[1]){
      ResCoef_Table <- tmp
    }else{
      ResCoef_Table <- merge(ResCoef_Table,tmp,by = 'Index')
    }
  }
  return(ResCoef_Table)
}

Get.Res.Coef.Separate <- function(MdlMethod,Subgroup,Input_Dir){
  Coef_Combined <- data.frame()
  Res_Combined <- data.frame()
  for (i in Subgroup){
    str_c(Input_Dir,'Coef_',MdlMethod,i,'.xlsx') %>%
      read.xlsx() %>% Coef.Transform() %>%
      lapply(as.numeric) %>% as.data.frame() -> tmp_coef
    tmp_coef$Group <- i
    Coef_Combined <- rbind(Coef_Combined,tmp_coef)
    str_c(Input_Dir,'Res_',MdlMethod,i,'.xlsx') %>%
      read.xlsx() %>% subset(name=='External') %>%
      select(-c(X1,name,IterNum)) -> tmp_res
    tmp_res$Group <- i
    Res_Combined <- rbind(Res_Combined,tmp_res)
  }
  return(list(Coef=Coef_Combined,Res=Res_Combined))
}

Comp_Mean_T.Test <- function(Coef_Combined,Res_Combined){
  TTEST(Coef_Combined,
        x = 'Group',y=colnames(Coef_Combined)[1:ncol(Coef_Combined)-1]) -> Comp_Coef
  TTEST(Res_Combined,
        x = 'Group',y=colnames(Res_Combined)[1:ncol(Res_Combined)-1]) -> Comp_Res
  Comp_All <- rbind(Comp_Res,Comp_Coef)
  Comp_All$pval <- Comp_All$pval * nrow(Comp_All)
  Comp_All$pval[Comp_All$pval>1]=1
  rownames(Comp_All) %>%
    str_remove(':.*') %>%
    str_replace('Anx_Sum','Anxiety') %>%
    str_replace('Stress_Sum','Perceived Stress') %>%
    str_replace('AcadBO_Sum','Academic Burn-out') %>%
    str_replace('IAT_Sum','Internet Addiction') %>%
    str_replace('SelfInjury_Sum','Non-suicidal Self-injury') %>%
    str_replace('BeBully_Bin','Be Bullied')%>%
    str_replace('Grade','Education Level (Grade)') %>%
    str_replace('Gender_Girl','Biological Sex') %>%
    str_replace('Bully_Bin','Bully') %>%
    str_replace('balacc','Balanced ACC') %>%
    str_replace('F1_score','F1-score') -> Comp_All$Index
  rownames(Comp_All) <- NULL
  Comp_All %>% select(-c(df,BF10,Error)) -> Full_Table
  Comp_All$`Difference` <- str_c(sprintf('%.2f',Comp_All$diff),
                                 ' [',
                                 sprintf('%.2f',Comp_All$llci),
                                 ', ',
                                 sprintf('%.2f',Comp_All$ulci),
                                 ']')
  Compact_Table <- select(Comp_All,c(Index,Difference,pval))
  return(list(Compact=Compact_Table,Full=Full_Table))
}
Comp_Mean_ANOVA <- function(Coef_Combined,Res_Combined,Subgroup){
  Coef_Combined$Group <- factor(Coef_Combined$Group,
                                levels = Subgroup)
  Comp_Coef <- Multigroup.Comp(Coef_Combined,
                               colnames(Coef_Combined)[1:ncol(Coef_Combined)-1])
  Res_Combined$Group <- factor(Res_Combined$Group,
                               levels = Subgroup)
  Comp_Res <- Multigroup.Comp(Res_Combined,
                              colnames(Res_Combined)[1:ncol(Res_Combined)-1])
  rbind(Comp_Coef$Res_Comp,Comp_Res$Res_Comp) %>%
    select(c(Index,everything())) -> Compact_Table
  Compact_Table$pval <- Compact_Table$pval * nrow(Compact_Table)
  Compact_Table$pval[Compact_Table$pval>1]=1
  rbind(Comp_Coef$Res_EMMs,Comp_Res$Res_EMMs) %>%
    select(c(Index,everything()))-> Full_Table
  Full_Table$pval <- Full_Table$pval * nrow(Compact_Table)
  Full_Table$pval[Full_Table$pval>1]=1
  Compact_Table$Index %>%
    str_replace('Anx_Sum','Anxiety') %>%
    str_replace('Stress_Sum','Perceived Stress') %>%
    str_replace('AcadBO_Sum','Academic Burn-out') %>%
    str_replace('IAT_Sum','Internet Addiction') %>%
    str_replace('SelfInjury_Sum','Non-suicidal Self-injury') %>%
    str_replace('BeBully_Bin','Be Bullied')%>%
    str_replace('Grade','Education Level (Grade)') %>%
    str_replace('Gender_Girl','Biological Sex') %>%
    str_replace('Bully_Bin','Bully') %>%
    str_replace('balacc','Balanced ACC') %>%
    str_replace('F1_score','F1-score') -> Compact_Table$Index
  Full_Table$Index %>%
    str_replace('Anx_Sum','Anxiety') %>%
    str_replace('Stress_Sum','Perceived Stress') %>%
    str_replace('AcadBO_Sum','Academic Burn-out') %>%
    str_replace('IAT_Sum','Internet Addiction') %>%
    str_replace('SelfInjury_Sum','Non-suicidal Self-injury') %>%
    str_replace('BeBully_Bin','Be Bullied')%>%
    str_replace('Grade','Education Level (Grade)') %>%
    str_replace('Gender_Girl','Biological Sex') %>%
    str_replace('Bully_Bin','Bully') %>%
    str_replace('balacc','Balanced ACC') %>%
    str_replace('F1_score','F1-score') -> Full_Table$Index
  return(list(Compact=Compact_Table,Full=Full_Table))
}
Get.Dep.SubG.Summary.Table <- function(MdlMethod,Subgroup,Input_Dir){
  ResCoef_Table <- Get.Res.Coef.MeanSD.Table(MdlMethod,Subgroup,Input_Dir)
  tmp <- Get.Res.Coef.Separate(MdlMethod,Subgroup,Input_Dir)
  Coef_Combined <- tmp$Coef
  Res_Combined <- tmp$Res
  if (length(Subgroup)==2){
    tmp <- Comp_Mean_T.Test(Coef_Combined,Res_Combined)
    Compact_Table <- tmp$Compact
    Full_Table <- tmp$Full
  }else{
    tmp <- Comp_Mean_ANOVA(Coef_Combined,Res_Combined,Subgroup)
    Compact_Table <- tmp$Compact
    Full_Table <- tmp$Full
  }
  Compact_Table <- merge(ResCoef_Table,Compact_Table,by = 'Index')
  Full_Table <- merge(ResCoef_Table,Full_Table,by = 'Index')
  Compact_Table %>% 
    arrange(factor(Index,levels=c('ACC','Sensitivity','Specificity',
                                'Balanced ACC','F1-score','PPV','NPV',
                                'Anxiety','Perceived Stress','Academic Burn-out',
                                'Internet Addiction','Non-suicidal Self-injury',
                                'Be Bullied','Education Level (Grade)'))) -> Compact_Table
  Full_Table %>% 
    arrange(factor(Index,levels=c('ACC','Sensitivity','Specificity',
                                  'Balanced ACC','F1-score','PPV','NPV',
                                  'Anxiety','Perceived Stress','Academic Burn-out',
                                  'Internet Addiction','Non-suicidal Self-injury',
                                  'Be Bullied','Education Level (Grade)'))) -> Full_Table
  return(list('Compact' = Compact_Table,'Full' = Full_Table))
}

Get.Suicide.SubG.Summary.Table <- function(MdlMethod,Subgroup,Input_Dir){
  ResCoef_Table <- Get.Res.Coef.MeanSD.Table(MdlMethod,Subgroup,Input_Dir)
  tmp <- Get.Res.Coef.Separate(MdlMethod,Subgroup,Input_Dir)
  Coef_Combined <- tmp$Coef
  Res_Combined <- tmp$Res
  if (length(Subgroup)==2){
    tmp <- Comp_Mean_T.Test(Coef_Combined,Res_Combined)
    Compact_Table <- tmp$Compact
    Full_Table <- tmp$Full
  }else{
    tmp <- Comp_Mean_ANOVA(Coef_Combined,Res_Combined,Subgroup)
    Compact_Table <- tmp$Compact
    Full_Table <- tmp$Full
  }
  Compact_Table <- merge(ResCoef_Table,Compact_Table,by = 'Index')
  Full_Table <- merge(ResCoef_Table,Full_Table,by = 'Index')
  Compact_Table %>% 
    arrange(factor(Index,levels=c('ACC','Sensitivity','Specificity',
                                  'Balanced ACC','F1-score','PPV','NPV',
                                  'Anxiety','Non-suicidal Self-injury',
                                  'Perceived Stress','Internet Addiction',
                                  'Academic Burn-out','Education Level (Grade)'))) -> Compact_Table
  Full_Table %>% 
    arrange(factor(Index,levels=c('ACC','Sensitivity','Specificity',
                                  'Balanced ACC','F1-score','PPV','NPV',
                                  'Anxiety','Non-suicidal Self-injury',
                                  'Perceived Stress','Internet Addiction',
                                  'Academic Burn-out','Education Level (Grade)'))) -> Full_Table
  return(list('Compact' = Compact_Table,'Full' = Full_Table))
}

