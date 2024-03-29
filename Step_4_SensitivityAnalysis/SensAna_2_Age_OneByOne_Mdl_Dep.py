# -*- coding: utf-8 -*-
"""
Sensitivity Analysis Step 2
    Training a Predictive Model stratified by invidividuals' age
    Resoulution: One years old
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
                     "BeBully_Bin"]
Y_Name = ["Depression_Label"]
N_Repetitions = 1000
#%% Create a folder to save the results of this script
if not os.path.exists('../Res_2_Results/ResSensAna_AgeStratified_Dep'):
    os.mkdir('../Res_2_Results/ResSensAna_AgeStratified_Dep')

#%% Load and Prepare Data
RPSD = pd.read_csv('../Res_3_IntermediateData/16w_data_for_SensAna.csv')
RPSD = RPSD[RPSD.CIER_Flag==0]
Age_Label_in_RPSD = np.sort(RPSD.Grade.unique())

OOSD = pd.read_csv('../Res_3_IntermediateData/181w_data_for_SensAna.csv')
OOSD = OOSD[OOSD.CIER_Flag==0]
Age_Label_in_OOSD = np.sort(OOSD.Grade.unique())
if sum(Age_Label_in_RPSD == Age_Label_in_OOSD) == len(Age_Label_in_RPSD):
    print("Age label is consistent between RPSD and OOSD.\n")
else:
    raise ValueError("Age label error! Please ensure Age is equal between RPSD and OOSD!")
#%% Iteratively training and testing predictive model

for i, age in np.ndenumerate(Age_Label_in_RPSD):
    print("|Iter #%d| Age: [%d ~ %d] Educational Grade: #%d\n"
          %(i[0]+1,age*8+9,age*8+10,age*8+4))
    AgeLabel = "Age_%d_%d" %(age*8+9,age*8+10)
    EduLabel = "Grade_%d" %(age*8+4)
    mdl = Mdl_Pipe('[Depression] L2Logit_Dep',Selected_Features,Y_Name)
    mdl.MdlSpec(lambda_L2=Opt_L2,weights=None)
    train_RPSD = RPSD[RPSD.Grade == age]
    train_RPSD = train_RPSD[Selected_Features+Y_Name]
    test_OOSD = OOSD[OOSD.Grade == age]
    test_OOSD = test_OOSD[Selected_Features+Y_Name]
    mdl.MdlFit(train_RPSD,method='downsampling')
    mdl.MdlPred(test_OOSD)
    mdl.MdlRepeat(N_Repetitions, OOSD)
    tmpOutputFileName = "Res_SensAna_Dep_" + AgeLabel + "_" + EduLabel + ".xlsx"
    mdl.IterRes.to_excel("../Res_2_Results/ResSensAna_AgeStratified_Dep/" + \
                         tmpOutputFileName)
    tmpOutputFileName = "Coef_SensAna_Dep_" + AgeLabel + "_" + EduLabel + ".xlsx"
    mdl.MdlCoef.to_excel("../Res_2_Results/ResSensAna_AgeStratified_Dep/" + \
                         tmpOutputFileName)

#%% End of this script
