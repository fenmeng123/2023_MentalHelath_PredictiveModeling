# -*- coding: utf-8 -*-
"""
Created on Sat Mar  5 00:41:34 2022

@author: 35031
"""

#%%
from sklearn.model_selection import StratifiedShuffleSplit
from sklearn.model_selection import KFold
import pandas as pd
class Data_Partition:
    def __init__(self,data,feature_pool,label='Depression_Label'):
        self.data = data
        self.feature_pool = feature_pool
        self.label = label
    def Stratify(self,test_size,train_size,seed):
        StratifiedSplit = StratifiedShuffleSplit(n_splits=1,
                                                 test_size=test_size,
                                                 train_size=train_size,
                                                 random_state=seed)
        index = list(StratifiedSplit.split(self.data,self.data[self.label]))
        self.train_index = index[0][0]
        self.test_index = index[0][1]
        print("TRAIN_INDEX:", self.train_index, "TEST_INDEX:", self.test_index)
        print("TRAIN_SIZE: N = ",len(self.train_index),"\t TEST_SIZE: N = ",len(self.test_index))
        self.test_data = self.data.iloc[self.test_index,:]
        self.test_X = self.test_data[self.feature_pool]
        self.test_Y = self.test_data[self.label]
        self.train_data = self.data.iloc[self.train_index,:]
        print("Sample Description in train data:")
        print(self.train_data[self.label].value_counts())
    def SampleBalance(self,K,neg_index):
        train_pos_data = self.train_data.loc[self.train_data[self.label]==1,:]
        train_neg_data = self.train_data.loc[self.train_data[self.label]==0,:]
        train_neg_KFold = KFold(n_splits=K,shuffle=True,random_state=0)
        matched_train_neg_index=list(train_neg_KFold.split(train_neg_data))
        matched_train_neg_data=train_neg_data.iloc[matched_train_neg_index[neg_index][1],:]
        self.matched_train_data = pd.concat([train_pos_data,matched_train_neg_data])
        self.train_X=self.matched_train_data[self.feature_pool]
        self.train_Y=self.matched_train_data[self.label]
        self.matched_train_neg_index = matched_train_neg_index
        print("Sample Description in matched(balanced) train data:")
        print(self.matched_train_data[self.label].value_counts())
    def ChangeMatchedTrainNeg(self,new_neg_index):
        train_pos_data = self.train_data.loc[self.train_data[self.label]==1,:]
        train_neg_data = self.train_data.loc[self.train_data[self.label]==0,:]
        matched_train_neg_data=train_neg_data.iloc[self.matched_train_neg_index[new_neg_index][1],:]
        self.matched_train_data = pd.concat([train_pos_data,matched_train_neg_data])
        self.train_X=self.matched_train_data[self.feature_pool]
        self.train_Y=self.matched_train_data[self.label]
    def ReSplit(self,test_size,train_size,K):
        self.Stratify(test_size,train_size,seed=None)
        self.SampleBalance(K,0)
    def ReSelectFeature(self,new_feature_pool):
        self.feature_pool = new_feature_pool
        self.train_X = self.data.loc[self.train_X.index,new_feature_pool]
        self.test_X = self.data.loc[self.test_X.index,new_feature_pool]