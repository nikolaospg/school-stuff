import numpy as np
from numpy.linalg.linalg import norm
from sklearn.cluster import MiniBatchKMeans
import time
from sklearn.linear_model import LinearRegression,Lasso
from sklearn.metrics import r2_score,mean_squared_error,mean_absolute_error
from utils import get_datasets,train_RBF,RBF_layer_pass,regression_evaluation

from warnings import filterwarnings
filterwarnings('ignore')


#k is the number of folds and lamda vals a 1D array with the values chosed for the grid search
def lasso_grid_search(lambda_vals, X, y, k):

    #First creating the folds via random permutation
    num_folds=k
    num_observations=len(X)
    perm=np.random.RandomState(seed=42).permutation(num_observations)
    
    #The fist k-1 folds get int(num_observations/num_folds) observations
    #The last fold gets the remaining observations
    first_obs=int(num_observations/num_folds)

    help_sequence=np.array(range(0,num_folds+1,1))*first_obs
    help_sequence[-1]=num_observations
    #To get the indices of the permutation that correspond to the ith fold,
    #we get the left border as help_sequence[i] and the right border as help_sequence[i+1]
    #Finished creating the folds

    #Now doing the loop
    metrics=np.zeros(shape=(len(lambda_vals),))
    for fold_index in range(num_folds):

        #Getting the current X_train and y_train
        current_perms=perm[help_sequence[fold_index]:help_sequence[fold_index+1]]
        X_test_current=X[current_perms]
        y_test_current=y[current_perms]

        X_train_current=np.delete(X_train, current_perms, axis=0)
        y_train_current=np.delete(y_train, current_perms)

        if(use_initial_features_flag==1):
            X_train_init=X_train_current
            X_test_init=X_test_current


        #Training RBF network and converting the X values
        centers,sigma=train_RBF("complete", len(X_train_current), X_train_current)          #I pass len(X_train_current) because we take all of the centers

        X_train_current=RBF_layer_pass(X_train_current, centers, sigma, kernel)
        X_test_current=RBF_layer_pass(X_test_current, centers, sigma, kernel)

        #Scaling again (Needed for LASSO)
        scaler=StandardScaler()
        scaler.fit(X_train_current)
        X_train_current=scaler.transform(X_train_current)
        X_test_current=scaler.transform(X_test_current)

        if(use_initial_features_flag==1):
            X_train_current=np.concatenate((X_train_current,X_train_init),axis=1)
            X_test_current=np.concatenate((X_test_current,X_test_init),axis=1)


        #Now working with the various lambda values on this specific fold
        for lambda_index in range(len(lambda_vals)):
            current_lambda=lambda_vals[lambda_index]
            regressor=Lasso(alpha=current_lambda, fit_intercept=False, tol=5e-2)
            regressor.fit(X_train_current, y_train_current)
            test_preds=regressor.predict(X_test_current)
            current_MSE=mean_squared_error(y_test_current,test_preds)
            metrics[lambda_index]=metrics[lambda_index]+current_MSE
    
    metrics=metrics/num_folds
    print(metrics)
    opt_index=np.argmin(metrics)
    chosen_lambda=lambda_vals[opt_index]
    print("The chosen lambda value is",chosen_lambda,"with MSE", metrics[opt_index])
    return chosen_lambda




#Parameters and loading
data_flag="Male"          #Choose "Male", "Female" or "Infant"
method="complete"
kernel="multiquadratic"           #Either "gaussian" or "multiquadratic"
regression="LASSO"            #Choose either "OLS" or "LASSO"
alpha=0.015       #Reg. parameter of LASSO

grid_search_flag=0
lambda_vals=np.array([0.005, 0.01, 0.015, 0.02, 0.04, 0.06, 0.08, 0.1, 0.125, 0.15, 0.2, 0.22, 0.25, 0.3, 0.35, 0.4, 0.5, 0.6])
num_folds=5

use_initial_features_flag=1         #Used to judge on whether to use the initial features too
print("Kernel is",kernel)
X_train,y_train,X_test,y_test=get_datasets(data_flag)



#Standardising X and centering y
mean_y_train=np.mean(y_train)
y_train=y_train-mean_y_train
y_test=y_test-mean_y_train          #Centering the y test using the y train mean value.

from sklearn.preprocessing import StandardScaler
scaler=StandardScaler()
scaler.fit(X_train)
X_train=scaler.transform(X_train)
X_test=scaler.transform(X_test)
# Finished working with the dataset



if(grid_search_flag==1):
    t1=time.time()
    lasso_grid_search(lambda_vals, X_train, y_train, num_folds)
    t2=time.time()
    print("Time needed",t2-t1)
    
else:
    if(use_initial_features_flag==1):
        X_train_init=X_train
        X_test_init=X_test
    #Passing through the RBF layer
    t01=time.time()
    centers,sigma=train_RBF(method, len(X_train), X_train)
    t02=time.time()
    print("Time needed to train RBF with centers=",len(X_train)," and method=",method," is ",t02-t01,sep="")


    t11=time.time()
    X_train=RBF_layer_pass(X_train, centers, sigma, kernel)
    t12=time.time()
    t21=time.time()
    X_test=RBF_layer_pass(X_test, centers, sigma, kernel)
    t22=time.time()

    print("Time needed to pass the train set=",t12-t11)
    print("Time needed to pass the test set=",t22-t21)


    #Scaling again (Needed for and LASSO)
    scaler=StandardScaler()
    scaler.fit(X_train)
    X_train=scaler.transform(X_train)
    X_test=scaler.transform(X_test)

    if(use_initial_features_flag==1):
        X_train=np.concatenate((X_train,X_train_init),axis=1)
        X_test=np.concatenate((X_test,X_test_init),axis=1)

    if(regression=="OLS"):

        #Regression - OLS
        regressor=LinearRegression()
        t1=time.time()
        regressor.fit(X_train, y_train)

        non_zeros=np.where(regressor.coef_!=0)
        k=len(non_zeros[0])
        t2=time.time()

        train_preds=regressor.predict(X_train)
        test_preds=regressor.predict(X_test)
        regression_evaluation(k, y_train, y_test, train_preds, test_preds, t2-t1, "OLS Regression " + data_flag )

    if(regression=="LASSO"):
        #Regression - LASSO
        
        regressor=Lasso(alpha=alpha, fit_intercept=False)
        t1=time.time()
        regressor.fit(X_train, y_train)

        non_zeros=np.where(regressor.coef_!=0)
        k=len(non_zeros[0])
        t2=time.time()

        train_preds=regressor.predict(X_train)
        test_preds=regressor.predict(X_test)
        regression_evaluation(k,y_train, y_test, train_preds, test_preds, t2-t1, "Lasso Regression " + data_flag + " l= "+str(alpha) )