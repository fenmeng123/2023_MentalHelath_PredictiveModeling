<<<<<<< HEAD
# -*- coding: utf-8 -*-
"""
Created on Fri Apr 21 20:51:03 2023

@author: Kunru Song
"""
#%% Import Basic Modules
import os,sys
import numpy as np
import pandas as pd
# Change Working Directory
os.chdir(os.path.dirname(os.path.abspath(__file__)))
#%% Script Parameter Settings
test_prop = 0.5
train_prop = 0.5
K_matchedneg = 10
Selected_Features = ["Grade","Stress_Sum","AcadBO_Sum","IAT_Sum","Anx_Sum",
     "SelfInjury_Sum","BeBully_Bin"]
Y_Name = ["Depression_Label"]
L2Norm_pool = np.logspace(-6,6,1000)
#%% Import Self-defined modules by Kunru Song 
# Create a folder to save the results of this script
if not os.path.exists('../Res_2_Results/ResML_OptimeHyperpara_Dep'):
    os.mkdir('../Res_2_Results/ResML_OptimeHyperpara_Dep')
# # Create Log File for this script
log_file_name = '../Res_1_Logs/Log_ML_5_Optim_Depression.txt'
stdout_backup = sys.stdout
myLogger = open(log_file_name,'a')
sys.stdout = myLogger
# Import User-defined functions and objects
# Subfunction
def TrainMdl_PipeWithPred_SearchHyperpara(instance_MdlPipe,dfpt,feature_pool):
    print('=============================Start================================')
    print('||--Model Name:%s--||' %(instance_MdlPipe.name))
    Report = Classifier_AutoRepot(instance_MdlPipe.name)
    instance_MdlPipe.pipe.fit(Partition.train_X,Partition.train_Y);
    Report.RunAll(instance_MdlPipe.pipe.predict(dfpt.test_X),dfpt.test_Y)
    Report.SaveResult(instance_MdlPipe.name)
    Report.ShowCompactMetrics()
    print('=============================End==================================')
    return(Report)
def RerunModelPipeline(iterations,instance_MdlPipe,L2Norm_pool,dfpt,feature_pool,test_prop,train_prop,K_matchedneg):
    for i in range(len(L2Norm_pool)):
        print('## Hyper-parameter: lambda_l2norm = %d ##' %(L2Norm_pool[i]))
        instance_MdlPipe.L2Logit(L2Norm_pool[i])
        for j in range(iterations):
            print('## IterNum: %d ##' %(j))
            dfpt.ReSplit(test_prop,train_prop,K_matchedneg)
            ResRep = TrainMdl_PipeWithPred_SearchHyperpara(instance_MdlPipe,dfpt,feature_pool)
            ResRep.Res['Lambda2']=L2Norm_pool[i]
            ResRep.Res['IterNum']=j
            if (j==0) & (i==0):
                IterResult = ResRep.Res
            else:
                IterResult = pd.concat([IterResult,ResRep.Res],ignore_index=True)
    return(IterResult)
from subfunctions.s_DataPartition import Data_Partition
from subfunctions.s_ResultAssitant import Classifier_AutoRepot
from subfunctions.s_ModelPipeline  import Mdl_Pipe
#%% Load and Prepare Data
data = pd.read_csv('../Res_3_IntermediateData/16w_MLdata_prepared.csv')
dat = data[data.CIER_Flag==0]
dat = dat[Selected_Features+Y_Name]
#%% Run Modelling
Partition = Data_Partition(dat,Selected_Features,Y_Name[0])
Partition.Stratify(test_prop,train_prop,seed=0)
Partition.SampleBalance(K=10,neg_index=0)
clfset = Mdl_Pipe('L2Logit')
IterResult = RerunModelPipeline(100,clfset,L2Norm_pool,Partition,
                                Selected_Features,
                                test_prop,train_prop,
                                K_matchedneg)
IterResult.to_excel('../Res_2_Results/ResML_OptimeHyperpara_Dep/ResML_L2Logit_RFECV_IterNum1000.xlsx')
#%% End of this script
myLogger.close()
sys.stdout = stdout_backup



=======
# -*- coding: utf-8 -*-
"""
Created on Fri Apr 21 20:51:03 2023

@author: Kunru Song
"""
#%% Import Basic Modules
import os,sys
import numpy as np
import pandas as pd
# Change Working Directory
os.chdir(os.path.dirname(os.path.abspath(__file__)))
#%% Script Parameter Settings
test_prop = 0.5
train_prop = 0.5
K_matchedneg = 10
Selected_Features = ["Grade","Stress_Sum","AcadBO_Sum","IAT_Sum","Anx_Sum",
     "SelfInjury_Sum","BeBully_Bin"]
Y_Name = ["Depression_Label"]
L2Norm_pool = np.logspace(-6,6,1000)
#%% Import Self-defined modules by Kunru Song 
# Create a folder to save the results of this script
if not os.path.exists('../Res_2_Results/ResML_OptimeHyperpara_Dep'):
    os.mkdir('../Res_2_Results/ResML_OptimeHyperpara_Dep')
# # Create Log File for this script
log_file_name = '../Res_1_Logs/Log_ML_5_Optim_Depression.txt'
stdout_backup = sys.stdout
myLogger = open(log_file_name,'a')
sys.stdout = myLogger
# Import User-defined functions and objects
# Subfunction
def TrainMdl_PipeWithPred_SearchHyperpara(instance_MdlPipe,dfpt,feature_pool):
    print('=============================Start================================')
    print('||--Model Name:%s--||' %(instance_MdlPipe.name))
    Report = Classifier_AutoRepot(instance_MdlPipe.name)
    instance_MdlPipe.pipe.fit(Partition.train_X,Partition.train_Y);
    Report.RunAll(instance_MdlPipe.pipe.predict(dfpt.test_X),dfpt.test_Y)
    Report.SaveResult(instance_MdlPipe.name)
    Report.ShowCompactMetrics()
    print('=============================End==================================')
    return(Report)
def RerunModelPipeline(iterations,instance_MdlPipe,L2Norm_pool,dfpt,feature_pool,test_prop,train_prop,K_matchedneg):
    for i in range(len(L2Norm_pool)):
        print('## Hyper-parameter: lambda_l2norm = %d ##' %(L2Norm_pool[i]))
        instance_MdlPipe.L2Logit(L2Norm_pool[i])
        for j in range(iterations):
            print('## IterNum: %d ##' %(j))
            dfpt.ReSplit(test_prop,train_prop,K_matchedneg)
            ResRep = TrainMdl_PipeWithPred_SearchHyperpara(instance_MdlPipe,dfpt,feature_pool)
            ResRep.Res['Lambda2']=L2Norm_pool[i]
            ResRep.Res['IterNum']=j
            if (j==0) & (i==0):
                IterResult = ResRep.Res
            else:
                IterResult = pd.concat([IterResult,ResRep.Res],ignore_index=True)
    return(IterResult)
from subfunctions.s_DataPartition import Data_Partition
from subfunctions.s_ResultAssitant import Classifier_AutoRepot
from subfunctions.s_ModelPipeline  import Mdl_Pipe
#%% Load and Prepare Data
data = pd.read_csv('../Res_3_IntermediateData/16w_MLdata_prepared.csv')
dat = data[data.CIER_Flag==0]
dat = dat[Selected_Features+Y_Name]
#%% Run Modelling
Partition = Data_Partition(dat,Selected_Features,Y_Name[0])
Partition.Stratify(test_prop,train_prop,seed=0)
Partition.SampleBalance(K=10,neg_index=0)
clfset = Mdl_Pipe('L2Logit')
IterResult = RerunModelPipeline(100,clfset,L2Norm_pool,Partition,
                                Selected_Features,
                                test_prop,train_prop,
                                K_matchedneg)
IterResult.to_excel('../Res_2_Results/ResML_OptimeHyperpara_Dep/ResML_L2Logit_RFECV_IterNum1000.xlsx')
#%% End of this script
myLogger.close()
sys.stdout = stdout_backup



>>>>>>> origin/main
