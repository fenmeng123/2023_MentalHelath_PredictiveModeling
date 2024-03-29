# -*- coding: utf-8 -*-
"""
Sensitivity Analysis Step 11
    Re-training a Predictive Model using new cut-off value for Suicidal Ideation
    
    Target: Suicidal Ideation
    
Created on Sat March 27 2024

@author: Kunru Song
"""
#%% Import Basic Modules
import os
import pandas as pd
# Change Working Directory
os.chdir(os.path.dirname(os.path.abspath(__file__)))
# Import Machine Learning Modules
from subfunctions.s_Score17_OutofSampleValidation import Mdl_Pipe
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
if not os.path.exists('../Res_2_Results/ResSensAna_Suicide_Score17'):
    os.mkdir('../Res_2_Results/ResSensAna_Suicide_Score17')

#%% Load and Prepare Data
RPSD = pd.read_csv('../Res_3_IntermediateData/16w_data_Suicide17.csv')
RPSD = RPSD[RPSD.CIER_Flag==0]

OOSD = pd.read_csv('../Res_3_IntermediateData/181w_data_Suicide17.csv')
OOSD = OOSD[OOSD.CIER_Flag==0]

mdl = Mdl_Pipe('[Score 17] L2Logit_Dep',Selected_Features, Y_Name)
mdl.MdlSpec(lambda_L2=Opt_L2,weights=None)
mdl.MdlFit(RPSD,method='upsampling')
mdl.MdlPred(OOSD)
mdl.MdlRepeat(N_Repetitions, OOSD)

tmpOutputFileName = "Res_SensAna_Suicide_Score17.xlsx"
mdl.IterRes.to_excel("../Res_2_Results/ResSensAna_Suicide_Score17/" + \
                     tmpOutputFileName)
tmpOutputFileName = "Coef_SensAna_Suicide_Score17.xlsx"
mdl.MdlCoef.to_excel("../Res_2_Results/ResSensAna_Suicide_Score17/" + \
                     tmpOutputFileName)
