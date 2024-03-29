# -*- coding: utf-8 -*-
"""
Python Script for Machine-learning Predictive Modeling Pipeline

Created on Sat Jun  4 12:49:22 2022

@author: Kunru Song
"""
import numpy as np
import pandas as pd

import sklearn
import sklearn.pipeline
import sklearn.feature_selection

from sklearn.linear_model import LogisticRegression
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.linear_model import RidgeClassifier
from sklearn.svm import LinearSVC
from sklearn.linear_model import Perceptron
from sklearn.linear_model import PassiveAggressiveClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.gaussian_process import GaussianProcessClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.neural_network import MLPClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.ensemble import ExtraTreesClassifier
from sklearn.svm import SVC
#%% machine learning model
class Mdl_Pipe:
#        train a classifer by Pipeline module in sklearn
    def __init__(self,MdlName=''):
        self.name = MdlName
    def anovaPercFilt_L2Logit(self,threshold,lambda_L2=1):
        self.pipe = sklearn.pipeline.Pipeline([
                # ('z_scaling', sklearn.preprocessing.StandardScaler()),
                ('feature_selection',
                 sklearn.feature_selection.SelectPercentile(
                        sklearn.feature_selection.f_classif,
                        threshold)),
                ('classifier', LogisticRegression(max_iter=int(10000),
                                             random_state=0,
                                             C=lambda_L2) )
                ])
    def RFECV_L2Logit(self,innerCV=10,lambda_L2=1):
        self.pipe = sklearn.pipeline.Pipeline([
                # ('z_scaling',sklearn.preprocessing.StandardScaler()),
                ('feature_selection',
                 sklearn.feature_selection.RFECV(estimator=LogisticRegression(max_iter=500,
                                                                            random_state=0,
                                                                            C=lambda_L2),
                    step = 1,
                    min_features_to_select = 1,
                    cv = innerCV,
                    verbose = 0,
                     )),
                ('classifier',LogisticRegression(max_iter=int(10000),
                                            random_state=0,
                                            C=lambda_L2))
                ])
    def L2Logit(self,lambda_L2=1):
        self.pipe = sklearn.pipeline.Pipeline([
                ('classifier',LogisticRegression(max_iter=int(10000),
                                            random_state=0,
                                            C=lambda_L2))
                ])
    def RFECV_linearLDA(self,innerCV=10,shrinkageSet=None):
        self.pipe = sklearn.pipeline.Pipeline([
            # ('z_scaling',sklearn.preprocessing.StandardScaler()),
            ('feature_selection',
             sklearn.feature_selection.RFECV(
                estimator=LinearDiscriminantAnalysis(shrinkage=shrinkageSet),
                step = 1,
                min_features_to_select = 1,
                cv = innerCV,
                verbose = 0)),
            ('classifier',LinearDiscriminantAnalysis(solver='lsqr',
                                                     shrinkage=shrinkageSet))])
    def linearLDA(self,shrinkageSet=None):
        self.pipe = sklearn.pipeline.Pipeline([
            ('classifier',LinearDiscriminantAnalysis(solver='lsqr',
                                                     shrinkage=shrinkageSet))])
    def RFECV_Ridge(self,innerCV=10):
        self.pipe = sklearn.pipeline.Pipeline([
            # ('z_scaling',sklearn.preprocessing.StandardScaler()),
            ('feature_selection',sklearn.feature_selection.RFECV(
                estimator=RidgeClassifier(),
                 step = 1,
                 min_features_to_select = 1,
                 cv = innerCV,
                 verbose = 0)),
            ('classifier',RidgeClassifier(max_iter = int(10000) ))])
    def Ridge(self):
        self.pipe = sklearn.pipeline.Pipeline([
            ('classifier',RidgeClassifier(max_iter=int(10000) ))])
    def RFECV_linearSVC(self,innerCV=10):
        self.pipe = sklearn.pipeline.Pipeline([
            # ('z_scaling',sklearn.preprocessing.StandardScaler()),
            ('feature_selection',sklearn.feature_selection.RFECV(
                estimator=LinearSVC(max_iter=int(10000)),
                 step = 1,
                 min_features_to_select = 1,
                 cv = innerCV,
                 verbose = 0)),
            ('classifier',LinearSVC(max_iter=int(10000)) )])
    def linearSVC(self):
        self.pipe = sklearn.pipeline.Pipeline([
            ('classifier',LinearSVC(max_iter=int(10000)) )])   
    def GaussianSVC(self):
        self.pipe = sklearn.pipeline.Pipeline([
            ('classifier',SVC(kernel = 'rbf',max_iter=int(10000) ))])
    def PolySVC(self):
        self.pipe = sklearn.pipeline.Pipeline([
            ('classifier',SVC(kernel = 'poly',degree = 3,max_iter=int(10000) ))])           
    def SigmoidSVC(self):
        self.pipe = sklearn.pipeline.Pipeline([
            ('classifier',SVC(kernel = 'sigmoid',max_iter=int(10000) ))])     
    def RFECV_Perceptron(self,innerCV=10):
        self.pipe = sklearn.pipeline.Pipeline([
            # ('z_scaling',sklearn.preprocessing.StandardScaler()),
            ('feature_selection',sklearn.feature_selection.RFECV(
                estimator=Perceptron(max_iter=int(10000)),
                 step = 1,
                 min_features_to_select = 1,
                 cv = innerCV,
                 verbose = 0)),
            ('classifier',Perceptron(max_iter=int(10000)) )])
    def Perceptron(self):
        self.pipe = sklearn.pipeline.Pipeline([
            ('classifier',Perceptron(max_iter=int(10000)) )])
    def RFECV_PassiveAgg(self,innerCV=10):
        self.pipe = sklearn.pipeline.Pipeline([
            # ('z_scaling',sklearn.preprocessing.StandardScaler()),
            ('feature_selection',sklearn.feature_selection.RFECV(
                estimator=PassiveAggressiveClassifier(max_iter=int(10000)),
                 step = 1,
                 min_features_to_select = 1,
                 cv = innerCV,
                 verbose = 0)),
            ('classifier',PassiveAggressiveClassifier(max_iter=int(10000)))])
    def PassiveAgg(self):
        self.pipe = sklearn.pipeline.Pipeline([
            ('classifier',PassiveAggressiveClassifier(max_iter=int(10000)))])
    def RFECV_DecisionTree(self,innerCV=10):
        self.pipe = sklearn.pipeline.Pipeline([
            # ('z_scaling',sklearn.preprocessing.StandardScaler()),
            ('feature_selection',sklearn.feature_selection.RFECV(
                estimator=DecisionTreeClassifier(),
                 step = 1,
                 min_features_to_select = 1,
                 cv = innerCV,
                 verbose = 0)),
            ('classifier',DecisionTreeClassifier())])
    def DecisionTree(self):
        self.pipe = sklearn.pipeline.Pipeline([
            ('classifier',DecisionTreeClassifier())])        
    def NaiveBayes(self):
        self.pipe = sklearn.pipeline.Pipeline([
            # ('z_scaling',sklearn.preprocessing.StandardScaler()),
            ('classifier',GaussianNB())])
    def GaussianProcessClassifier(self):
        self.pipe = sklearn.pipeline.Pipeline([
            # ('z_scaling',sklearn.preprocessing.StandardScaler()),
            ('classifier',GaussianProcessClassifier())])
    def KNeighborsClassifier(self):
        self.pipe = sklearn.pipeline.Pipeline([
            # ('z_scaling',sklearn.preprocessing.StandardScaler()),
            ('classifier',KNeighborsClassifier())])
    def MLPClassifier(self):
        self.pipe = sklearn.pipeline.Pipeline([
            # ('z_scaling',sklearn.preprocessing.StandardScaler()),
            ('classifier',MLPClassifier(max_iter=int(10000) ) )])
    def RandomForest(self):
        self.pipe = sklearn.pipeline.Pipeline([
            ('classifier',RandomForestClassifier() )])
    def GradientBoosting(self):
        self.pipe = sklearn.pipeline.Pipeline([
            ('classifier',GradientBoostingClassifier() )])
    def ExtraTrees(self):
        self.pipe = sklearn.pipeline.Pipeline([
            ('classifier',ExtraTreesClassifier() )])
    def get_feature_rank(self,feature_pool,selector_index):
            print('Selected features:')
            print(np.asarray(feature_pool)[self.pipe[selector_index].support_])
            self.feature_rank = pd.DataFrame( dict(zip(feature_pool,
                                                       self.pipe[selector_index].ranking_)),
                                             index=['value'] )
            print('feature rank:')
            print(self.feature_rank.T['value'].sort_values())
            
    def get_feature_importance(self,classifier_index):
        selected_feature = (self.feature_rank.columns[(self.feature_rank==1).values[0]]).values.tolist()
        feature_coef = self.pipe[classifier_index].coef_.copy()
        self.feature_importance = pd.DataFrame(feature_coef,
                                               columns=selected_feature,
                                               index=['value'])
        print('feature importance:')
        print(self.feature_importance.T['value'].sort_values(ascending=False))
