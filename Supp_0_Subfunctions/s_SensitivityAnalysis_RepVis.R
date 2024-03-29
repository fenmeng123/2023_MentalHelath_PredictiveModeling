fprintf <- function(STR,...){
  cat(sprintf(STR,...))
}

extract.Age.Grade <- function(tmpFileName){
  # Extract Sample Age and Educational Grade
  tmpAge <- tmpFileName %>%
    basename() %>%
    stringr::str_extract(
      pattern = "Age_\\d+_\\d+"
    ) %>%
    stringr::str_remove(
      pattern = "Age_"
    ) %>%
    stringr::str_replace_all(
      pattern = "_",
      replacement = "-"
    )
  tmpGrade <- tmpFileName %>%
    basename() %>%
    stringr::str_extract(
      pattern = "Grade_\\d+"
    ) %>%
    stringr::str_remove(
      pattern = "Grade_"
    )
  return(list(Age = tmpAge,
              Grade = tmpGrade))
}

load.AgeStratified.ModelResults <- function(FileList_MdlRes){
  TotalMdlRes <- data.frame()
  
  for (i in 1:length(FileList_MdlRes)){
    tmpFileName <- FileList_MdlRes[i]
    tmpPartsFileName <- extract.Age.Grade(tmpFileName)
    tmpAge <- tmpPartsFileName$Age
    tmpGrade <- tmpPartsFileName$Grade
    # Load Excel File
    tmpMdlRes <- import(tmpFileName,
                        verbose = T) %>%
      filter(
        name == "External"
      )
    # Remove the first two columns
    tmpMdlRes <- tmpMdlRes[-1:-2]
    # Append new columns to indicate the Sample's Age and Grade
    tmpMdlRes$Age <- tmpAge
    tmpMdlRes$Grade <- tmpGrade
    # Change the IterNum from (0,+Inf) to (1,+Inf),making it more intuitive
    tmpMdlRes$IterNum <- tmpMdlRes$IterNum + 1
    TotalMdlRes <- rbind(TotalMdlRes,tmpMdlRes)
  }
  return(TotalMdlRes)
}


load.AgeStratified.Feature.Coefficients <- function(FileList_Coef){
  TotalCoefRes <- data.frame()
  
  for (i in 1:length(FileList_Coef)){
    tmpFileName <- FileList_Coef[i]
    
    tmpPartsFileName <- extract.Age.Grade(tmpFileName)
    tmpAge <- tmpPartsFileName$Age
    tmpGrade <- tmpPartsFileName$Grade
    
    # Load Excel File
    tmpMdlCoefs <- import(tmpFileName,
                        verbose = T) %>%
      select(-`...1`) %>%
      pivot_longer(
        cols = starts_with("Coef_"),
        names_prefix = "Coef_",
        names_to = "IterNum",
        values_to = "Feature Importance [Regression Coefficient]"
      ) %>%
      rename(Predictors = CoefName)

    # Append new columns to indicate the Sample's Age and Grade
    tmpMdlCoefs$Age <- tmpAge
    tmpMdlCoefs$Grade <- tmpGrade
    # Change the IterNum from (0,+Inf) to (1,+Inf),making it more intuitive
    tmpMdlCoefs$IterNum <- as.numeric(tmpMdlCoefs$IterNum) + 1
    TotalCoefRes <- rbind(TotalCoefRes,tmpMdlCoefs)
  }
  return(TotalCoefRes)
}

load.COVID19.ModelResults <- function(FileList_MdlRes){
  TotalMdlRes <- data.frame()
  
  for (i in 1:length(FileList_MdlRes)){
    tmpFileName <- FileList_MdlRes[i]
    tmpDateStamp <- tmpFileName %>%
      stringr::str_extract("_[A-Za-z]+COVID19_") %>%
      stringr::str_remove_all("_") %>%
      stringr::str_remove("COVID19")
    # Load Excel File
    tmpMdlRes <- import(tmpFileName,
                        verbose = T) %>%
      filter(
        name == "External"
      ) %>%
      select(-c(`...1`,name))
    tmpMdlRes$Flag <- tmpDateStamp
    # Change the IterNum from (0,+Inf) to (1,+Inf),making it more intuitive
    tmpMdlRes$IterNum <- as.numeric(tmpMdlRes$IterNum) + 1
    
    TotalMdlRes <- rbind(TotalMdlRes,tmpMdlRes)
  }
  
  return(TotalMdlRes)
}


load.COVID19.Feature.Coefficients <- function(FileList_Coef){
  TotalCoefRes <- data.frame()
  
  for (i in 1:length(FileList_Coef)){
    tmpFileName <- FileList_Coef[i]
    
    tmpDateStamp <- tmpFileName %>%
      stringr::str_extract("_[A-Za-z]+COVID19_") %>%
      stringr::str_remove_all("_") %>%
      stringr::str_remove("COVID19")
    
    # Load Excel File
    tmpMdlCoefs <- import(tmpFileName,
                          verbose = T) %>%
      select(-`...1`) %>%
      pivot_longer(
        cols = starts_with("Coef_"),
        names_prefix = "Coef_",
        names_to = "IterNum",
        values_to = "Feature Importance [Regression Coefficient]"
      ) %>%
      rename(Predictors = CoefName)
    tmpMdlCoefs$Flag <- tmpDateStamp
    
    # Change the IterNum from (0,+Inf) to (1,+Inf),making it more intuitive
    tmpMdlCoefs$IterNum <- as.numeric(tmpMdlCoefs$IterNum) + 1
    TotalCoefRes <- rbind(TotalCoefRes,tmpMdlCoefs)
  }
  return(TotalCoefRes)
}

load.ResMain.Dep <- function(){
  bruceR::set.wd()
  ResMain <- import('../Res_2_Results/ResML_OOSD_Dep/Res_OOSD_Down1000_Dep.xlsx') %>%
    subset(name=='External') %>% select(-c(`...1`,name))
  ResMain$IterNum <- as.numeric(ResMain$IterNum) + 1
  return(ResMain)
}
load.ResMain.Suicide <- function(){
  bruceR::set.wd()
  ResMain <- import('../Res_2_Results/ResML_OOSD_Suicide/Res_OOSD_Up1000_Suicide.xlsx') %>%
    subset(name=='External') %>% select(-c(`...1`,name))
  ResMain$IterNum <- ResMain$IterNum + 1
  return(ResMain)
}

load.CoefMain.Dep <- function(RemoveGradeFlag = T){
  bruceR::set.wd()
  CoefMain <- import('../Res_2_Results/ResML_OOSD_Dep/Coef_OOSD_Down1000_Dep.xlsx') %>%
    select(-`...1`) %>%
    pivot_longer(
      cols = starts_with("Coef_"),
      names_prefix = "Coef_",
      names_to = "IterNum",
      values_to = "Feature Importance [Regression Coefficient]"
    ) %>%
    rename(Predictors = CoefName) 
  if (RemoveGradeFlag){
    CoefMain <- CoefMain %>%
      filter(Predictors != "Grade")
  }
  CoefMain$IterNum <- as.numeric(CoefMain$IterNum) + 1
  return(CoefMain)
}
load.CoefMain.Suicide <- function(RemoveGradeFlag = T){
  bruceR::set.wd()
  CoefMain <- import('../Res_2_Results/ResML_OOSD_Suicide/Coef_OOSD_Up1000_Suicide.xlsx') %>%
    select(-`...1`) %>%
    pivot_longer(
      cols = starts_with("Coef_"),
      names_prefix = "Coef_",
      names_to = "IterNum",
      values_to = "Feature Importance [Regression Coefficient]"
    ) %>%
    rename(Predictors = CoefName) 
  if (RemoveGradeFlag){
    CoefMain <- CoefMain %>%
      filter(Predictors != "Grade")
  }
  CoefMain$IterNum <- as.numeric(CoefMain$IterNum) + 1
  return(CoefMain)
}
