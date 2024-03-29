# -*- coding: utf-8 -*-
"""
Sensitivity Analysis Step 5
    Training a Predictive Model stratified by Pre- or Post-COVID-19 Data
    Target: Suicidal Ideation
    
Created on Sat March 24 2024

@author: Kunru Song
"""
#%% Import Basic Modules
import os
import pandas as pd
import numpy as np
# Change Working Directory
os.chdir(os.path.dirname(os.path.abspath(__file__)))
# Import Machine Learning Modules
from subfunctions.s_OutofSampleValidation import Mdl_Pipe
#%% Script Parameter Settings
# Here we used an a priori Hyperparameter for L2-norm Regularization
Opt_L2 = 1 # 1 is quite liberal, further study should consider using the 
# two-step hyperparameter optimization procedure proposed by this study to 
# refine the final hyperparameter
Selected_Features = ["Anx_Sum",
                     "SelfInjury_Sum",
                     "Stress_Sum",
                     "IAT_Sum",
                     "AcadBO_Sum",
                     "Grade"]
Y_Name = ["SuiciIdea_Label"]
N_Repetitions = 1000
#%% Create a folder to save the results of this script
if not os.path.exists('../Res_2_Results/ResSensAna_PrePost_COVID19_Suicide'):
    os.mkdir('../Res_2_Results/ResSensAna_PrePost_COVID19_Suicide')

#%% Load and Prepare Data
RPSD = pd.read_csv('../Res_3_IntermediateData/16w_data_for_SensAna.csv')
RPSD = RPSD[RPSD.CIER_Flag==0]

OOSD = pd.read_csv('../Res_3_IntermediateData/181w_data_for_SensAna.csv')
OOSD = OOSD[OOSD.CIER_Flag==0]
#%% Pre-COVID19 Data
RPSD_PreCOVID = RPSD[RPSD.COVID19_Flag == 1]
OOSD_PreCOVID = OOSD[OOSD.COVID19_Flag == 1]
mdl = Mdl_Pipe('[PreCOVID19] L2Logit_Dep',Selected_Features, Y_Name)
mdl.MdlSpec(lambda_L2=Opt_L2,weights=None)
mdl.MdlFit(RPSD_PreCOVID,method='upsampling')
mdl.MdlPred(OOSD_PreCOVID)
mdl.MdlRepeat(N_Repetitions, OOSD_PreCOVID)
tmpOutputFileName = "Res_SensAna_PreCOVID19_Suicide.xlsx"
mdl.IterRes.to_excel("../Res_2_Results/ResSensAna_PrePost_COVID19_Suicide/" + \
                     tmpOutputFileName)
tmpOutputFileName = "Coef_SensAna_PreCOVID19_Suicide.xlsx"
mdl.MdlCoef.to_excel("../Res_2_Results/ResSensAna_PrePost_COVID19_Suicide/" + \
                     tmpOutputFileName)
#%% Post-COVID19 Data
RPSD_PostCOVID = RPSD[RPSD.COVID19_Flag == 0]
OOSD_PostCOVID = OOSD[OOSD.COVID19_Flag == 0]
mdl = Mdl_Pipe('[PostCOVID19] L2Logit_Dep',Selected_Features, Y_Name)
mdl.MdlSpec(lambda_L2=Opt_L2,weights=None)
mdl.MdlFit(RPSD_PostCOVID,method='upsampling')
mdl.MdlPred(OOSD_PostCOVID)
mdl.MdlRepeat(N_Repetitions, OOSD_PostCOVID)
tmpOutputFileName = "Res_SensAna_PostCOVID19_Suicide.xlsx"
mdl.IterRes.to_excel("../Res_2_Results/ResSensAna_PrePost_COVID19_Suicide/" + \
                     tmpOutputFileName)
tmpOutputFileName = "Coef_SensAna_PostCOVID19_Suicide.xlsx"
mdl.MdlCoef.to_excel("../Res_2_Results/ResSensAna_PrePost_COVID19_Suicide/" + \
                     tmpOutputFileName)