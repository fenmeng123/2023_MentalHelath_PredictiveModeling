# -*- coding: utf-8 -*-
"""
Created on Sat Mar  5 00:43:27 2022

@author: 35031
"""
import sklearn
import pandas as pd

class Classifier_AutoRepot:
    def __init__(self,name):
        self.name=name
    def RunAll(self,pred_label,true_label):
        self.textreport = sklearn.metrics.classification_report(true_label,pred_label)
        self.acc = sklearn.metrics.accuracy_score(true_label,pred_label)
        self.precision = sklearn.metrics.precision_score(true_label,pred_label)
        self.ppv = self.precision
        self.recall = sklearn.metrics.recall_score(true_label,pred_label)
        self.f1 = sklearn.metrics.f1_score(true_label,pred_label)
        self.balancedacc = sklearn.metrics.balanced_accuracy_score(true_label,pred_label)
        
        self.GenConfMat(pred_label,true_label)
#        self.ShowAllMetrics()
        
    def GenConfMat(self,pred_label,true_label):
        self.ConfMat = sklearn.metrics.confusion_matrix(true_label, pred_label)
        # self.ConfMatDisplay = sklearn.metrics.ConfusionMatrixDisplay(self.ConfMat)
        self.tn, self.fp, self.fn, self.tp = self.ConfMat.ravel()
        self.specificity = self.tn / (self.tn + self.fp)
        self.prevalence = (self.tp + self.fn) / (self.tn + self.fp + self.fn + self.tp)
        self.npv = self.tn / (self.fn + self.tn)
        self.fpr = self.fp / (self.fp + self.tn)
        self.fomr = self.fn / (self.fn + self.tn)
        self.fdr = self.fp / (self.tp + self.fp)
    def ShowCompactMetrics(self):
        print("------------Model Results---------")
        print("ACC=%.4f" %(self.acc))
        print("Recall(Sensitivity)=%.4f" %(self.recall))
        print("Specificity=%.4f" %(self.specificity))
        print("Balanced ACC=%.4f" %(self.balancedacc))
        print("--------------------------------\n")
    def ShowAllMetrics(self):
        print("------------Model Results---------")
        print(self.textreport)
        print("--------------------------------\n")
        print("ACC=%.4f" %(self.acc))
        print("Recall(Sensitivity)=%.4f" %(self.recall))
        print("Specificity=%.4f" %(self.specificity))
        print("Precision(PPV)=%.4f" %(self.precision))
        print("F1-score=%.4f" %(self.f1))
        print("Balanced ACC=%.4f" %(self.balancedacc))
        print("--------------------------------\n")
        # self.ConfMatDisplay.plot()
    def SaveResult(self,new_index_str):
        if hasattr(self,"Res"):
            self.Res = self.Res.append(self.GenResDF(new_index_str),ignore_index = True)
        else:
            self.Res = self.GenResDF(new_index_str)
    def GenResDF(self,new_index_str):
        return(pd.DataFrame({'name':new_index_str,
                             'ACC':self.acc,
                             'Sensitivity':self.recall,
                             'Specificity':self.specificity,
                             'balacc':self.balancedacc,
                             'F1_score':self.f1,
                             'PPV':self.ppv,
                             'NPV':self.npv},index=[0]))
#    def GenCoefDF(self,coef,featurenames):
#        
    def fromMdl(self,mdl,dfpt,mdl_no_str):
        # dfpt is the data partition object defined by KR.S
        self.RunAll(mdl.pred_Y,dfpt.test_Y)
        self.ShowAllMetrics()
        self.SaveResult(mdl_no_str + ' Test Performance')
        pred_train_Y =  mdl.predict(dfpt.train_X)
        self.RunAll(pred_train_Y,dfpt.train_Y)
        self.SaveResult(mdl_no_str + ' Train Performance')