# -*- coding: utf-8 -*-
"""
Created on Sat Apr 22 23:45:44 2023

@author: Kunru Song
"""
#%% Import Basic Modules
import os
import pandas as pd
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
mdl = Mdl_Pipe('L2Logit_Dep',Selected_Features,Y_Name)
#%% Import Self-defined modules by Kunru Song
# Create a folder to save the results of this script
# Create a folder to save the results of this script
if not os.path.exists('../Res_2_Results/ResML_OOSD_Dep'):
    os.mkdir('../Res_2_Results/ResML_OOSD_Dep')

#%% Load and Prepare Data
RPSD = pd.read_csv('../Res_3_IntermediateData/16w_MLdata_prepared.csv')
RPSD = RPSD[RPSD.CIER_Flag==0]
RPSD = RPSD[Selected_Features+Y_Name]

OOSD = pd.read_csv('../Res_3_IntermediateData/181w_MLdata_prepared.csv')
OOSD = OOSD[OOSD.CIER_Flag==0]
OOSD = OOSD[Selected_Features+Y_Name]
#%% Modelling: weighting cases with balanced method
InternalRep = Classifier_AutoRepot('Internal Validation: Sample Weighting')
ExternalRep = Classifier_AutoRepot('External Validation: Sample Weighting')

mdl.MdlSpec(lambda_L2=Opt_L2,weights=None)
mdl.MdlFit(RPSD,method='weighting')
mdl.MdlPred(OOSD)

InternalRep.RunAll(mdl.internal_pred_y, mdl.internal_actual_y)
InternalRep.SaveResult('Internal')
InternalRep.ShowCompactMetrics()

ExternalRep.RunAll(mdl.pred_y,mdl.actual_y)
ExternalRep.SaveResult('External')
ExternalRep.ShowCompactMetrics()

Result = pd.concat([InternalRep.Res,ExternalRep.Res],ignore_index=True)
Result.to_excel('../Res_2_Results/ResML_OOSD_Dep/Res_OOSD_weighted_Dep.xlsx')
#%% Modelling: downsampling
mdl = Mdl_Pipe('L2Logit_Dep',Selected_Features,Y_Name)
mdl.MdlSpec(lambda_L2=Opt_L2,weights=None)
mdl.MdlFit(RPSD,method='downsampling')
mdl.MdlPred(OOSD)
mdl.MdlRepeat(1000, OOSD)
mdl.IterRes.to_excel('../Res_2_Results/ResML_OOSD_Dep/Res_OOSD_Down1000_Dep.xlsx')
# mdl.y_proba.to_csv('../Res_2_Results/ResML_OOSD_Dep/PredYProba_OOSD_Down1000_Dep.csv')
mdl.MdlCoef.to_excel('../Res_2_Results/ResML_OOSD_Dep/Coef_OOSD_Down1000_Dep.xlsx')
#%% Modelling: upsampling
mdl = Mdl_Pipe('L2Logit_Dep',Selected_Features,Y_Name)
mdl.MdlSpec(lambda_L2=Opt_L2,weights=None)
mdl.MdlFit(RPSD,method='upsampling')
mdl.MdlPred(OOSD)
mdl.MdlRepeat(1000, OOSD)
mdl.IterRes.to_excel('../Res_2_Results/ResML_OOSD_Dep/Res_OOSD_Up1000_Dep.xlsx')
# mdl.y_proba.to_csv('../Res_2_Results/ResML_OOSD_Dep/PredYProba_OOSD_Up1000_Dep.csv')
mdl.MdlCoef.to_excel('../Res_2_Results/ResML_OOSD_Dep/Coef_OOSD_Up1000_Dep.xlsx')
#%% End of this script
# myLogger.close()
# sys.stdout = stdout_backup