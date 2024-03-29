# -*- coding: utf-8 -*-
"""
Sensitivity Analysis Step 4
    Training a Predictive Model stratified by Pre- or Post-COVID-19 Data
    Target: Depression
    
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
                     "Stress_Sum",
                     "AcadBO_Sum",
                     "IAT_Sum",
                     "SelfInjury_Sum",
                     "BeBully_Bin",
                     "Grade"]
Y_Name = ["Depression_Label"]
N_Repetitions = 1000
#%% Create a folder to save the results of this script
if not os.path.exists('../Res_2_Results/ResSensAna_PrePost_COVID19_Dep'):
    os.mkdir('../Res_2_Results/ResSensAna_PrePost_COVID19_Dep')

#%% Load and Prepare Data
RPSD = pd.read_csv('../Res_3_IntermediateData/16w_data_for_SensAna.csv')
RPSD = RPSD[RPSD.CIER_Flag==0]

OOSD = pd.read_csv('../Res_3_IntermediateData/181w_data_for_SensAna.csv')
OOSD = OOSD[OOSD.CIER_Flag==0]
#%% Pre-COVID19 Data
RPSD_PreCOVID = RPSD[RPSD.COVID19_Flag == 1]
RPSD_PreCOVID = RPSD_PreCOVID[Selected_Features+Y_Name]
OOSD_PreCOVID = OOSD[OOSD.COVID19_Flag == 1]
OOSD_PreCOVID = OOSD_PreCOVID[Selected_Features+Y_Name]

mdl = Mdl_Pipe('[PreCOVID19] L2Logit_Dep',Selected_Features,Y_Name)
mdl.MdlSpec(lambda_L2=Opt_L2,weights=None)
mdl.MdlFit(RPSD_PreCOVID,method='downsampling')
mdl.MdlPred(OOSD_PreCOVID)
mdl.MdlRepeat(N_Repetitions, OOSD_PreCOVID)
tmpOutputFileName = "Res_SensAna_PreCOVID19_Dep.xlsx"
mdl.IterRes.to_excel("../Res_2_Results/ResSensAna_PrePost_COVID19_Dep/" + \
                     tmpOutputFileName)
tmpOutputFileName = "Coef_SensAna_PreCOVID19_Dep.xlsx"
mdl.MdlCoef.to_excel("../Res_2_Results/ResSensAna_PrePost_COVID19_Dep/" + \
                     tmpOutputFileName)
#%% Post-COVID19 Data
RPSD_PostCOVID = RPSD[RPSD.COVID19_Flag == 0]
RPSD_PreCOVID = RPSD_PreCOVID[Selected_Features+Y_Name]
OOSD_PostCOVID = OOSD[OOSD.COVID19_Flag == 0]
mdl = Mdl_Pipe('[PostCOVID19] L2Logit_Dep',Selected_Features,Y_Name)
mdl.MdlSpec(lambda_L2=Opt_L2,weights=None)
mdl.MdlFit(RPSD_PostCOVID,method='downsampling')
mdl.MdlPred(OOSD_PostCOVID)
mdl.MdlRepeat(N_Repetitions, OOSD_PostCOVID)
tmpOutputFileName = "Res_SensAna_PostCOVID19_Dep.xlsx"
mdl.IterRes.to_excel("../Res_2_Results/ResSensAna_PrePost_COVID19_Dep/" + \
                     tmpOutputFileName)
tmpOutputFileName = "Coef_SensAna_PostCOVID19_Dep.xlsx"
mdl.MdlCoef.to_excel("../Res_2_Results/ResSensAna_PrePost_COVID19_Dep/" + \
                     tmpOutputFileName)



