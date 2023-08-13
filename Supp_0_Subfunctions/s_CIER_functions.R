CheckItemType <- function(data){
  flagcounts <- (sum(SUM(data,varrange = '学习倦怠1:学习倦怠16') == data$学习倦怠总分) == nrow(data)) +
    (sum(SUM(data,varrange = '压力感知1:压力感知14') == data$压力感知总分) == nrow(data)) +
    (sum(SUM(data,varrange = '抑郁1:抑郁10') == data$抑郁总分) == nrow(data)) +
    (sum(floor(SUM(data,varrange = '焦虑1:焦虑20')*1.25) == data$焦虑总分) == nrow(data)) +
    (sum(SUM(data,varrange = '抑郁1:抑郁10') == data$抑郁总分) == nrow(data)) +
    (sum(SUM(data,varrange = '自杀意念1:自杀意念14') == data$自杀意念总分) == nrow(data))
  if (flagcounts==6){
    cat('Check: The data have been reverse coded.\n')
    data_afterRec <- data
    data_beforeRec <- ReverseCoding(data,
                                    c('压力感知4','压力感知5','压力感知6',
                                      '压力感知7','压力感知9','压力感知10',
                                      '压力感知12','压力感知13',
                                      '学习倦怠1','学习倦怠4','学习倦怠7',
                                      '学习倦怠11','学习倦怠14','学习倦怠15',
                                      '学习倦怠16',
                                      '抑郁5','抑郁8',
                                      '焦虑5','焦虑9','焦虑13',
                                      '焦虑17','焦虑19',
                                      '自杀意念1','自杀意念2','自杀意念6',
                                      '自杀意念9','自杀意念13','自杀意念14'))
  }else if (flagcounts==0){
    cat('Check: The data are raw data.\n')
    data_beforeRec <- data
    data_afterRec <- ReverseCoding(data,
                                   c('压力感知4','压力感知5','压力感知6',
                                     '压力感知7','压力感知9','压力感知10',
                                     '压力感知12','压力感知13',
                                     '学习倦怠1','学习倦怠4','学习倦怠7',
                                     '学习倦怠11','学习倦怠14','学习倦怠15',
                                     '学习倦怠16',
                                     '抑郁5','抑郁8',
                                     '焦虑5','焦虑9','焦虑13',
                                     '焦虑17','焦虑19',
                                     '自杀意念1','自杀意念2','自杀意念6',
                                     '自杀意念9','自杀意念13','自杀意念14'))
  }
  res <- list(flagcounts = flagcounts,data_beforeRec = data_beforeRec,data_afterRec = data_afterRec)
  return(res)
}



ReverseCoding <- function(data,ReverseItem){
  cat('------Start-Reverse-Coding------\n')
  for (i in ReverseItem){
    cat('Item Name:',i,'\t')
    MinScore <- min(data[[i]])
    MaxScore <- max(data[[i]])
    cat(sprintf('Min:%d Max:%d\n',MinScore,MaxScore))
    data[[i]] <- MaxScore +MinScore -data[[i]]
  }
  cat('------End-Reverse-Coding------\n')
  return(data)
}

IdentifyCarelessResp_P1 <- function(data,ItemName){
  # Identifying Careless Repsonse Part 1
  # calculate the Max Longstring and Intra-individual Response variablily (IRV)
  # for a single questionnaire
  # Notes: Data should be the reverse coded data.
  cat('------Start-Auto-Quality-Control-Part1------\n')
  data <- as.data.frame(data)
  cat('Questionnaire Name:',ItemName,'\t')
  RegExp <- paste(ItemName,'[0-9]',sep = '')
  cat('Regular Expression:',RegExp,'\n')
  logicIdx <- grepl(RegExp,colnames(data))
  cat('All Items: ',colnames(data)[logicIdx],'\n')
  cat('compute longstring......\n')
  data[logicIdx] %>%
    longstring() -> data[paste('maxlongstring_',ItemName,sep = '')]
  cat('compute IRV......\n')
  data[logicIdx]%>%
    irv() -> data[paste('IRV_',ItemName,sep = '')]
  cat('------End-Auto-Quality-Control-Part1------\n')
  return(as.data.table(data))
}

IdentifyCarelessResp_P2 <- function(data){
  # Identifying Careless Repsonse Part 2
  # calculate the Mahalanobis Distance and Even-Odd Consistency Index
  # for the total dataset
  cat('------Start-Auto-Quality-Control-Part2------\n')
  data <- as.data.frame(data)
  logicIdx <- grepl('[0-9]$',colnames(data))
  cat('All Items: ',colnames(data)[logicIdx],'\n')
  cat('compute Even-Odd Consistency Index......\n')
  data[logicIdx] %>%
    evenodd(factors = c(16,14,20,10,20,9,14)) -> data['EvenOddConsistency']
  # Notes: Computation of even-odd has changed for consistency of interpretation
  # with other indices. This change occurred in version 1.2.0 (careless R package).
  # A higher score now indicates a greater likelihood of careless responding.
  # If you have previously written code to cut score based on the output of
  # this function, you should revise that code accordingly.
  cat('compute Mahalanobis Distance......\n')
  data[logicIdx]%>%
    mahad(plot = FALSE) -> data['MahaDist']
  cat('------End-Auto-Quality-Control-Part2------\n')
  return(as.data.table(data))
}

plot.box.distribution <- function(var,file,title){
  jpeg(filename = file,width = 1400,height = 600,res = 144)
  par(mfrow=c(1,2))
  boxplot(var,main = paste('boxplot of',title,sep = ' '))
  hist(var, main = paste('histogram of',title,sep = ' '))
  dev.off()
}

ApplyCIERthreshold <- function(data,threshold){
  if ('ChiSQ' %in% names(threshold)){
    MahaD_CIER_flag <- data$MahaD_SQ>qchisq(threshold$ChiSQ, df = threshold$ChiSQ_DF)
    CIER_Flag_counts <- MahaD_CIER_flag
  }
  if ('EOC' %in% names(threshold)){
    EvenOdd_CIER_flag <- data$EOC<=threshold$EOC
    CIER_Flag_counts <- CIER_Flag_counts+EvenOdd_CIER_flag
  }
  if ('MLS' %in% names(threshold)){
    longstring_CIER_flag <- data$MLS_Sum > threshold$MLS
    CIER_Flag_counts <- CIER_Flag_counts+longstring_CIER_flag
  }
  if ('IRV' %in% names(threshold)){
    IRV_CIER_flag <- data$IRV_WSum_Z <= threshold$IRV
    CIER_Flag_counts <- CIER_Flag_counts+IRV_CIER_flag
  }
  if ('TPI_Low' %in% names(threshold)){
    RT_CIER_flag <- (data$RT_TPI <= threshold$TPI_Low) | (data$RT_TPI >= threshold$TPI_Up)
    CIER_Flag_counts <- CIER_Flag_counts+RT_CIER_flag
  }
  cat('The number of cases with abnormal C/IER indices\n')
  print(table(CIER_Flag_counts))
  if ('NumFlagThreshold' %in% names(threshold)){
    CIER_Flag <- (CIER_Flag_counts>=threshold$NumFlagThreshold)
  }else{
    CIER_Flag <- (CIER_Flag_counts>0)
  }
  cat(sprintf('Finally, the number of cases were identified by C/IER indices：%d\n',
              sum(CIER_Flag)))
  return(CIER_Flag)
}