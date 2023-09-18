library(bruceR)
set.wd()
data <- fread('../Res_3_IntermediateData/16w_recoded_QC.txt')
data <- select(data,-V1)

# Tidy the data frame  ----------------------------------------------------
# Change the order of columns in data frame for key demographics
data <- select(data,c(SubID,Age_years,Age_days,Age_months,
                      gender,grade,schoolstage,classID,schoolID,province,region,
                      CIER_Flag,datestamp,
                      everything()))
# Change Column Names: replace Chinese characters with English abbreviation
# English - Chinese bilingual codebook
# RT (Response Time) - 作答时间
# TPI (Time Per Item) - 每道题目的平均作答时间
# MLS (Max Longstring) - 作答模式最长串
# IRV (Intra-individal Response Variance) - 个体内作答变异性
# WSum = Weighted Sum - 加权平均值
# Num = Number - 数量
# IRV_Number - the number of IRV equal to zero, across all questionnaires
# EON (Even-Odd Consistency Index) - 奇偶一致性指数
# MahaD_SQ (Squared Mahalanobis Distance) - 马氏距离的平方
# BeBully (Being bullied by others) - 受欺负
# Bully (Bully others) - 欺负
# Stress (Perceived Stress) - 压力感知
# AcaBo (Academic Burn-out) - 学习倦怠
# IAT (Internet Addiction Test) - 网络成瘾
# Anx (Anxiety) - 焦虑
# Dep (Depression) - 抑郁
# SelfInjury (Non-suicidal Self-injury behavior) - 自伤行为
# SuiciIdea (Suicidal Ideation) - 自杀意念
data <- rename(data,
               BirthDay = 出生日期,
               SingleChild = 是否独生子女,
               ParentsMaritalStatus = 父母婚姻状态,
               Child_Num = 子女数量,
               Child_Rank = 排行,
               EducationLevel_Father = 父亲受教育程度,
               EducationLevel_Mother = 母亲受教育程度,
               EducationLevel_ParentsExpect = 父母期望学历,
               EducationLevel_SelfExpect = 自我期望学历,
               MonthIncome_Father = 父亲月收入,
               MonthIncome_Mother = 母亲月收入,
               Occupation_Father = 父亲职业,
               Occupation_Mother = 母亲职业,
               TimeStamp_Complete_str = 学习倦怠结束时间,
               TimeStamp_Complete_date = datestamp,
               RT_TPI = ResponseTime_TPI,
               RT_BehavioralProblem = 作答时间_问题行为部分问卷,
               RT_Bully = 作答时间_欺负,
               RT_Stress = 作答时间_压力感知,
               RT_AcadBO = 作答时间_学习倦怠,
               RT_IAT = 作答时间_网络成瘾,
               RT_Anx = 作答时间_焦虑,
               RT_Dep = 作答时间_抑郁,
               RT_SelfInjury = 作答时间_自伤行为,
               RT_SuiciIdea = 作答时间_自杀意念,
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
               Gender = gender,
               Grade = grade,
               StudyPhase = schoolstage,
               ClassID = classID,
               SchoolID = schoolID,
               ProvinceLabel = province,
               RegionLabel = region)
colnames(data) <- stringr::str_replace_all(colnames(data),'学习倦怠','AcadBO_')
colnames(data) <- stringr::str_replace_all(colnames(data),'压力感知','Stress_')
colnames(data) <- stringr::str_replace_all(colnames(data),'网络成瘾','IAT_')
colnames(data) <- stringr::str_replace_all(colnames(data),'抑郁','Dep_')
colnames(data) <- stringr::str_replace_all(colnames(data),'焦虑','Anx_')
colnames(data) <- stringr::str_replace_all(colnames(data),'自伤行为','SelfInjury_')
colnames(data) <- stringr::str_replace_all(colnames(data),'自杀意念','SuiciIdea_')
# Change the order of columns in data frame for all variables
data <- select(data,c(SubID,Age_years,Gender,
                      Grade,StudyPhase,ClassID,SchoolID,
                      ProvinceLabel,RegionLabel,
                      SingleChild,Child_Num,Child_Rank,
                      ParentsMaritalStatus,
                      EducationLevel_Father,EducationLevel_Mother,
                      EducationLevel_ParentsExpect,EducationLevel_SelfExpect,
                      MonthIncome_Father,MonthIncome_Mother,
                      Occupation_Mother,Occupation_Father,
                      CIER_Flag,
                      RT_TPI,MLS_Sum,IRV_WSum_Z,EOC,MahaD_SQ,
                      TimeStamp_Complete_date,
                      TimeStamp_Complete_str,
                      BirthDay,
                      Age_days,Age_months,
                      BeBully,Bully,Stress_Sum,AcadBO_Sum,IAT_Sum,Anx_Sum,
                      Dep_Sum,SuiciIdea_Sum,SelfInjury_Sum,
                      RT_Bully,RT_Stress,RT_AcadBO,RT_IAT,RT_Anx,
                      RT_Dep,RT_SuiciIdea,RT_SelfInjury,
                      MLS_Stress,MLS_AcadBO,MLS_IAT,MLS_Anx,
                      MLS_Dep,MLS_SuiciIdea,MLS_SelfInjury,
                      IRV_Stress,IRV_AcadBO,IRV_IAT,IRV_Anx,
                      IRV_Dep,IRV_SuiciIdea,IRV_SelfInjury,
                      IRV_WSum,IRV_Num,
                      everything()))
naniar::miss_var_summary(data) %>% as.data.frame() %>%
  print_table(file = '../Res_2_Results/PreprocRes/16w_缺失值报告_质量控制后插补后.doc')
saveRDS(data,'../Res_3_IntermediateData/16w_recoded_QC_AgeImputed.rds')
# Re-coding Demographic Variables into factors -----------------------------
rm(list=ls())
gc()
data <- readRDS('../Res_3_IntermediateData/16w_recoded_QC_AgeImputed.rds')
# Recode the biological sex for individuals
data$Gender <- RECODE(data$Gender,"'女' = 'Girl';
                                    '男' = 'Boy';")
data$Gender <- factor(data$Gender,levels = c('Girl','Boy'))

# Recode the grade in school for individuals
data$Grade <- RECODE(data$Grade,"'小学四年级'='4TH GRADE';
                                  '小学五年级' = '5TH GRADE';
                                  '小学六年级' = '6TH GRADE';
                                  '初一年级' = '7TH GRADE';
                                  '初二年级' = '8TH GRADE';
                                  '初三年级' = '9TH GRADE';
                                  '高一年级' = '10TH GRADE';
                                  '高二年级' = '11TH GRADE';
                                  '高三年级' = '12TH GRADE';
                                  ")
data$Grade <- factor(data$Grade,levels = c('4TH GRADE','5TH GRADE','6TH GRADE',
                                           '7TH GRADE','8TH GRADE','9TH GRADE',
                                           '10TH GRADE','11TH GRADE','12TH GRADE'),
                     ordered = T)

# Recode the phase of studying for individuals
data$StudyPhase <- RECODE(data$StudyPhase,"'小学'='Primary Education';
                                  '初中' = 'Junior Secondary Education';
                                  '高中' = 'Senior Secondary Education';")
data$StudyPhase <- factor(data$StudyPhase,levels = c('Primary Education',
                                                     'Junior Secondary Education',
                                                     'Senior Secondary Education'))
# Recode the flag of whether individual comes from one-child family or multiple-child family
data$SingleChild <- RECODE(data$SingleChild,"'是' = 'The Only Child';
                                            '否' = 'Multiple-child';
                                            else=NA;")

# Recode the number of children in family
data$Child_Num <- RECODE(data$Child_Num,"0='0';
                                        1='1';
                                        2='2';
                                        3='3';
                                        4='4';
                                        5='5';
                                        6='6';
                                        7:hi = '7 and more';
                                        else=NA;
                                        ")
# recode the rank of individuals in family
data$Child_Rank <- RECODE(data$Child_Rank,"0='0';
                                        1='1';
                                        2='2';
                                        3='3';
                                        4='4';
                                        5='5';
                                        6='6';
                                        7='7';
                                        8='8';
                                        9 = '9';
                                        10 = '10';
                                        else=NA;
                                        ")
# Check the consistency among SingleChild, Child_Num, and Child_Rank
Num_ThreeConsist = sum( (data$SingleChild=='The Only Child')&
                          (data$Child_Num=='0')&
                          (data$Child_Rank=='0'),
                        na.rm=T)
cat(sprintf('Number of individuals consistently indicated as single child:%d\n',Num_ThreeConsist))
            
MissFlag_SingleChild = is.na(data$SingleChild)
Flag_Single_Child = data$SingleChild == 'The Only Child'
Flag_Multiple_Child = data$SingleChild == 'Multiple-child'
Flag_Single_Child_Num = data$Child_Num=='0'
Flag_Single_Child_Rank = data$Child_Rank=='0'
Flag_Multiple_Child_Num = data$Child_Num!='0' & !is.na(data$Child_Num)
Flag_Multiple_Child_Rank = data$Child_Rank!='0' & !is.na(data$Child_Rank)
cat(sprintf('%d individuals miss in single child indicator but indicated as single by Child_Num and Child_Rank\n',
            sum(MissFlag_SingleChild &
                  Flag_Single_Child_Num &
                  Flag_Single_Child_Rank,
                na.rm = T)
            ))
cat(sprintf('%d individuals miss in single child indicator but indicated as non-single by Child_Num and Child_Rank\n',
            sum(MissFlag_SingleChild &
                  Flag_Multiple_Child_Num &
                  Flag_Multiple_Child_Rank,
                na.rm = T)
))
cat(sprintf('%d individuals will be assigned as he/she comes from Multiple-child family',
            sum(MissFlag_SingleChild &
                  Flag_Multiple_Child_Num &
                  Flag_Multiple_Child_Rank,
              na.rm = T)))
data$SingleChild[MissFlag_SingleChild & Flag_Multiple_Child_Num & Flag_Multiple_Child_Rank] = 'Multiple-child'

cat(sprintf('%d individuals indicated as single child by single child indicator are conflict with the other two indicators',
            sum(Flag_Single_Child &
                  Flag_Multiple_Child_Num &
                  Flag_Multiple_Child_Rank,
                na.rm = T)))

cat(sprintf('%d individuals indicated as multiple child by single child indicator are conflict with the other two indicators',
            sum(Flag_Multiple_Child &
                  Flag_Single_Child_Num &
                  Flag_Single_Child_Rank,
                na.rm = T)))
cat(sprintf('%d individuals will be re-assigned as he/she comes from The Only Child family',
            sum(Flag_Multiple_Child &
                  Flag_Single_Child_Num &
                  Flag_Single_Child_Rank,
                na.rm = T)))
data$SingleChild[Flag_Multiple_Child & Flag_Single_Child_Num & Flag_Single_Child_Rank] = 'The Only Child'

data$SingleChild <- factor(data$SingleChild,levels = c('The Only Child',
                                                       'Multiple-child'))


# Recode Family-related Demographic variables -----------------------------
# Re-code the Parents' Marital Status into a 3-level categorical variable
data$ParentsMaritalStatus_3L <- RECODE(data$ParentsMaritalStatus,
                                    "'初婚(双方都是第一次结婚)' = 'Married or living with partner';
                                    '再婚' = 'Married or living with partner';
                                    '离婚' = 'Single';
                                    '单亲(双方有一方因故去世) ' = 'Single';
                                    '其他' = 'Other';")
data$ParentsMaritalStatus_3L <- factor(data$ParentsMaritalStatus_3L,
                                       levels = c('Married or living with partner',
                                                  'Single',
                                                  'Other'))
# Re-code father or mother's education level to a 6-level categorical variable
data$EducationLevel_Father <- RECODE(data$EducationLevel_Father,
                                     "'小学或小学以下'='Primary Education or below';
                                     '初中'='Junior Secondary Education';
                                     '高中或中专或职高'='Senior or Vocational Secondary Education';
                                     '大专'='Higher Vocational Education';
                                     '本科'='Bachelor Degree';
                                     '硕士及以上'='Master Degree and above';
                                     else=NA;")
data$EducationLevel_Father <- factor(data$EducationLevel_Father,
                                       levels = c('Primary Education or below',
                                                  'Junior Secondary Education',
                                                  'Senior or Vocational Secondary Education',
                                                  'Higher Vocational Education',
                                                  'Bachelor Degree',
                                                  'Master Degree and above'),
                                     ordered = T)
data$EducationLevel_Mother <- RECODE(data$EducationLevel_Mother,
                                     "'小学或小学以下'='Primary Education or below';
                                     '初中'='Junior Secondary Education';
                                     '高中或中专或职高'='Senior or Vocational Secondary Education';
                                     '大专'='Higher Vocational Education';
                                     '本科'='Bachelor Degree';
                                     '硕士及以上'='Master Degree and above';
                                     else=NA;")
data$EducationLevel_Mother <- factor(data$EducationLevel_Mother,
                                     levels = c('Primary Education or below',
                                                'Junior Secondary Education',
                                                'Senior or Vocational Secondary Education',
                                                'Higher Vocational Education',
                                                'Bachelor Degree',
                                                'Master Degree and above'),
                                     ordered = T)
# Combine parents' education level and generate the Parents' Highest Education Level
ParentsHighestEdu <- select(data,c(EducationLevel_Father,EducationLevel_Mother))
ParentsHighestEdu$EducationLevel_Father <- as.numeric(ParentsHighestEdu$EducationLevel_Father)
ParentsHighestEdu$EducationLevel_Mother <- as.numeric(ParentsHighestEdu$EducationLevel_Mother)
ParentsHighestEdu <- replace_na(ParentsHighestEdu,list(EducationLevel_Father=0,EducationLevel_Mother=0))
ParentsHighestEdu <- apply(ParentsHighestEdu,1,max)
# Re-code the Parents' Highest Education Level into 6-level, 3-level, 2-level categorical variables
data$ParentsHighestEdu_6L <- RECODE(ParentsHighestEdu,
                            "1='Primary Education or below';
                             2='Junior Secondary Education';
                             3='Senior or Vocational Secondary Education';
                             4='Higher Vocational Education';
                             5='Bachelor Degree';
                             6='Master Degree and above';
                            else=NA;")
data$ParentsHighestEdu_6L <- factor(data$ParentsHighestEdu_6L,
                                    levels = c('Primary Education or below',
                                               'Junior Secondary Education',
                                               'Senior or Vocational Secondary Education',
                                               'Higher Vocational Education',
                                               'Bachelor Degree',
                                               'Master Degree and above'),
                                    ordered = T)
data$ParentsHighestEdu_3L <- RECODE(ParentsHighestEdu,
                            "1='Primary Education or below';
                             2='Secondary Education';
                             3='Secondary Education';
                             4='Higher Education';
                             5='Higher Education';
                             6='Higher Education';
                            else=NA;")
data$ParentsHighestEdu_3L <- factor(data$ParentsHighestEdu_3L,
                                    levels = c('Primary Education or below',
                                               'Secondary Education',
                                               'Higher Education'))
data$ParentsHighestEdu_2L <- RECODE(ParentsHighestEdu,
                                    "1='high school or below';
                             2='high school or below';
                             3='high school or below';
                             4='college and above';
                             5='college and above';
                             6='college and above';
                            else=NA;")
data$ParentsHighestEdu_2L <- factor(data$ParentsHighestEdu_2L,
                                    levels = c('high school or below',
                                               'college and above'))
# Re-code the parent-expected child's education level and child-self-expected education level into 6-level categorical variable
data$EducationLevel_ParentsExpect <- RECODE(data$EducationLevel_ParentsExpect,
                                     "'初中'='Junior Secondary Education';
                                     '高中'='Senior Secondary Education';
                                     '大专'='Higher Vocational Education';
                                     '本科'='Bachelor Degree';
                                     '硕士'='Master Degree';
                                     '博士'='Doctor Degree';
                                      else=NA;")
data$EducationLevel_ParentsExpect <- factor(data$EducationLevel_ParentsExpect,
                                     levels = c('Junior Secondary Education',
                                                'Senior Secondary Education',
                                                'Higher Vocational Education',
                                                'Bachelor Degree',
                                                'Master Degree',
                                                'Doctor Degree'),
                                     ordered = T)
data$EducationLevel_SelfExpect <- RECODE(data$EducationLevel_SelfExpect,
                                    "'初中'='Junior Secondary Education';
                                     '高中'='Senior Secondary Education';
                                     '大专'='Higher Vocational Education';
                                     '本科'='Bachelor Degree';
                                     '硕士'='Master Degree';
                                     '博士'='Doctor Degree';
                                      else=NA;")
data$EducationLevel_SelfExpect <- factor(data$EducationLevel_SelfExpect,
                                            levels = c('Junior Secondary Education',
                                                       'Senior Secondary Education',
                                                       'Higher Vocational Education',
                                                       'Bachelor Degree',
                                                       'Master Degree',
                                                       'Doctor Degree'),
                                            ordered = T)
# Calculated the gap value between parent-expected and self-expected education level
ExpectedEducationLevel <- select(data,c(EducationLevel_ParentsExpect,EducationLevel_SelfExpect))
ExpectedEducationLevel$EducationLevel_ParentsExpect <- as.numeric(ExpectedEducationLevel$EducationLevel_ParentsExpect)
ExpectedEducationLevel$EducationLevel_SelfExpect <- as.numeric(ExpectedEducationLevel$EducationLevel_SelfExpect)
ExpectedEdu_Gap <- (ExpectedEducationLevel$EducationLevel_ParentsExpect - ExpectedEducationLevel$EducationLevel_SelfExpect)
data$ExpectedEdu_Gap <- RECODE(ExpectedEdu_Gap,
                               "lo:-1='Higher Parents Expectation';
                               0='Equal Expectation';
                               1:hi = 'Lower Parents Expectation';")
data$ExpectedEdu_Gap <- factor(data$ExpectedEdu_Gap,
                               levels = c('Equal Expectation',
                                          'Higher Parents Expectation',
                                          'Lower Parents Expectation'))
# Recode Region Label into a 4-level categorical variable -----------------
# according to the definition made by National Bureau of Statistics of China
data$Region_4L <- RECODE(data$ProvinceLabel,
  "c('北京','天津','河北省','上海','江苏省','浙江省','福建省','山东省','广东省','海南省')='Eastern Region'; 
  c('辽宁省','吉林省','黑龙江省')='Northeast Region';
  c('内蒙古','广西省','重庆','四川省','贵州省','云南省','西藏','陕西省','甘肃省','青海省','宁夏','新疆')='Western Region';
  c('山西省','安徽省','江西省','河南省','湖北省','湖南省')='Central Region';")
data$Region_4L <- factor(data$Region_4L,
                         levels = c('Eastern Region',
                                    'Northeast Region',
                                    'Western Region',
                                    'Central Region'))
# Save Re-coded data into RDS file ----------------------------------------

saveRDS(data,'../Res_3_IntermediateData/16w_BehavProb_Full.rds')
data_compact <- select(data,-c(Child_Num,Child_Rank,
                               EducationLevel_Father,
                               EducationLevel_Mother,
                               EducationLevel_ParentsExpect,
                               EducationLevel_SelfExpect,
                               MonthIncome_Father,
                               MonthIncome_Mother,
                               Occupation_Mother,
                               Occupation_Father,
                               TimeStamp_Complete_str,
                               ParentsMaritalStatus,
                               RegionLabel))
data_compact <- select(data_compact,
                       c(SubID,Age_years,Gender,Grade,StudyPhase,
                         SingleChild,ParentsMaritalStatus_3L,
                         ParentsHighestEdu_2L,ExpectedEdu_Gap,Region_4L,
                         ProvinceLabel,everything()))
saveRDS(data_compact,'../Res_3_IntermediateData/16w_BehavProb_Compact.rds')
