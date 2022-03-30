import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import time

from utils import get_datasets,dataset_augmentation,regression_evaluation
from sklearn.linear_model import LinearRegression

#Applies PCR regression to estimate the beta_k parameters for a linear model and later applies predictions 
def pcr(X_train, y_train, X_test, num_components):

    #Fitting PCA
    from sklearn.decomposition import PCA
    
    t1=time.time()
    PCA_object=PCA(n_components=num_components , svd_solver = 'full')
    PCA_object.fit(X_train)
    Vk=PCA_object.components_
    Vk=Vk.T

    Wk=PCA_object.transform(X_train)
    Wk_T=Wk.T
    y_2D=np.reshape(y_train, newshape=(len(y_train),1))

    gamma_k=np.linalg.inv(Wk_T@Wk) @ Wk_T @ y_2D

    beta_k=Vk@gamma_k
    t2=time.time()
    #Finished fitting pca

    #Predicting
    beta_k_2D=np.reshape(beta_k, newshape=(len(beta_k),1))
    train_preds=X_train@beta_k_2D
    test_preds=X_test@beta_k_2D

    train_preds=np.reshape(train_preds, newshape=(len(train_preds)))
    test_preds=np.reshape(test_preds, newshape=(len(test_preds)))
    # print("Applied PCa with num components=", PCA_object.n_components_," variance explained=",np.sum(PCA_object.explained_variance_))

    return beta_k,train_preds,test_preds,t2-t1




data_flag="Infant"        #Choose "Male", "Female" or "Infant"
standardise_flag=1                 #Flag on whether we should standardise the data or not
augment_dataset_flag=1               #Flag on whether we should augment the dataset


pcr_flag=1                     #Flag on whether we should apply PCR (if it is !1 we apply OLS regression)
num_components=31


#Getting the datasets
X_train,y_train,X_test,y_test=get_datasets(data_flag)

if(augment_dataset_flag==1):
    X_train,X_test=dataset_augmentation(X_train,X_test)
#Finished loading

# #Correlation Matrix
# X_train=pd.DataFrame(X_train)
# correlation_matrix = X_train.corr().round(3)

# sns.heatmap(correlation_matrix, annot=True)
# plt.title("The correlation matrix, Infant")
# plt.show()
# X_train=np.array(X_train)
# #Printed the correlation matrix

#Standardising (and removing the mean from y so that we wont have any intercepts)
if(standardise_flag==1):
    mean_y_train=np.mean(y_train)
    y_train=y_train-mean_y_train
    y_test=y_test-mean_y_train          #Centering the y test using the y train mean value.


    from sklearn.preprocessing import StandardScaler
    scaler=StandardScaler()
    scaler.fit(X_train)
    X_train=scaler.transform(X_train)
    X_test=scaler.transform(X_test)


if(pcr_flag==0):            #If this flag=0 estimate using OLS
    #Linear Regression
    regressor=LinearRegression()
    t1=time.time()
    regressor.fit(X_train, y_train)
    t2=time.time()

    non_zeros=np.where(regressor.coef_!=0)[0]
    k=len(non_zeros)

    train_preds=regressor.predict(X_train)
    test_preds=regressor.predict(X_test)
    regression_evaluation(k, y_train, y_test, train_preds, test_preds, t2-t1, "Augmented Linear Regression "+data_flag )
    


if(pcr_flag==1):        #If this flag=1 then RLS
    print("\n\n")
    beta_k,train_preds,test_preds,fit_time=pcr(X_train, y_train, X_test, num_components)
    non_zeros=np.where(beta_k!=0)[0]
    k=len(non_zeros)
    regression_evaluation(k, y_train, y_test, train_preds, test_preds, fit_time, "PCR, num_components="+str(num_components) )
