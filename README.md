# 2023_MentalHealth_PredictiveModel

This repository contains codes, analysis logs, and intermediate results for our manuscript titled "Machine Learning Unveils Disparate Psychopathological Determinants of Depression and Suicidal Ideation in Chinese Adolescents."

This repository follows the GPL-3.0 license. For all files in this repository, their naming follows the standard underscore nomenclature. File names start with an abbreviation, concatenate a file number, and end with some text annotation describing the purpose or content of the file.

PNG format figures generated by these codes and all intermediate results in this study are **publicly available the corresponding OSF (Open Science Framework) project**, DOI: 10.17605/OSF.IO/AH6DP.&#x20;

OSF Project Link: <https://osf.io/ah6dp/>

## Res_1_Logs

Auto-generated text files produced during code/script execution, generated by the R base function _sink_.

_Log_16w_QC.txt_ contains the analysis log under the C/IER identification pipeline for internal sample.

_Log_ML_1\_\*.txt_ \~ _Log_ML_8\_\*.txt_ contains the analysis log under the machine learning pipeline.&#x20;

- For internal validation, predictive models were trained and tested within the internal sample.

- For external validation, predictive models were trained using internal sample and then applied on external sample.

*Log_OptimalLambda\_\*.txt *contains the optimal L2-norm regularization parameter found by grid search methods in internal sample.

_Log_RepVis_7_ and *Log_RepVis_8 *contains the results about statistical significance testing for comparisons of data balancing methods, which were conducted on the prediction performance for the final overall model (external validation). One sample t-test was used, where reference value is the inverse-proportion weighting model results.

_Log_RepVis_9_ and *Log_RepVis_10 *contains the results about statistical significance testing for comparisons of subgroup-specific models, focusing on the prediction performance and feature importance. Two-sample t-test for biological sex, and one-way ANOVA for educational stage and geographic area. Post-hoc pairwise comparisons were conducted under the one-way ANOVA.&#x20;

Log_Table_1.txt and Log_Table_S1.txt contains the analysis log and chi-square testing results for Table 1 and Table S1 in our manuscript and supplemental materials.

## Res_2_Results

This directory contains intermediate results such as tables and figures generated during data analysis. Due to GitHub limitations, files larger than 100 MB cannot be uploaded. These large intermediate results are publicly available on other open-source websites, namely the Open Science Framework. These results mainly consist of Excel-like tables (.xlsx) and R data files (.rda) that store machine-learning predictive modeling results during model training in the internal sample.

In line with _Log_RepVis_7_ and _Log_RepVis_8_, the *Res_IndexComp\_\*.doc *files in folder *Res_ML_OOSD_Dep *and _ResML_OOSD_Suicide_ contains the tabularized summary for prediction performance comparisons among data balancing methods.

## Res_3_IntermediateData

This folder contains raw and preprocessed questionnaire data from our survey study. However, due to written consent agreements with participants and their parents, we cannot directly make these data open access. Researchers interested in accessing these data can send an email to the corresponding author (Dr. Xiaoyi Fang). The first two authors do not provide any assurance of data access.

## Res_4_Reports_for_Manuscript

Tables and figures used in our manuscript and supplemental materials. The folder structure was auto-created by _RepVis_14_TablesExtract.R_ and _RepVis_15_FiguresExtract.R_. Here, we provide SVG-format high-quality vector images directly output by R. Some necessary post-processing was done manually in Adobe Illustrator 2023, Office 2021 PowerPoint, and Office 2021 Word. Thus, files in this folder may differ slightly from what we provided in our manuscript and supplemental materials.

## Step_0_Preprocess

R codes for questionnaire data preprocessing, mainly dependent on R packages _bruceR_, _careless_, _mice_, and _simputation_. See more details in our supplemental materials.

## Step_1_StatisticalAnalysis

R codes for reliability analysis, demographic variable comparisons, and other necessary statistical analyses.

## Step_2_PredictiveModel

Python codes and scripts for our machine learning-based predictive modeling. The folder **subfunctions** contains user-defined Python subfunctions to make these analyses more modular and create the standard machine learning pipeline.

## Step_3_AutoReportVisualization

R codes and scripts for visualization and results summary.

## Supp_0_Subfunctions

Some user-defined R functions to ensure smooth processes.

## Supp_1_NationwideEducationData

Raw data obtained from the Ministry of Education of the People's Republic of China - Education Statistics 2020. [Reference Link here](http://www.moe.gov.cn/jyb_sjzl/moe_560/2020/quanguo/)

## Supp_2_OrganizedNationwideEducationData

Manually reorganized nationwide data.

## Supp_3_Slides_for_Model_Evaluation_Indices

As indicated in supplemental materials, we have prepared two easy-to-read slides to illustrate the rationale of prediction performance evaluation indices used in this study. Anyone interested can find both English and Chinese version slides in this folder.
