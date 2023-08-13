library(bruceR)
library(mice)
rm(list=ls())
gc()
set.wd()
data <- readRDS('../Res_3_IntermediateData/16w_BehavProb_Full.rds')

# Chained Equation Imputation for other Key demographic variables ---------
n.imp = 5
n.iter = 5

var.ls <- c("SubID", "Age_years", "Gender", "StudyPhase","Region_4L",
            "SingleChild","ParentsHighestEdu_2L","ParentsMaritalStatus_3L",
            "EducationLevel_ParentsExpect","EducationLevel_SelfExpect")
dat0 <- data[, var.ls, with = FALSE ]


ini <- mice( dat0, m = 1, maxit = 0 )
meth = ini$meth

meth["SingleChild"]     <- "logreg"
meth["ParentsHighestEdu_2L"] <- "logreg"
meth["ParentsMaritalStatus_3L"]   <- "polyreg"
meth["EducationLevel_ParentsExpect"]      <- "polr"
meth["EducationLevel_SelfExpect"]  <- "polr"

pred = ini$pred

# Excluding variables from the imputation models
pred[, c("SubID") ] <- 0


# Specifying parameters for the imputation
post <- mice( dat0, meth = meth, pred = pred, seed = 111,
              m = 1, maxit = 0)$post

dat.imp <- mice( dat0, meth = meth, pred = pred, post = post,
                 seed = 1111,
                 m = n.imp, maxit = n.iter)
rm(dat0)

# get one imputed dataset out
completedData <- complete(dat.imp,1)
data[, var.ls] = completedData

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

saveRDS(data,'../Res_3_IntermediateData/16w_BehavProb_Full_imputed.rds')
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
saveRDS(data_compact,'../Res_3_IntermediateData/16w_BehavProb_Compact_imputed.rds')
