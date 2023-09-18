library(bruceR)
library(datawizard)
set.wd()

data <- readRDS('../Res_3_IntermediateData/16w_BehavProb_Compact.rds')
Thresh = list(GRADE_4TH = c(8,11),
              GRADE_5TH = c(9,12),
              GRADE_6TH = c(10,13),
              GRADE_7TH = c(11,14),
              GRADE_8TH = c(12,15),
              GRADE_9TH = c(13,16),
              GRADE_10TH = c(14,17),
              GRADE_11TH = c(15,18),
              GRADE_12TH = c(16,19))

Flag <- data$Grade == '4TH GRADE'
data$Age_months[Flag] <- winsorize(data$Age_months[Flag],method='raw',threshold=Thresh$GRADE_4TH*12)

Flag <- data$Grade == '5TH GRADE'
data$Age_months[Flag] <- winsorize(data$Age_months[Flag],method='raw',threshold=Thresh$GRADE_5TH*12)

Flag <- data$Grade == '6TH GRADE'
data$Age_months[Flag] <- winsorize(data$Age_months[Flag],method='raw',threshold=Thresh$GRADE_6TH*12)

Flag <- data$Grade == '7TH GRADE'
data$Age_months[Flag] <- winsorize(data$Age_months[Flag],method='raw',threshold=Thresh$GRADE_7TH*12)

Flag <- data$Grade == '8TH GRADE'
data$Age_months[Flag] <- winsorize(data$Age_months[Flag],method='raw',threshold=Thresh$GRADE_8TH*12)

Flag <- data$Grade == '9TH GRADE'
data$Age_months[Flag] <- winsorize(data$Age_months[Flag],method='raw',threshold=Thresh$GRADE_9TH*12)

Flag <- data$Grade == '10TH GRADE'
data$Age_months[Flag] <- winsorize(data$Age_months[Flag],method='raw',threshold=Thresh$GRADE_10TH*12)

Flag <- data$Grade == '11TH GRADE'
data$Age_months[Flag] <- winsorize(data$Age_months[Flag],method='raw',threshold=Thresh$GRADE_11TH*12)

Flag <- data$Grade == '12TH GRADE'
data$Age_months[Flag] <- winsorize(data$Age_months[Flag],method='raw',threshold=Thresh$GRADE_12TH*12)

data$Age_years <- data$Age_months/12

saveRDS(data,'../Res_3_IntermediateData/16w_BehavProb_Compact_AgeWinsor.rds')

