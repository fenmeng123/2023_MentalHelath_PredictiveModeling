library(bruceR)
library(lubridate)
library(compareGroups)
set.wd()

sink()

sink(file = "../Res_1_Logs/Log_SensAna_1_SplitCOVID19_Recoding.txt",
     append = F,
     type = "output",
     split = T)


fprintf <- function(STR,...){
  cat(
    sprintf(STR,...)
  )
}

DummyNormalize <- function(data){
  data <- mltools::one_hot(data,cols = c('Gender','StudyPhase'))
  data$Grade <- as.numeric(data$Grade)
  
  data$Depression_Label <- as.numeric(data$Dep_Sum >= 16)
  data$SuiciIdea_Label <- as.numeric(data$SuiciIdea_Sum >= 43)
  
  data$Grade <- ( data$Grade - min(data$Grade) )/(max(data$Grade) - min(data$Grade) )
  
  var.ls <- c('BeBully','Bully','Stress_Sum','AcadBO_Sum','IAT_Sum','Anx_Sum',
              'Dep_Sum','SuiciIdea_Sum','SelfInjury_Sum')
  dat_prob <- data[,..var.ls]
  
  var.min <- apply(dat_prob,2,min)
  var.max <- apply(dat_prob,2,max)
  
  for (i in 1:ncol(dat_prob)){
    dat_prob[[i]] = (dat_prob[[i]] - var.min[[i]]) / (var.max[[i]] - var.min[[i]])
    dat_prob[[i]] = dat_prob[[i]]*1
  }
  data[,var.ls] <- dat_prob
  
  data$BeBully_Bin <- as.numeric(data$BeBully!=0)
  data$Bully_Bin <- as.numeric(data$Bully!=0)
  return(data)
}


PreprocessRPSD <- function(data){
  
  data <- data %>%
    select(
      c(Gender,Grade,StudyPhase,Region_4L,
        CIER_Flag,
        BeBully,Bully,
        Stress_Sum,AcadBO_Sum,IAT_Sum,Anx_Sum,Dep_Sum,
        SuiciIdea_Sum,SelfInjury_Sum,
        TimeStamp_Complete_date)
    )
  data$Depression_Label <- as.numeric(data$Dep_Sum >= 16)
  data$SuiciIdea_Label <- as.numeric(data$SuiciIdea_Sum >= 43)
  
  data$TimeStamp_Complete_date <- ymd(data$TimeStamp_Complete_date)
  DateFlag <- data$TimeStamp_Complete_date < ymd('2020-01-12') 
  
  fprintf("|==================Internal Sample N=160,962======================|\n")
  fprintf("| Pre-COVID-19 Collected | N = %d Proportion = %2.2f%%         |\n",
          sum(DateFlag),mean(DateFlag)*100)
  fprintf("| Post-COVID-19 Collected | N = %d Proportion = %2.2f%%        |\n",
          sum(!DateFlag),mean(!DateFlag)*100)
  
  data$COVID19_Flag <- as.numeric(DateFlag)
  fprintf("|Demographic Table for RPSD, grouped by COVID-19 Flag:            |\n")
  res <- data %>%
    compareGroups(COVID19_Flag ~ Gender + Grade + Region_4L + CIER_Flag + StudyPhase + Depression_Label + SuiciIdea_Label,
                  data = .,
                  method = 3)
  demo.T <- createTable(res, 
                        show.n = F, show.ci = F,show.ratio = F,
                        digits = 2)
  print(demo.T)
  export2xls(demo.T,
             file = '../Res_2_Results/DescriptiveStatRes/DescrTab_COVID19_RPSD.xlsx',
             header.labels = c(p.overall = 'p'))

  
  dat <- DummyNormalize(data)
  
  dat$CIER_Flag <- as.numeric(dat$CIER_Flag)
  
  return(dat)
}

PreprocessOOSD <- function(data){
  data <- select(data,c(Gender,Grade,StudyPhase,
                        CIER_Flag,Region_4L,
                        BeBully,Bully,
                        Stress_Sum,AcadBO_Sum,IAT_Sum,Anx_Sum,Dep_Sum,
                        SuiciIdea_Sum,SelfInjury_Sum,
                        datestamp))
  data$datestamp <- data$datestamp %>%
    mdy_hms()

  data <- subset(data,Grade != '3TH GRADE')
  data$Grade <- droplevels(data$Grade,'3TH GRADE')

  data$CIER_Flag <- as.numeric(data$CIER_Flag) - 2
  data$CIER_Flag[data$CIER_Flag==-1] = 1
  
  DateFlag <- data$datestamp < ymd('2020-01-12') 
  
  data$Depression_Label <- as.numeric(data$Dep_Sum >= 16)
  data$SuiciIdea_Label <- as.numeric(data$SuiciIdea_Sum >= 43)
  
  fprintf("|==================External Sample N=1,812,889======================|\n")
  fprintf("| Pre-COVID-19 Collected | N = %d Proportion = %2.2f%%           |\n",
          sum(DateFlag),mean(DateFlag)*100)
  fprintf("| Post-COVID-19 Collected | N = %d Proportion = %2.2f%%          |\n",
          sum(!DateFlag),mean(!DateFlag)*100)
  
  data$COVID19_Flag <- as.numeric(DateFlag)
  fprintf("|Demographic Table for OOSD, grouped by COVID-19 Flag:              |\n")
  res <- data %>%
    compareGroups(COVID19_Flag ~ Gender + Grade + Region_4L + CIER_Flag + StudyPhase + Depression_Label + SuiciIdea_Label,
                  data = .,
                  method = 3)
  demo.T <- createTable(res, 
                        show.n = F, show.ci = F,show.ratio = F,
                        digits = 2)
  print(demo.T)
  export2xls(demo.T,
             file = '../Res_2_Results/DescriptiveStatRes/DescrTab_COVID19_OOSD.xlsx',
             header.labels = c(p.overall = 'p'))
  
  dat <- DummyNormalize(data)
  
  dat$CIER_Flag <- as.numeric(dat$CIER_Flag)
  
  return(dat)
}

printMinMax <- function(data){
  var.ls <- c('BeBully','Bully','Stress_Sum','AcadBO_Sum','IAT_Sum','Anx_Sum',
              'Dep_Sum','SuiciIdea_Sum','SelfInjury_Sum')
  dat_prob <- data[,..var.ls]
  
  var.min <- apply(dat_prob,2,min)
  var.max <- apply(dat_prob,2,max)
  data.frame(var.ls,var.min,var.max) %>%
    display() %>%
    print()
  return(data)
}

data_16w <- import('../Res_3_IntermediateData/16w_BehavProb_Compact_AgeWinsor.rds') %>%
  printMinMax() %>%
  PreprocessRPSD()

data_181w <- import('../Res_3_IntermediateData/181w_recoded_QC_listwiseDemo.rds') %>%
  printMinMax() %>%
  PreprocessOOSD()


export(data_16w,
       file = "../Res_3_IntermediateData/16w_data_for_SensAna.csv")
export(data_181w,
       file = "../Res_3_IntermediateData/181w_data_for_SensAna.csv")

sink()




