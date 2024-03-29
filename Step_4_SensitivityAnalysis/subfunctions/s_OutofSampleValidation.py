# -*- coding: utf-8 -*-
"""
Python Script for Out-of-Sample Model Evaluation
also named External Validiation in our manuscript
Created on Tue Apr 25 11:28:19 2023
@author: Kunru Song
"""
import pandas as pd
from sklearn.utils import resample
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import Pipeline
from subfunctions.s_ResultAssitant import Classifier_AutoRepot
class Mdl_Pipe:
    def __init__(self,
                 name='NULL',
                 predictors = '',
                 target = 'Depression_Label'):
        self.name = name
        self.feature_pool = predictors
        self.Y_Name = target
        
    def MdlSpec(self,lambda_L2=1,weights=None):
        self.pipe = Pipeline(
            [('classifier',
             LogisticRegression(max_iter=int(10000),
                                C=lambda_L2,
                                class_weight=weights))])
    def MdlFit(self,train,method='weighting'):
        self.raw_train_sample = train
        self.fit_method = method
        train_x = train[self.feature_pool]
        train_y = train[self.Y_Name]
        Num_NegCase = (train_y==0).sum().values[0]
        Num_PosCase = (train_y==1).sum().values[0]
        train_neg = train.loc[(train[self.Y_Name]==0).values]
        train_pos = train.loc[(train[self.Y_Name]==1).values]
        train_y = (train_y).values.ravel()
        if method == 'weighting':
            para = {'class_weight':'balanced'}
            self.pipe['classifier'].set_params(**para)
        elif method == 'downsampling':
            para = {'class_weight':None}
            self.pipe['classifier'].set_params(**para)
            downsamp_train_neg = resample(train_neg,\
                                          replace=False,\
                                          random_state=1,\
                                          n_samples=Num_PosCase)
            train = pd.concat([downsamp_train_neg,train_pos],ignore_index=True)
            train_x = train[self.feature_pool]
            train_y = (train[self.Y_Name]).values.ravel()
        elif method == 'upsampling':
            para = {'class_weight':None}
            self.pipe['classifier'].set_params(**para)
            upsamp_train_pos = resample(train_pos,\
                                        replace=True,\
                                        random_state=1,\
                                        n_samples=(Num_NegCase - Num_PosCase))
            train = pd.concat([train_neg,upsamp_train_pos],ignore_index=True)
            train_x = train[self.feature_pool]
            train_y = (train[self.Y_Name]).values.ravel()
        self.pipe.fit(train_x,train_y)
        self.train_data = train
        self.internal_actual_y = train_y
        self.internal_pred_y = self.pipe.predict(train_x)
    def MdlPred(self,test):
        test_x = test[self.feature_pool]
        test_y = test[self.Y_Name]
        self.pred_y = self.pipe.predict(test_x)
        self.actual_y = (test_y[self.Y_Name]).values.ravel()
        self.pred_proba = self.pipe.predict_proba(test_x)
    def RndSamp_TrainPred(self,train,test,IterFlag,IterRes):
        self.rep = Classifier_AutoRepot('ResultReport')
        train_x = train[self.feature_pool]
        train_y = (train[self.Y_Name]).values.ravel()
        self.pipe.fit(train_x,train_y)
        self.internal_pred_y = self.pipe.predict(train_x)
        self.MdlPred(test)
        self.rep.RunAll(self.internal_pred_y, train_y) 
        self.rep.SaveResult('Internal')
        self.rep.RunAll(self.pred_y, self.actual_y) 
        self.rep.SaveResult('External')
        self.rep.Res['IterNum']=IterFlag
        print(self.rep.Res[['name','IterNum','balacc','F1_score']])
        IterRes = pd.concat([IterRes,self.rep.Res],ignore_index=True)
        return(IterRes)
    def MdlRepeat(self,Num_repeat,test):
        train_y = self.raw_train_sample[self.Y_Name]
        self.Num_NegCase = (train_y==0).sum().values[0]
        self.Num_PosCase = (train_y==1).sum().values[0]
        train_neg = self.raw_train_sample.loc[(self.raw_train_sample[self.Y_Name]==0).values]
        train_pos = self.raw_train_sample.loc[(self.raw_train_sample[self.Y_Name]==1).values]
        para = {'class_weight':None}
        self.pipe['classifier'].set_params(**para)
        IterRes = pd.DataFrame()
        # Test_y_proba = pd.DataFrame()
        MdlCoef = pd.DataFrame()
        if self.fit_method == 'downsampling':
            for i in range(Num_repeat):
                print("# Iter %d (down-sampling)" %(i))
                downsamp_train_neg = resample(train_neg,\
                                              replace=False,\
                                              n_samples=self.Num_PosCase)
                train = pd.concat([downsamp_train_neg,train_pos],ignore_index=True)
                IterRes = self.RndSamp_TrainPred(train,test,i,IterRes)
                # Test_y_proba.insert(i,'PosCase_Iter_'+str(i),self.pred_proba[:,1])
                if i == 0:
                    MdlCoef.insert(0, 'CoefName', self.pipe['classifier'].feature_names_in_)
                    MdlCoef.insert(1,'Coef_'+str(i),self.pipe['classifier'].coef_[0])
                else:
                    MdlCoef.insert(i+1,'Coef_'+str(i),self.pipe['classifier'].coef_[0])
                MdlCoef = MdlCoef.copy()
        elif self.fit_method == 'upsampling':
            for i in range(Num_repeat):
                print("# Iter %d (up-sampling)" %(i))
                upsamp_train_pos = resample(train_pos,\
                                            replace=True,\
                                            n_samples=(self.Num_NegCase - self.Num_PosCase))
                train = pd.concat([train_neg,train_pos,upsamp_train_pos],ignore_index=True)
                IterRes = self.RndSamp_TrainPred(train,test,i,IterRes)
                # Test_y_proba.insert(i,'PosCase_Iter_'+str(i),self.pred_proba[:,1])
                if i == 0:
                    MdlCoef.insert(0, 'CoefName', self.pipe['classifier'].feature_names_in_)
                    MdlCoef.insert(1,'Coef_'+str(i),self.pipe['classifier'].coef_[0])
                else:
                    MdlCoef.insert(i+1,'Coef_'+str(i),self.pipe['classifier'].coef_[0])
                MdlCoef = MdlCoef.copy()
        self.IterRes = IterRes
        # self.y_proba = Test_y_proba
        self.MdlCoef = MdlCoef
        return(IterRes)