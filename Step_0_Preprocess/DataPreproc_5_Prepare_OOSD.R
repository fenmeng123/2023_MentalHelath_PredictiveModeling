library(bruceR)
library(careless)
set.wd()
source('../Supp_0_Subfunctions/s_CIER_functions.R')
data <- fread('../Res_3_IntermediateData/181w_raw.csv',encoding = 'UTF-8')
# check data (whether it is raw data or reverse recoded data) -------------
res <- CheckItemType(data)
data_beforeRec <- res$data_beforeRec
data_afterRec <- res$data_afterRec
rm(res)
gc()
# Identifying C/IER cases in out of sample data ------------------------------
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
rm(data_beforeRec,data_afterRec)
rm(CarelessIndices_P1,CarelessIndices_P2)
gc()
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

# Change Column Names: replace Chinese characters with English abbr ----------

data <- rename(data,
               SubID = 用户编号,
               Gender = 性别,
               Grade = 年级代码,
               StudyPhase = 学段,
               SchoolID = 学校编号,
               ProvinceLabel = 省份代码,
               RegionLabel = 区域代码,
               MLS_Stress = maxlongstring_压力感知,
               MLS_AcadBO = maxlongstring_学习倦怠,
               MLS_IAT = maxlongstring_网络成瘾,
               MLS_Anx = maxlongstring_焦虑,
               MLS_Dep = maxlongstring_抑郁,
               MLS_SelfInjury = maxlongstring_自伤行为,
               MLS_SuiciIdea = maxlongstring_自杀意念,
               MLS_Sum = maxlongstring_all,
               IRV_Stress = IRV_压力感知,
               IRV_AcadBO = IRV_学习倦怠,
               IRV_IAT = IRV_网络成瘾,
               IRV_Anx = IRV_焦虑,
               IRV_Dep = IRV_抑郁,
               IRV_SelfInjury = IRV_自伤行为,
               IRV_SuiciIdea = IRV_自杀意念,
               IRV_WSum = IRV_weightedsum,
               IRV_WSum_Z = IRV_weightedsum_zscore,
               IRV_Num = IRV_number,
               EOC = EvenOddConsistency,
               MahaD_SQ = MahaDist,
               BeBully = 受欺负,
               Bully = 欺负,
               Stress_Sum = 压力感知总分,
               AcadBO_Sum = 学习倦怠总分,
               IAT_Sum = 网络成瘾总分,
               Anx_Sum = 焦虑总分,
               Dep_Sum = 抑郁总分,
               SelfInjury_Sum = 自伤行为总分,
               SuiciIdea_Sum = 自杀意念总分,
               )
colnames(data) <- stringr::str_replace_all(colnames(data),'学习倦怠','AcadBO_')
colnames(data) <- stringr::str_replace_all(colnames(data),'压力感知','Stress_')
colnames(data) <- stringr::str_replace_all(colnames(data),'网络成瘾','IAT_')
colnames(data) <- stringr::str_replace_all(colnames(data),'抑郁','Dep_')
colnames(data) <- stringr::str_replace_all(colnames(data),'焦虑','Anx_')
colnames(data) <- stringr::str_replace_all(colnames(data),'自伤行为','SelfInjury_')
colnames(data) <- stringr::str_replace_all(colnames(data),'自杀意念','SuiciIdea_')
saveRDS(data,'../Res_3_IntermediateData/181w_QC.rds')
# Recoding demographic variables ------------------------------------------
# Codebook:
# Gender: 1-boy, 2-girl
# Grade: -1-小学三年级, 0-小学四年级, 1-小学五年级, 2-小学六年级,
#        3-初中一年级, 4-初中二年级, 5-初中三年级, 6-高中一年级,
#        7-高中二年级, 8-高中三年级
# StudyPhase: 1-小学, 2-初中, 3-高中
# ProvinceLabel: 1-北京, 2-天津, 3-河北省, 4-山西省, 5-内蒙古自治区, 
#                6-辽宁省, 7-吉林省, 8-黑龙江省, 9-上海, 10-江苏省,
#                11-浙江省, 12-安徽省, 13-福建省, 14-江西省, 15-山东省,
#                16-河南省, 17-湖北省, 18-湖南省, 19-广东省, 20-广西壮族自治区,
#                21-海南省, 22-重庆, 23-四川省, 24-贵州省, 25-云南省,
#                26-西藏自治区, 27-陕西省, 28-甘肃省, 29-青海省,
#                30-宁夏回族自治区, 31-新疆维吾尔族自治区, 32-台湾省,
#                33-香港特别行政区, 34-澳门特别行政区, 35-海外
data$Gender <- RECODE(data$Gender,"'2' = 'Girl';
                                    '1' = 'Boy';")
data$Gender <- factor(data$Gender,levels = c('Girl','Boy'))

# Recode the grade in school for individuals
data$Grade <- RECODE(data$Grade,
                      "-1 = '3TH GRADE';
                      0 = '4TH GRADE';
                      1 = '5TH GRADE';
                      2 = '6TH GRADE';
                      3 = '7TH GRADE';
                      4 = '8TH GRADE';
                      5 = '9TH GRADE';
                      6 = '10TH GRADE';
                      7 = '11TH GRADE';
                      8 = '12TH GRADE';
                      ")
data$Grade <- factor(data$Grade,levels = c('3TH GRADE','4TH GRADE','5TH GRADE','6TH GRADE',
                                           '7TH GRADE','8TH GRADE','9TH GRADE',
                                           '10TH GRADE','11TH GRADE','12TH GRADE'),
                     ordered = T)

# Recode the phase of studying for individuals
data$StudyPhase <- RECODE(data$StudyPhase,"1='Primary Education';
                                  2 = 'Junior Secondary Education';
                                  3 = 'Senior Secondary Education';")
data$StudyPhase <- factor(data$StudyPhase,levels = c('Primary Education',
                                                     'Junior Secondary Education',
                                                     'Senior Secondary Education'))   
# Recode Region Label into a 4-level categorical variable -----------------
# according to the definition made by National Bureau of Statistics of China
data$Region_4L <- RECODE(data$ProvinceLabel,
 "c(1,2,3,9,10,11,13,15,19,21)='Eastern Region'; 
  c(6,7,8)='Northeast Region';
  c(5,20,22,23,24,25,26,27,28,29,30,31)='Western Region';
  c(4,12,14,16,17,18)='Central Region';")
data$Region_4L <- factor(data$Region_4L,
                         levels = c('Eastern Region',
                                    'Northeast Region',
                                    'Western Region',
                                    'Central Region'))
saveRDS(data,'../Res_3_IntermediateData/181w_recoded_QC.rds')

