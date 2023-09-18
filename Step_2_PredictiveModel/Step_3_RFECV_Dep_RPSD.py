# -*- coding: utf-8 -*-
"""
Created on Thu Apr 20 14:46:30 2023

@author: Kunru Song
"""
#%% Load Module and data
import os,sys
import numpy as np
import pandas as pd
# Change Working Directory
os.chdir(os.path.dirname(os.path.abspath(__file__)))
# Import User-defined functions
from subfunctions.s_DataPartition import Data_Partition
from subfunctions.s_ResultAssitant import Classifier_AutoRepot
from subfunctions.s_ModelPipeline  import Mdl_Pipe
# Load and Prepare Data
data = pd.read_csv('../Res_3_IntermediateData/16w_MLdata_prepared.csv')
dat = data[data.CIER_Flag==0]
dat = dat[["Gender_Girl","Grade","Stress_Sum","AcadBO_Sum","IAT_Sum","Anx_Sum",
     "SelfInjury_Sum","BeBully_Bin","Bully_Bin","Depression_Label"]]
#%% Prepare Scirpt before Constructing Predictive Model
# Create a folder to save the results of this script
if not os.path.exists('../Res_2_Results/ResML_RFECV_Dep'):
    os.mkdir('../Res_2_Results/ResML_RFECV_Dep')
# # Create Log File for this script
log_file_name = '../Res_1_Logs/Log_ML_3_RFECV_Depression.txt'
stdout_backup = sys.stdout
myLogger = open(log_file_name,'a')
sys.stdout = myLogger
# Subfunction
def TrainMdl_PipeWithPred(instance_MdlPipe,dfpt,feature_pool):
    print('=============================Start================================')
    print('||--Model Name:%s--||' %(instance_MdlPipe.name))
    Report = Classifier_AutoRepot(instance_MdlPipe.name)
    instance_MdlPipe.pipe.fit(Partition.train_X,Partition.train_Y);
    Report.RunAll(instance_MdlPipe.pipe.predict(dfpt.test_X),dfpt.test_Y)
    Report.SaveResult(instance_MdlPipe.name)
    Report.ShowCompactMetrics()
    instance_MdlPipe.get_feature_rank(feature_pool,'feature_selection')
    instance_MdlPipe.get_feature_importance('classifier')
    instance_MdlPipe.feature_rank.columns = 'rank_'+instance_MdlPipe.feature_rank.columns
    instance_MdlPipe.feature_importance.columns = 'coef_'+instance_MdlPipe.feature_importance.columns
    instance_MdlPipe.feature_rank.reset_index(drop=True,inplace=True)
    instance_MdlPipe.feature_importance.reset_index(drop=True,inplace=True)
    instance_MdlPipe.predictive_power = pd.concat(
        [instance_MdlPipe.feature_rank,instance_MdlPipe.feature_importance],
                                                  axis=1)
    Report.Res.reset_index(drop=True,inplace=True)
    Report.Res = pd.concat([Report.Res,instance_MdlPipe.predictive_power],
                           axis=1)
    print('=============================End==================================')
    return(Report)
def RerunModelPipeline(iterations,instance_MdlPipe,dfpt,feature_pool,test_prop,train_prop,K_matchedneg):
    for i in range(iterations):
        print('## IterNum: %d ##' %(i))
        dfpt.ReSplit(test_prop,train_prop,K_matchedneg)
        ResRep = TrainMdl_PipeWithPred(instance_MdlPipe,dfpt,feature_pool)
        ResRep.Res['IterNum']=i
        if i==0:
            IterResult = ResRep.Res
        else:
            IterResult = pd.concat([IterResult,ResRep.Res],ignore_index=True)
    return(IterResult)
#%%
#%% Parameter Settings
feature_pool=["Gender_Girl","Grade",
              "Stress_Sum","AcadBO_Sum","IAT_Sum","Anx_Sum",
              "SelfInjury_Sum","BeBully_Bin","Bully_Bin"]
#---------------------------------#
# Parameter Settings
test_prop = 0.5
train_prop = 0.5
K_matchedneg = 10
#---------------------------------#
Partition = Data_Partition(dat,feature_pool,'Depression_Label')
Partition.Stratify(test_prop,train_prop,seed=0)
Partition.SampleBalance(K=10,neg_index=0)
#%%
clfset = Mdl_Pipe('L2Logit')
clfset.RFECV_L2Logit(innerCV=10,lambda_L2=1)
ResRep = TrainMdl_PipeWithPred(clfset,Partition,feature_pool)
IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
IterResult.to_excel('../Res_2_Results/ResML_RFECV_Dep/ResML_L2Logit_RFECV_IterNum1000.xlsx')
#%% End of this script
myLogger.close()
sys.stdout = stdout_backup


