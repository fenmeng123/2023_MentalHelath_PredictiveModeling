# 2023\_MentalHealth\_PredictiveModel

This repository contains codes, analysis logs, and intermediate results for our manuscript titled "***Machine learning identifies different related factors associated with depression and suicidal ideation in Chinese children and adolescents***" (Pubmed ID: 38844165; DOI: [10.1016/j.jad.2024.06.006 ](https://doi.org/10.1016/j.jad.2024.06.006))

## Citation

This repository follows the GPL-3.0 license. If you would like to use any codes or scripts in this repository, please kindly cite our published article:

> Li, Q., Song, K., Feng, T., Zhang, J., & Fang, X. (2024). Machine learning identifies different related factors associated with depression and suicidal ideation in Chinese children and adolescents. *Journal of affective disorders*, S0165-0327(24)00916-9. Advance online publication. https\://doi.org/[10.1016/j.jad.2024.06.006](https://doi.org/10.1016/j.jad.2024.06.006)![](data:image/png;base64,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)

Regarding all files in this repository, their naming follows the standard underscore nomenclature. File names start with an abbreviation, concatenate a file number, and end with some text annotation describing the purpose or content of the file.

PNG format figures generated by these codes and all intermediate results in this study are **publicly available in the corresponding OSF (Open Science Framework) project**, DOI: 10.17605/OSF.IO/AH6DP.&#x20;

OSF Project Link: <https://osf.io/ah6dp/>

## Res\_1\_Logs

Auto-generated text files produced during code/script execution, generated by the R base function *sink*.

*Log\_16w\_QC.txt* contains the analysis log under the C/IER identification pipeline for internal sample.

*Log\_ML\_1\_\*.txt* \~ *Log\_ML\_8\_\*.txt* contains the analysis log under the machine learning pipeline.&#x20;

*   For internal validation, predictive models were trained and tested within the internal sample.

*   For external validation, predictive models were trained using internal sample and then applied on external sample.

\*Log\_OptimalLambda\_\*.txt \*contains the optimal L2-norm regularization parameter found by grid search methods in internal sample.

*Log\_RepVis\_7* and \*Log\_RepVis\_8 \*contains the results about statistical significance testing for comparisons of data balancing methods, which were conducted on the prediction performance for the final overall model (external validation). One sample t-test was used, where reference value is the inverse-proportion weighting model results.

*Log\_RepVis\_9* and \*Log\_RepVis\_10 \*contains the results about statistical significance testing for comparisons of subgroup-specific models, focusing on the prediction performance and feature importance. Two-sample t-test for biological sex, and one-way ANOVA for educational stage and geographic area. Post-hoc pairwise comparisons were conducted under the one-way ANOVA.&#x20;

Log\_Table\_1.txt and Log\_Table\_S1.txt contains the analysis log and chi-square testing results for Table 1 and Table S1 in our manuscript and supplemental materials.

## Res\_2\_Results

This directory contains intermediate results such as tables and figures generated during data analysis. Due to GitHub limitations, files larger than 100 MB cannot be uploaded. These large intermediate results are publicly available on other open-source websites, namely the Open Science Framework. These results mainly consist of Excel-like tables (.xlsx) and R data files (.rda) that store machine-learning predictive modeling results during model training in the internal sample.

In line with *Log\_RepVis\_7* and *Log\_RepVis\_8*, the \*Res\_IndexComp\_\*.doc \*files in folder \*Res\_ML\_OOSD\_Dep \*and *ResML\_OOSD\_Suicide* contains the tabularized summary for prediction performance comparisons among data balancing methods.

## Res\_3\_IntermediateData

This folder contains raw and preprocessed questionnaire data from our survey study. However, due to written consent agreements with participants and their parents, we cannot directly make these data open access. Researchers interested in accessing these data can send an email to the corresponding author (Dr. Xiaoyi Fang). The first two authors do not provide any assurance of data access.

## Res\_4\_Reports\_for\_Manuscript

Tables and figures used in our manuscript and supplemental materials. The folder structure was auto-created by *RepVis\_14\_TablesExtract.R* and *RepVis\_15\_FiguresExtract.R*. Here, we provide SVG-format high-quality vector images directly output by R. Some necessary post-processing was done manually in Adobe Illustrator 2023, Office 2021 PowerPoint, and Office 2021 Word. Thus, files in this folder may differ slightly from what we provided in our manuscript and supplemental materials.

## Step\_0\_Preprocess

R codes for questionnaire data preprocessing, mainly dependent on R packages *bruceR*, *careless*, *mice*, and *simputation*. See more details in our supplemental materials.

## Step\_1\_StatisticalAnalysis

R codes for reliability analysis, demographic variable comparisons, and other necessary statistical analyses.

## Step\_2\_PredictiveModel

Python codes and scripts for our machine learning-based predictive modeling. The folder **subfunctions** contains user-defined Python subfunctions to make these analyses more modular and create the standard machine learning pipeline.

## Step\_3\_AutoReportVisualization

R codes and scripts for visualization and results summary.

## Supp\_0\_Subfunctions

Some user-defined R functions to ensure smooth processes.

## Supp\_1\_NationwideEducationData

Raw data obtained from the Ministry of Education of the People's Republic of China - Education Statistics 2020. [Reference Link here](http://www.moe.gov.cn/jyb_sjzl/moe_560/2020/quanguo/)

## Supp\_2\_OrganizedNationwideEducationData

Manually reorganized nationwide data.

## Supp\_3\_Slides\_for\_Model\_Evaluation\_Indices

As indicated in supplemental materials, we have prepared two easy-to-read slides to illustrate the rationale of prediction performance evaluation indices used in this study. Anyone interested can find both English and Chinese version slides in this folder.
