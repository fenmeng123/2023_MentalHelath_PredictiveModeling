# -*- coding: utf-8 -*-
"""
Created on Wed Apr 26 15:53:26 2023

@author: Kunru Song
"""
import os
import pandas as pd
# import gc
# Change Working Directory
os.chdir(os.path.dirname(os.path.abspath(__file__)))
# Import Machine Learning Modules
from subfunctions.s_OutofSampleValidation import Mdl_Pipe
from subfunctions.s_ResultAssitant import Classifier_AutoRepot
#%% Script Parameter Settings
Opt_L2 = 0.175883
Selected_Features = ["Grade","Stress_Sum","AcadBO_Sum","IAT_Sum","Anx_Sum",
     "SelfInjury_Sum","BeBully_Bin"]
Y_Name = ["Depression_Label"]
#%% Import Self-defined modules by Kunru Song
# Create a folder to save the results of this script
if not os.path.exists('../Res_2_Results/ResML_Subgroup_Dep'):
    os.mkdir('../Res_2_Results/ResML_Subgroup_Dep')

def RunWeightedMdl_Subgroup(train_dat,test_dat,X_Name,Y_Name,Opt_L2,FileName):
    mdl = Mdl_Pipe('L2Logit_Dep',X_Name,Y_Name)
    InternalRep = Classifier_AutoRepot('Internal Validation: Sample Weighting')
    ExternalRep = Classifier_AutoRepot('External Validation: Sample Weighting')
    mdl.MdlSpec(lambda_L2=Opt_L2,weights=None)
    mdl.MdlFit(train_dat,method='weighting')
    mdl.MdlPred(test_dat)
    InternalRep.RunAll(mdl.internal_pred_y, mdl.internal_actual_y)
    InternalRep.SaveResult('Internal')
    InternalRep.ShowCompactMetrics()
    ExternalRep.RunAll(mdl.pred_y,mdl.actual_y)
    ExternalRep.SaveResult('External')
    ExternalRep.ShowCompactMetrics()
    Result = pd.concat([InternalRep.Res,ExternalRep.Res],ignore_index=True)
    Result.to_excel('../Res_2_Results/'+\
                    'ResML_Subgroup_Dep'+\
                    '/Res_weightedMdl'+FileName+'.xlsx')
    MdlCoef = pd.DataFrame(mdl.pipe['classifier'].coef_[0],\
                 index=mdl.pipe['classifier'].feature_names_in_)
    MdlCoef.to_excel('../Res_2_Results/'+\
                    'ResML_Subgroup_Dep'+\
                    '/Coef_weightedMdl'+FileName+'.xlsx')
    # for x in locals().keys():
    #     del locals()[x]
    # gc.collect()
def RunDownSampMdl_Subgroup(train_dat,test_dat,X_Name,Y_Name,Opt_L2,FileName):
    mdl = Mdl_Pipe('L2Logit_Dep',X_Name,Y_Name)
    mdl.MdlSpec(lambda_L2=Opt_L2,weights=None)
    mdl.MdlFit(train_dat,method='downsampling')
    mdl.MdlPred(test_dat)
    mdl.MdlRepeat(1000, test_dat)
    mdl.IterRes.to_excel('../Res_2_Results/'+\
                    'ResML_Subgroup_Dep'+\
                    '/Res_DownSampMdl'+FileName+'.xlsx')
    mdl.MdlCoef.to_excel('../Res_2_Results/'+\
                    'ResML_Subgroup_Dep'+\
                    '/Coef_DownSampMdl'+FileName+'.xlsx')
    # for x in locals().keys():
    #     del locals()[x]
    # gc.collect()
def RunUpSampMdl_Subgroup(train_dat,test_dat,X_Name,Y_Name,Opt_L2,FileName):
    mdl = Mdl_Pipe('L2Logit_Dep',X_Name,Y_Name)
    mdl.MdlSpec(lambda_L2=Opt_L2,weights=None)
    mdl.MdlFit(train_dat,method='upsampling')
    mdl.MdlPred(test_dat)
    mdl.MdlRepeat(1000, test_dat)
    mdl.IterRes.to_excel('../Res_2_Results/'+\
                    'ResML_Subgroup_Dep'+\
                    '/Res_UpSampMdl'+FileName+'.xlsx')
    mdl.MdlCoef.to_excel('../Res_2_Results/'+\
                    'ResML_Subgroup_Dep'+\
                    '/Coef_UpSampMdl'+FileName+'.xlsx')
    # for x in locals().keys():
    #     del locals()[x]
    # gc.collect()
#%% Load and Prepare Data
RPSD = pd.read_csv('../Res_3_IntermediateData/16w_MLdata_prepared_SubG.csv')
RPSD = RPSD[RPSD.CIER_Flag==0]
# RPSD = RPSD[Selected_Features+Y_Name]

OOSD = pd.read_csv('../Res_3_IntermediateData/181w_MLdata_prepared_SubG.csv')
OOSD = OOSD[OOSD.CIER_Flag==0]
# OOSD = OOSD[Selected_Features+Y_Name]
# #%% Modelling: Stratified by Biological Sex
# # Girl Model:
# train_dat = RPSD[RPSD.Gender_Girl==1]
# test_dat = OOSD[OOSD.Gender_Girl==1]
# RunWeightedMdl_Subgroup(train_dat,test_dat,\
#                         Selected_Features,Y_Name,\
#                         Opt_L2,\
#                         'Girl')
# RunDownSampMdl_Subgroup(train_dat,test_dat,\
#                         Selected_Features,Y_Name,\
#                         Opt_L2,\
#                         'Girl')
# RunUpSampMdl_Subgroup(train_dat,test_dat,\
#                         Selected_Features,Y_Name,\
#                         Opt_L2,\
#                         'Girl')
# # Boy Model:
# train_dat = RPSD[RPSD.Gender_Boy==1]
# test_dat = OOSD[OOSD.Gender_Boy==1]
# RunWeightedMdl_Subgroup(train_dat,test_dat,\
#                         Selected_Features,Y_Name,\
#                         Opt_L2,\
#                         'Boy')
# RunDownSampMdl_Subgroup(train_dat,test_dat,\
#                         Selected_Features,Y_Name,\
#                         Opt_L2,\
#                         'Boy')
# RunUpSampMdl_Subgroup(train_dat,test_dat,\
#                         Selected_Features,Y_Name,\
#                         Opt_L2,\
#                         'Boy')
#%% Modelling: Stratified by the Phase of Studying
# Primary Education School Model:
train_dat = RPSD[RPSD.StudyPhase=="Primary Education"]
test_dat = OOSD[OOSD.StudyPhase=="Primary Education"]
RunWeightedMdl_Subgroup(train_dat,test_dat,\
                        Selected_Features,Y_Name,\
                        Opt_L2,\
                        'PrimarySchool')
RunDownSampMdl_Subgroup(train_dat,test_dat,\
                        Selected_Features,Y_Name,\
                        Opt_L2,\
                        'PrimarySchool')
RunUpSampMdl_Subgroup(train_dat,test_dat,\
                        Selected_Features,Y_Name,\
                        Opt_L2,\
                        'PrimarySchool')
# Junior Education School Model:
train_dat = RPSD[RPSD.StudyPhase=="Junior Secondary Education"]
test_dat = OOSD[OOSD.StudyPhase=="Junior Secondary Education"]
RunWeightedMdl_Subgroup(train_dat,test_dat,\
                        Selected_Features,Y_Name,\
                        Opt_L2,\
                        'JuniorSchool')
RunDownSampMdl_Subgroup(train_dat,test_dat,\
                        Selected_Features,Y_Name,\
                        Opt_L2,\
                        'JuniorSchool')
RunUpSampMdl_Subgroup(train_dat,test_dat,\
                        Selected_Features,Y_Name,\
                        Opt_L2,\
                        'JuniorSchool')
# Senior Education School Model:
train_dat = RPSD[RPSD.StudyPhase=="Senior Secondary Education"]
test_dat = OOSD[OOSD.StudyPhase=="Senior Secondary Education"]
RunWeightedMdl_Subgroup(train_dat,test_dat,\
                        Selected_Features,Y_Name,\
                        Opt_L2,\
                        'SeniorSchool')
RunDownSampMdl_Subgroup(train_dat,test_dat,\
                        Selected_Features,Y_Name,\
                        Opt_L2,\
                        'SeniorSchool')
RunUpSampMdl_Subgroup(train_dat,test_dat,\
                        Selected_Features,Y_Name,\
                        Opt_L2,\
                        'SeniorSchool')
#%% Modelling: Stratified by Geographic Area
train_dat = RPSD[RPSD.Region_4L=="Eastern Region"]
test_dat = OOSD[OOSD.Region_4L=="Eastern Region"]
RunWeightedMdl_Subgroup(train_dat,test_dat,\
                        Selected_Features,Y_Name,\
                        Opt_L2,\
                        'Eastern')
RunDownSampMdl_Subgroup(train_dat,test_dat,\
                        Selected_Features,Y_Name,\
                        Opt_L2,\
                        'Eastern')
RunUpSampMdl_Subgroup(train_dat,test_dat,\
                        Selected_Features,Y_Name,\
                        Opt_L2,\
                        'Eastern')
train_dat = RPSD[RPSD.Region_4L=="Central Region"]
test_dat = OOSD[OOSD.Region_4L=="Central Region"]
RunWeightedMdl_Subgroup(train_dat,test_dat,\
                        Selected_Features,Y_Name,\
                        Opt_L2,\
                        'Central')
RunDownSampMdl_Subgroup(train_dat,test_dat,\
                        Selected_Features,Y_Name,\
                        Opt_L2,\
                        'Central')
RunUpSampMdl_Subgroup(train_dat,test_dat,\
                        Selected_Features,Y_Name,\
                        Opt_L2,\
                        'Central')
train_dat = RPSD[RPSD.Region_4L=="Western Region"]
test_dat = OOSD[OOSD.Region_4L=="Western Region"]
RunWeightedMdl_Subgroup(train_dat,test_dat,\
                        Selected_Features,Y_Name,\
                        Opt_L2,\
                        'Western')
RunDownSampMdl_Subgroup(train_dat,test_dat,\
                        Selected_Features,Y_Name,\
                        Opt_L2,\
                        'Western')
RunUpSampMdl_Subgroup(train_dat,test_dat,\
                        Selected_Features,Y_Name,\
                        Opt_L2,\
                        'Western')
train_dat = RPSD[RPSD.Region_4L=="Northeast Region"]
test_dat = OOSD[OOSD.Region_4L=="Northeast Region"]
RunWeightedMdl_Subgroup(train_dat,test_dat,\
                        Selected_Features,Y_Name,\
                        Opt_L2,\
                        'Northeast')
RunDownSampMdl_Subgroup(train_dat,test_dat,\
                        Selected_Features,Y_Name,\
                        Opt_L2,\
                        'Northeast')
RunUpSampMdl_Subgroup(train_dat,test_dat,\
                        Selected_Features,Y_Name,\
                        Opt_L2,\
                        'Northeast')
