library(grid)
library(ggExtra)
library(bruceR)
library(simputation)
library(naniar)
library(careless)
library(pheatmap)
library(ggplot2)  
library(gridExtra)

set.wd()
source('../Supp_0_Subfunctions/s_CIER_functions.R')
sink('../Res_1_Logs/Log_16w_QC.txt',split = T)
# load data ---------------------------------------------------------------
data <- fread('../Res_3_IntermediateData/16w_age.csv',encoding = 'UTF-8')
if (!file.exists('../Res_2_Results/PreprocRes/')){
  dir.create('../Res_2_Results/PreprocRes/')
}
# check data (whether it is raw data or reverse recoded data) -------------
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
# Rename and recode variables --------------------------------------------------------
data$gender <- data$性别
data$province <- data$省份编号
data$schoolstage <- data$学段
data$grade <- data$年级代码
data$schoolID <- data$学校编号
data$classID <- data$班级编号
data <- rename(data,SubID=id)
data <- select(data,-c(性别,省份编号,学段,年级代码,学校编号,班级编号))
data$region<-RECODE(data$province,"c('北京','天津','河北省','山西省','内蒙古')='华北'; 
                                    c('辽宁省','吉林省','黑龙江省')='东北';
                                    c('上海','江苏省','浙江省','安徽省','福建省','江西省','山东省')='华东';
                                    c('河南省','湖北省','湖南省')='华中';
                                    c('广东省','广西省','海南省')='华南';
                                    c('重庆','四川省','贵州省','云南省','西藏')='西南';
                                    c('陕西省','甘肃省','青海省','宁夏','新藏')='西北';
                                    c('台湾','香港','澳门')='港澳台'; '海外'='海外';")
data <- replace_with_na_at(data,
                           .vars = c('是否独生子女','父母婚姻状态','父亲受教育程度','母亲受教育程度',
                                     '父母期望学历','自我期望学历','母亲职业','父亲职业'),
                        condition = ~.x==" ")
data$排行[data$是否独生子女=='是'] <- 0
data$排行[data$排行>10] <- NA
miss_var_summary(data) %>% as.data.frame() -> miss_value_report
print(miss_value_report)
print_table(miss_value_report,file = '../Res_2_Results/PreprocRes/16w_缺失值报告_质量控制前.doc')
# Identifying C/IER cases in our data ----------------------------------------
cat('Variables:\n')
cat(colnames(data))

data_beforeRec <- IdentifyCarelessResp_P1(data_beforeRec,'学习倦怠')
data_beforeRec <- IdentifyCarelessResp_P1(data_beforeRec,'压力感知')
data_beforeRec <- IdentifyCarelessResp_P1(data_beforeRec,'网络成瘾')
data_beforeRec <- IdentifyCarelessResp_P1(data_beforeRec,'抑郁')
data_beforeRec <- IdentifyCarelessResp_P1(data_beforeRec,'焦虑')
data_beforeRec <- IdentifyCarelessResp_P1(data_beforeRec,'自伤行为')
data_beforeRec <- IdentifyCarelessResp_P1(data_beforeRec,'自杀意念')

data_afterRec <- IdentifyCarelessResp_P2(data_afterRec)

# append careless indices to 'data' ------------------------------------------
CarelessIndices_P1 <- data_beforeRec[,which(
  grepl('IRV_.*',colnames(data_beforeRec)) | 
    grepl('maxlongstring_.*',colnames(data_beforeRec))), with=F]
CarelessIndices_P2 <- select(data_afterRec,c(EvenOddConsistency,MahaDist))
data <- cbind(data,CarelessIndices_P1,CarelessIndices_P2)

# Calculating the overall C/IER indices -----------------------------------
# Calculate the item-level response time
data$ResponseTime_TPI <- data$作答时间_问题行为部分问卷/(16+14+20+10+20+9+14+2)#这里需要加上欺负的两道题
# change the direction of EOC to fit its definition
# Please see notes in 's_CIER_functions.R'
data$EvenOddConsistency <- data$EvenOddConsistency*(-1) 
# According to the definition of IRV, each questionnaire or scale will get a IRV
# value, to summarise these IRV values into a single index, we here calculate a
# weighted sum for all questionnaires, whose IRVs were weighted by the degree of
# freedom (i.e. the denominator in formula of calculating standard deviation).
data$IRV_weightedsum <- sqrt( ( (data$IRV_学习倦怠^2*(16-1)) + 
                                      (data$IRV_压力感知^2*(14-1)) + (data$IRV_网络成瘾^2*(20-1)) + 
                                      (data$IRV_抑郁^2*(10-1)) + (data$IRV_焦虑^2*(20-1)) + 
                                      (data$IRV_自伤行为^2*(9-1)) + (data$IRV_自杀意念^2*(14-1)) ) / 
                                    (16-1+14-1+20-1+10-1+20-1+9-1+14-1) )
# Standardize the weighted sum of IRVs into z-score
data$IRV_weightedsum_zscore <- (
  (data$IRV_weightedsum - mean(data$IRV_weightedsum))/sd(data$IRV_weightedsum) )
# Generate the number of IRV being equals to zeros
data$IRV_number <- (data$IRV_学习倦怠==0) + (data$IRV_压力感知==0) + (data$IRV_网络成瘾==0) + 
  (data$IRV_抑郁==0) + (data$IRV_焦虑==0) + (data$IRV_自伤行为==0) + 
  (data$IRV_自杀意念==0)
# Calculate the sum of max longstring for all questionnaires
data$maxlongstring_all <- data$maxlongstring_学习倦怠 + data$maxlongstring_压力感知 +
  data$maxlongstring_网络成瘾 + data$maxlongstring_抑郁 + data$maxlongstring_焦虑 + 
  data$maxlongstring_自伤行为 + data$maxlongstring_自杀意念

# apply threshold to careless indices -----------------------------------------
data <- fread('../Res_3_IntermediateData/16w_data_age_unclear.txt',encoding = 'UTF-8')
threshold = data.frame(MahaD_SQ = qchisq(0.999, df = 16+14+20+10+20+9+14),
                       EOC = 0.7,
                       MLS = round((16+14+20+10+20+9+14)*0.6),
                       IRV = -2,
                       TPI_Low = 2,
                       TPI_Up = 20)
MahaD_CIER_flag <- data$MahaDist > threshold$MahaD_SQ
EvenOdd_CIER_flag <- data$EvenOddConsistency <= threshold$EOC
longstring_CIER_flag <- data$maxlongstring_all > threshold$MLS
IRV_CIER_flag <- data$IRV_weightedsum_zscore <= threshold$IRV
RT_CIER_flag <- (data$ResponseTime_TPI <= threshold$TPI_Low) | 
  (data$ResponseTime_TPI >= threshold$TPI_Up)
cat('The number of cases were identified as C/IER (stratified by each C/IER index):\n')
cat(sprintf('
            Mahalanobis Distance：%d\n
            Even-odd Consistency：%d\n
            longstring:%d\n
            IRV:%d\n
            RT(API):%d\n', 
        sum(MahaD_CIER_flag),
        sum(EvenOdd_CIER_flag),
        sum(longstring_CIER_flag),
        sum(IRV_CIER_flag),
        sum(RT_CIER_flag)))

CIER_Flag_counts <- MahaD_CIER_flag+EvenOdd_CIER_flag+
  longstring_CIER_flag+IRV_CIER_flag+RT_CIER_flag
cat('The number of cases with abnormal C/IER indices\n')
print(table(CIER_Flag_counts))

CIER_Flag <- (CIER_Flag_counts>=2)
cat(sprintf('Finally, the number of cases were identified by C/IER indices：%d\n',
            sum(CIER_Flag)))
data$CIER_Flag = CIER_Flag


select(data,c(MahaDist,EvenOddConsistency,maxlongstring_all,
              IRV_weightedsum,IRV_number,ResponseTime_TPI)) %>%
  rename(`Squared Mahalanobis Distance` = MahaDist,
         `Even-odd Consistency` = EvenOddConsistency,
         `Max Longstring` = maxlongstring_all,
         `Weighted IRV` = IRV_weightedsum,
         `The number of IRV=0` = IRV_number,
         `Item Response Time` = ResponseTime_TPI) %>% cor() %>% 
  pheatmap(display_numbers = T,fontsize = 14,fontsize_row = 8,fontsize_col = 8,
           angle_col = 315,
           filename = '../Res_2_Results/PreprocRes/pheatmap_CarelessIndics.png')

select(data,c(MahaDist,EvenOddConsistency,maxlongstring_all,
              IRV_weightedsum,IRV_number,ResponseTime_TPI)) %>%
  rename(`D2` = MahaDist,
         `EOC` = EvenOddConsistency,
         `Longstring` = maxlongstring_all,
         `IRV` = IRV_weightedsum,
         `IRV=0` = IRV_number,
         `Item RT` = ResponseTime_TPI) %>%
  Corr(p.adjust = 'bonf',
       plot.colors = c("#2171B5", "white", "#B52127"),
       plot.dpi = 144,plot.width = 8,plot.height = 8,
       file = '../Res_2_Results/PreprocRes/Corr_CarelessIndices.doc',
       plot.file = '../Res_2_Results/PreprocRes/Corr_CarelessIndics.png')

plot.box.distribution(data$MahaDist,
                      '../Res_2_Results/PreprocRes/Distribution_D2',
                      'D2',
                      threshold$MahaD_SQ)
plot.box.distribution(data$EvenOddConsistency,
                      '../Res_2_Results/PreprocRes/Distribution_EvenOdd',
                      'Even-Odd Consistency',
                      threshold$EOC)
plot.box.distribution(data$maxlongstring_all,
                      '../Res_2_Results/PreprocRes/Distribution_Maxlongstring',
                      'sum of max longstring',
                      threshold$MLS)
plot.box.distribution(data$IRV_number,
                      '../Res_2_Results/PreprocRes/Distribution_IRVnumber',
                      'the number of IRV=0',
                      3)
plot.box.distribution(data$IRV_weightedsum,
                      '../Res_2_Results/PreprocRes/Distribution_weightedIRV',
                      'weighted IRV',
                      threshold$IRV)
plot.box.distribution(data$ResponseTime_TPI,
                      '../Res_2_Results/PreprocRes/Distribution_ResponseTime',
                      'Response Time (TPI)',
                      c(threshold$TPI_Low,threshold$TPI_Up))

fwrite(data,file = '../Res_3_IntermediateData/16w_data_age_unclear.txt')
# Age clearing ------------------------------------------------------------
data <- fread('../Res_3_IntermediateData/16w_data_age_unclear.txt',encoding = 'UTF-8')

# 识别异常的自我报告年龄
psych::describeBy(data$Age_years,data$grade,mat = T) %>% 
  print_table(file = '../Res_2_Results/PreprocRes/分年级年龄_清理前.doc')

age_outlier_counts <- sum(is.na(data$Age_months))
cat(sprintf('该样本中年龄缺失的被试数：%d\n',age_outlier_counts))

age_outlier_flag = (data$Age_years < 8) | (data$Age_years > 19 )
cat(sprintf('该样本中年龄小于8岁或大于19岁的被试数：%d\n',sum(age_outlier_flag,na.rm=T)))
age_outlier_counts <- age_outlier_counts + sum(age_outlier_flag,na.rm=T)
age_miss_flag <- is.na(data$Age_months) | age_outlier_flag
cat(sprintf('二者累加的年龄缺失的被试数：%d\n',sum(age_miss_flag)))

age_outlier_bound_flag <- (data$grade == "小学四年级") & ((data$Age_years < 8) | (data$Age_years > 11))
cat(sprintf('小学四年级，年龄不符合该年级惯常年龄的被试数: %d',sum(age_outlier_bound_flag,na.rm = T)))
age_miss_flag = age_miss_flag | replace_na(age_outlier_bound_flag,TRUE)
cat(sprintf('累积的年龄缺失的被试数：%d\n',sum(age_miss_flag)))

age_outlier_bound_flag <- (data$grade == "小学五年级") & ((data$Age_years < 9) | (data$Age_years > 12))
cat(sprintf('小学五年级，年龄不符合该年级惯常年龄的被试数: %d',sum(age_outlier_bound_flag,na.rm = T)))
age_miss_flag = age_miss_flag | replace_na(age_outlier_bound_flag,TRUE)
cat(sprintf('累积的年龄缺失的被试数：%d\n',sum(age_miss_flag)))

age_outlier_bound_flag <- (data$grade == "小学六年级") & ((data$Age_years < 10) | (data$Age_years > 13))
cat(sprintf('小学六年级，年龄不符合该年级惯常年龄的被试数: %d',sum(age_outlier_bound_flag,na.rm = T)))
age_miss_flag = age_miss_flag | replace_na(age_outlier_bound_flag,TRUE)
cat(sprintf('累积的年龄缺失的被试数：%d\n',sum(age_miss_flag)))

age_outlier_bound_flag <- (data$grade == "初一年级") & ((data$Age_years < 11) | (data$Age_years > 14))
cat(sprintf('初中一年级，年龄不符合该年级惯常年龄的被试数: %d',sum(age_outlier_bound_flag,na.rm = T)))
age_miss_flag = age_miss_flag | replace_na(age_outlier_bound_flag,TRUE)
cat(sprintf('累积的年龄缺失的被试数：%d\n',sum(age_miss_flag)))

age_outlier_bound_flag <- (data$grade == "初二年级") & ((data$Age_years < 12) | (data$Age_years > 15))
cat(sprintf('初中二年级，年龄不符合该年级惯常年龄的被试数: %d',sum(age_outlier_bound_flag,na.rm = T)))
age_miss_flag = age_miss_flag | replace_na(age_outlier_bound_flag,TRUE)
cat(sprintf('累积的年龄缺失的被试数：%d\n',sum(age_miss_flag)))

age_outlier_bound_flag <- (data$grade == "初三年级") & ((data$Age_years < 13) | (data$Age_years > 16))
cat(sprintf('初中三年级，年龄不符合该年级惯常年龄的被试数: %d',sum(age_outlier_bound_flag,na.rm = T)))
age_miss_flag = age_miss_flag | replace_na(age_outlier_bound_flag,TRUE)
cat(sprintf('累积的年龄缺失的被试数：%d\n',sum(age_miss_flag)))

age_outlier_bound_flag <- (data$grade == "高一年级") & ((data$Age_years < 14) | (data$Age_years > 17))
cat(sprintf('高中一年级，年龄不符合该年级惯常年龄的被试数: %d',sum(age_outlier_bound_flag,na.rm = T)))
age_miss_flag = age_miss_flag | replace_na(age_outlier_bound_flag,TRUE)
cat(sprintf('累积的年龄缺失的被试数：%d\n',sum(age_miss_flag)))

age_outlier_bound_flag <- (data$grade == "高二年级") & ((data$Age_years < 15) | (data$Age_years > 18))
cat(sprintf('高中二年级，年龄不符合该年级惯常年龄的被试数: %d',sum(age_outlier_bound_flag,na.rm = T)))
age_miss_flag = age_miss_flag | replace_na(age_outlier_bound_flag,TRUE)
cat(sprintf('累积的年龄缺失的被试数：%d\n',sum(age_miss_flag)))

age_outlier_bound_flag <- (data$grade == "高三年级") & ((data$Age_years < 16) | (data$Age_years > 19))
cat(sprintf('高中三年级，年龄不符合该年级惯常年龄的被试数: %d',sum(age_outlier_bound_flag,na.rm = T)))
age_miss_flag = age_miss_flag | replace_na(age_outlier_bound_flag,TRUE)
cat(sprintf('累积的年龄缺失的被试数：%d\n',sum(age_miss_flag)))
# for (i in unique(data$grade)){
#   tmp <- subset(data,grade==i)
#   # tmp$zscored_age <- (
#   #   (tmp$Age_years - mean(tmp$Age_years,na.rm = T) ) / 
#   #     sd(tmp$Age_years,na.rm = T) )
#   # age_outlier_z_flag <- (tmp$zscored_age > 3) | (tmp$zscored_age < -3)
#   if (i=='小学四年级'){
#     age_outlier_bound_flag <- (tmp$Age_years < 8) | (tmp$Age_years > 11)
#   }else if (i=='小学五年级'){
#     age_outlier_bound_flag <- (tmp$Age_years < 9) | (tmp$Age_years > 12)
#   }else if(i=='小学六年级'){
#     age_outlier_bound_flag <- (tmp$Age_years < 10) | (tmp$Age_years > 13)
#   }else if (i=='初中一年级'){
#     age_outlier_bound_flag <- (tmp$Age_years < 11) | (tmp$Age_years > 14)
#   }else if (i=='初中二年级'){
#     age_outlier_bound_flag <- (tmp$Age_years < 12) | (tmp$Age_years > 15)
#   }else if (i=='初中三年级'){
#     age_outlier_bound_flag <- (tmp$Age_years < 13) | (tmp$Age_years > 16)
#   }else if (i=='高中一年级'){
#     age_outlier_bound_flag <- (tmp$Age_years < 14) | (tmp$Age_years > 17)
#   }else if (i=='高中二年级'){
#     age_outlier_bound_flag <- (tmp$Age_years < 15) | (tmp$Age_years > 18)
#   }else if (i=='高中三年级'){
#     age_outlier_bound_flag <- (tmp$Age_years < 16) | (tmp$Age_years > 19)
#   }else{age_outlier_bound_flag<-NA}
#   # give NA value True missing flag
#   # age_outlier_z_flag[is.na(age_outlier_z_flag)] <- T
#   age_outlier_bound_flag[is.na(age_outlier_bound_flag)] <- T
#   
#   # print(sprintf('年级：%s 年龄超过3个标准差的被试数：%d',i,sum(age_outlier_z_flag)))
#   print(sprintf('年级：%s 年龄超过惯常年级年龄的被试数：%d',i,sum(age_outlier_bound_flag)))
#   
#   # age_outlier_flag <- age_outlier_z_flag & age_outlier_bound_flag
#   # print(sprintf('年级：%s 两指标综合年龄异常：%d',i,sum(age_outlier_flag)))
#   age_outlier_flag <- age_outlier_bound_flag
#   age_outlier_counts <- age_outlier_counts+sum(age_outlier_flag)
#   
#   data$Age_years[(data$grade==i)][age_outlier_flag] <- NA
#   data$Age_months[(data$grade==i)][age_outlier_flag] <- NA
#   data$Age_days[(data$grade==i)][age_outlier_flag] <- NA
# }
cat(sprintf('需要年龄插补的被试数：%d\n',sum(age_miss_flag)))
data$AgeMiss_Flag <- age_miss_flag
data$Age_days[age_miss_flag] <- NA
data$Age_months[age_miss_flag] <- NA
data$Age_years[age_miss_flag] <- NA

psych::describeBy(data$Age_years,data$grade,mat = T) %>% 
  print_table(file = '../Res_2_Results/PreprocRes/分年级年龄_清理后.doc')
# impute missing Age ---------------------------------------------
miss_var_summary(data) %>% as.data.frame() %>%
  print_table(file = '../Res_2_Results/PreprocRes/16w_缺失值报告_质量控制后插补前.doc')

data <- impute_knn(data,Age_months~gender+region+schoolstage+schoolID+classID|grade)

# calculate age in years and age in days based on the imputed age in months
data$Age_years <- data$Age_months/12
data$Age_days[is.na(data$Age_days)] <- round(data$Age_years[is.na(data$Age_days)]*365.24)
psych::describeBy(data$Age_years,data$grade,mat = T) %>% 
  print_table(file = '../Res_2_Results/PreprocRes/分年级年龄_插补后.doc')
# change date time format -------------------------------------------------
data$datestamp <- as.Date(data$学习倦怠结束时间,'%m/%d/%Y')
format(data$datestamp,'%Y-%m') %>% table() %>%
  as.data.frame.array() %>%
  print_table(file = '../Res_2_Results/PreprocRes/16w_数据采集时间.doc')

# save the final data after the quality control ---------------------------
if (flagcounts==6){
  write.csv(data,file = '../Res_3_IntermediateData/16w_recoded_QC.txt',fileEncoding = 'UTF-8')
}else if (flagcounts==0){
  write.csv(data,file = '../Res_3_IntermediateData/16w_raw_QC.txt',fileEncoding = 'UTF-8')
}

sink()

