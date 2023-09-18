<<<<<<< HEAD
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 17 20:35:11 2023

@author: 35031
"""
#%% Initializing this script
# Import Basic Module
import os,sys
import numpy as np
import pandas as pd
# Change Working Directory
os.chdir(os.path.dirname(os.path.abspath(__file__)))
# Import User-defined functions
from subfunctions.s_DataPartition import Data_Partition
from subfunctions.s_ResultAssitant import Classifier_AutoRepot
from subfunctions.s_ModelPipeline  import Mdl_Pipe
#%% Load and Prepare Data
data = pd.read_csv('../Res_3_IntermediateData/16w_MLdata_prepared.csv')
dat = data[data.CIER_Flag==0]
dat = dat[["Gender_Girl","Grade","Stress_Sum","AcadBO_Sum","IAT_Sum","Anx_Sum",
     "SelfInjury_Sum","BeBully_Bin","Bully_Bin","SuiciIdea_Label"]]
# Create a folder to save the results of this script
if not os.path.exists('../Res_2_Results/ResML_CompareAlogrithm_Suicide'):
    os.mkdir('../Res_2_Results/ResML_CompareAlogrithm_Suicide')
# # Create Log File for this script
log_file_name = '../Res_1_Logs/Log_ML_2_CompareAlgorithem_Suicide.txt'
stdout_backup = sys.stdout
myLogger = open(log_file_name,'a')
sys.stdout = myLogger
# Subfunction
def TrainMdl_PipeWithPred(instance_MdlPipe,dfpt,feature_pool):
    print('=============================Start================================')
    print('||--Model Name:%s--||' %(instance_MdlPipe.name))
    Report = Classifier_AutoRepot(instance_MdlPipe.name)
    instance_MdlPipe.pipe.fit(Partition.train_X,Partition.train_Y);
    print('ACC=%.4f' %(instance_MdlPipe.pipe.score(dfpt.test_X,dfpt.test_Y)))
    # instance_MdlPipe.get_feature_rank(feature_pool,selector_index)
    Report.RunAll(instance_MdlPipe.pipe.predict(dfpt.test_X),dfpt.test_Y)
    Report.SaveResult(instance_MdlPipe.name)
    Report.ShowAllMetrics()
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
Partition = Data_Partition(dat,feature_pool,'SuiciIdea_Label')
Partition.Stratify(test_prop,train_prop,seed=0)
Partition.SampleBalance(K=10,neg_index=0)
#%% Train a classifier with multiple machine learning algorithm
# L2-regularlized Logistic Regression
clfset = Mdl_Pipe('M0_L2Logit')
clfset.L2Logit()
M0_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M0_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M0_IterNum1000.xlsx')
# linear LDA without shrinkage
clfset = Mdl_Pipe('M1_LinearLDA')
clfset.linearLDA()
M1_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M1_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M1_IterNum1000.xlsx')
# Ridge Classifier
clfset = Mdl_Pipe('M2_RidgeClassifer')
clfset.Ridge()
M2_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M2_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M2_IterNum1000.xlsx')
# linear SVC
clfset = Mdl_Pipe('M3_LinearSVC')
clfset.linearSVC()
M3_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M3_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M3_IterNum1000.xlsx')
# perceptron
clfset = Mdl_Pipe('M4_Perceptron')
clfset.Perceptron()
M4_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M4_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M4_IterNum1000.xlsx')
# passive aggressive classifier
clfset = Mdl_Pipe('M5_PassiaveAggressiveClassifier')
clfset.PassiveAgg()
M5_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M5_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M5_IterNum1000.xlsx')
# Decision Tree Classifier
clfset = Mdl_Pipe('M6_DecisionTree')
clfset.DecisionTree()
M6_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M6_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M6_IterNum1000.xlsx')
# Gaussian Naive-Bayes Classifier
clfset = Mdl_Pipe('M7_Naive_Bayes')
clfset.NaiveBayes()
M7_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M7_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M7_IterNum1000.xlsx')
# KNN
clfset = Mdl_Pipe('M8_KNN')
clfset.KNeighborsClassifier()
M8_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M8_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M8_IterNum1000.xlsx')
# Gaussian SVC
clfset = Mdl_Pipe('M9_rbfSVC')
clfset.GaussianSVC()
M9_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M9_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M9_IterNum1000.xlsx')
# Polynomial SVC (Cubic Function)
clfset = Mdl_Pipe('M10_polySVC')
clfset.PolySVC()
M10_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M10_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M10_IterNum1000.xlsx')
# Sigmoid SVC
clfset = Mdl_Pipe('M11_sigmoidSVC')
clfset.SigmoidSVC()
M11_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M11_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M11_IterNum1000.xlsx')
# MLP
clfset = Mdl_Pipe('M12_MLP')
clfset.MLPClassifier()
M12_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M12_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M12_IterNum1000.xlsx')
# Ensemble Learning: Random Forest
clfset = Mdl_Pipe('M13_RandomForest')
clfset.RandomForest()
M13_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M13_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M13_IterNum1000.xlsx')
# Ensemble Learning: Gradient Boosting
clfset = Mdl_Pipe('M14_GradientBoost')
clfset.GradientBoosting()
M14_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M14_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M14_IterNum1000.xlsx')

#%% End of this script
myLogger.close()
sys.stdout = stdout_backup
=======
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 17 20:35:11 2023

@author: 35031
"""
#%% Initializing this script
# Import Basic Module
import os,sys
import numpy as np
import pandas as pd
# Change Working Directory
os.chdir(os.path.dirname(os.path.abspath(__file__)))
# Import User-defined functions
from subfunctions.s_DataPartition import Data_Partition
from subfunctions.s_ResultAssitant import Classifier_AutoRepot
from subfunctions.s_ModelPipeline  import Mdl_Pipe
#%% Load and Prepare Data
data = pd.read_csv('../Res_3_IntermediateData/16w_MLdata_prepared.csv')
dat = data[data.CIER_Flag==0]
dat = dat[["Gender_Girl","Grade","Stress_Sum","AcadBO_Sum","IAT_Sum","Anx_Sum",
     "SelfInjury_Sum","BeBully_Bin","Bully_Bin","SuiciIdea_Label"]]
# Create a folder to save the results of this script
if not os.path.exists('../Res_2_Results/ResML_CompareAlogrithm_Suicide'):
    os.mkdir('../Res_2_Results/ResML_CompareAlogrithm_Suicide')
# # Create Log File for this script
log_file_name = '../Res_1_Logs/Log_ML_2_CompareAlgorithem_Suicide.txt'
stdout_backup = sys.stdout
myLogger = open(log_file_name,'a')
sys.stdout = myLogger
# Subfunction
def TrainMdl_PipeWithPred(instance_MdlPipe,dfpt,feature_pool):
    print('=============================Start================================')
    print('||--Model Name:%s--||' %(instance_MdlPipe.name))
    Report = Classifier_AutoRepot(instance_MdlPipe.name)
    instance_MdlPipe.pipe.fit(Partition.train_X,Partition.train_Y);
    print('ACC=%.4f' %(instance_MdlPipe.pipe.score(dfpt.test_X,dfpt.test_Y)))
    # instance_MdlPipe.get_feature_rank(feature_pool,selector_index)
    Report.RunAll(instance_MdlPipe.pipe.predict(dfpt.test_X),dfpt.test_Y)
    Report.SaveResult(instance_MdlPipe.name)
    Report.ShowAllMetrics()
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
Partition = Data_Partition(dat,feature_pool,'SuiciIdea_Label')
Partition.Stratify(test_prop,train_prop,seed=0)
Partition.SampleBalance(K=10,neg_index=0)
#%% Train a classifier with multiple machine learning algorithm
# L2-regularlized Logistic Regression
clfset = Mdl_Pipe('M0_L2Logit')
clfset.L2Logit()
M0_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M0_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M0_IterNum1000.xlsx')
# linear LDA without shrinkage
clfset = Mdl_Pipe('M1_LinearLDA')
clfset.linearLDA()
M1_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M1_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M1_IterNum1000.xlsx')
# Ridge Classifier
clfset = Mdl_Pipe('M2_RidgeClassifer')
clfset.Ridge()
M2_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M2_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M2_IterNum1000.xlsx')
# linear SVC
clfset = Mdl_Pipe('M3_LinearSVC')
clfset.linearSVC()
M3_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M3_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M3_IterNum1000.xlsx')
# perceptron
clfset = Mdl_Pipe('M4_Perceptron')
clfset.Perceptron()
M4_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M4_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M4_IterNum1000.xlsx')
# passive aggressive classifier
clfset = Mdl_Pipe('M5_PassiaveAggressiveClassifier')
clfset.PassiveAgg()
M5_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M5_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M5_IterNum1000.xlsx')
# Decision Tree Classifier
clfset = Mdl_Pipe('M6_DecisionTree')
clfset.DecisionTree()
M6_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M6_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M6_IterNum1000.xlsx')
# Gaussian Naive-Bayes Classifier
clfset = Mdl_Pipe('M7_Naive_Bayes')
clfset.NaiveBayes()
M7_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M7_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M7_IterNum1000.xlsx')
# KNN
clfset = Mdl_Pipe('M8_KNN')
clfset.KNeighborsClassifier()
M8_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M8_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M8_IterNum1000.xlsx')
# Gaussian SVC
clfset = Mdl_Pipe('M9_rbfSVC')
clfset.GaussianSVC()
M9_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M9_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M9_IterNum1000.xlsx')
# Polynomial SVC (Cubic Function)
clfset = Mdl_Pipe('M10_polySVC')
clfset.PolySVC()
M10_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M10_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M10_IterNum1000.xlsx')
# Sigmoid SVC
clfset = Mdl_Pipe('M11_sigmoidSVC')
clfset.SigmoidSVC()
M11_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M11_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M11_IterNum1000.xlsx')
# MLP
clfset = Mdl_Pipe('M12_MLP')
clfset.MLPClassifier()
M12_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M12_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M12_IterNum1000.xlsx')
# Ensemble Learning: Random Forest
clfset = Mdl_Pipe('M13_RandomForest')
clfset.RandomForest()
M13_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M13_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M13_IterNum1000.xlsx')
# Ensemble Learning: Gradient Boosting
clfset = Mdl_Pipe('M14_GradientBoost')
clfset.GradientBoosting()
M14_IterResult = RerunModelPipeline(1000,clfset,Partition,feature_pool,test_prop,train_prop,K_matchedneg)
M14_IterResult.to_excel('../Res_2_Results/ResML_CompareAlogrithm_Suicide/ResML_M14_IterNum1000.xlsx')

#%% End of this script
myLogger.close()
sys.stdout = stdout_backup
>>>>>>> origin/main
