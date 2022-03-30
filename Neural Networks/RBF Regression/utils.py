import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import r2_score,mean_squared_error,mean_absolute_error
import math
import scipy as sp
import time
#Function used to load the dataset
def get_datasets(data_flag):
    if(data_flag=="Male"):
        X_train=np.load("datasets/X_train_M.npy")
        y_train=np.load("datasets/y_train_M.npy")
        X_test=np.load("datasets/X_test_M.npy")
        y_test=np.load("datasets/y_test_M.npy")

    if(data_flag=="Female"):
        X_train=np.load("datasets/X_train_F.npy")
        y_train=np.load("datasets/y_train_F.npy")
        X_test=np.load("datasets/X_test_F.npy")
        y_test=np.load("datasets/y_test_F.npy")

    if(data_flag=="Infant"):
        X_train=np.load("datasets/X_train_I.npy")
        y_train=np.load("datasets/y_train_I.npy")
        X_test=np.load("datasets/X_test_I.npy")
        y_test=np.load("datasets/y_test_I.npy")

    return X_train,y_train,X_test,y_test



#Used to convert the classical linear regression to polynomial regression. This way the regressor is able to understand non linearities too/
def dataset_augmentation(X_train, X_test):

    X_train_aug=X_train
    X_test_aug=X_test
    # Getting the products of the regressors (i.e. xi*xj for every pair of the regressor)
    for i in range(len(X_train[0])):
        Xi=X_train[:,[i]]
        prod_mat=Xi*X_train
        X_train_aug=np.concatenate((X_train_aug,prod_mat), axis=1)

        Xi=X_test[:,[i]]
        prod_mat=Xi*X_test
        X_test_aug=np.concatenate((X_test_aug,prod_mat), axis=1)


    #Hadamard product to get the squares of the regressors
    X_train_sq=X_train*X_train   
    X_test_sq=X_test*X_test
    X_train_aug=np.concatenate((X_train_aug,X_train_sq), axis=1)
    X_test_aug=np.concatenate((X_test_aug,X_test_sq), axis=1)


    return X_train_aug,X_test_aug


#Creates error histogram, diagnostic plots and returns metrics for regression
def regression_evaluation(num_regressors, y_train, y_test, train_preds, test_preds, time, title):

    k=num_regressors

    train_errors=y_train-train_preds
    test_errors=y_test-test_preds

    #Figures:
    fig1=plt.figure()
    plt.hist(train_errors, bins=50)
    plt.title(title + "-Histogram of the train errors")
    plt.show()

    fig2=plt.figure()
    train_errors_norm=train_errors/np.std(train_errors)
    plt.scatter(train_preds, train_errors_norm)
    plt.title(title + "- Diagnostic Scatter of the train errors")
    plt.show()

    fig3=plt.figure()
    plt.hist(test_errors, bins=50)
    plt.title(title +"-Histogram of the test errors")
    plt.show()

    fig4=plt.figure()
    test_errors_norm=test_errors/np.std(test_errors)
    plt.scatter(test_preds, test_errors_norm)
    plt.title(title + "-Diagnostic Scatter of the test errors")
    plt.show()


    #Calculating metrics:
    tr_error_mean=np.mean(train_errors)
    tr_error_var=np.var(train_errors)
    tr_R2=r2_score(y_train, train_preds)
    n=len(y_train)
    tr_adj=1- (1-tr_R2)*(n-1)/(n-k-1)

    tes_error_mean=np.mean(test_errors)
    tes_error_var=np.var(test_errors)
    tes_R2=r2_score(y_test, test_preds)
    n=len(y_test)
    tes_adj=1- (1-tes_R2)*(n-1)/(n-k-1)

    MSE_train=mean_squared_error(y_train ,train_preds )
    MAE_train=mean_absolute_error(y_train ,train_preds )

    MSE_test=mean_squared_error(y_test ,test_preds )
    MAE_test=mean_absolute_error(y_test ,test_preds )

    print("Results for "+title+":")
    print("Num regressors:",k)
    print("Training time",time)
    print("Train set: residual_mean=%f residual_var=%f R2=%f adj_R2=%f RMSE=%f MAE=%f NRMSE=%f NMAE=%f" % (tr_error_mean, tr_error_var, tr_R2, tr_adj, math.sqrt(MSE_train), MAE_train, math.sqrt(MSE_train)/np.std(y_train), MAE_train/np.std(y_train)))
    print("Test set: residual_mean=%f residual_var=%f R2=%f adj_R2=%f RMSE=%f MAE=%f NRMSE=%f NMAE=%f" % (tes_error_mean, tes_error_var, tes_R2, tes_adj, math.sqrt(MSE_test), MAE_test, math.sqrt(MSE_test)/np.std(y_test), MAE_test/np.std(y_test)))




#method->"random" or "kmeans"
#num_centers-> The amount of RBF nodes I will use
#X_train-> The train set (should be standardised)
def train_RBF(method, num_centers, X_train):
    from sklearn.cluster import MiniBatchKMeans

    #Getting centers:
    t1=time.time()
    if(method=="complete"):
        centers=X_train
    
    if(method=="kmeans"):
        kmeans = MiniBatchKMeans(n_clusters=num_centers, max_iter=10000, random_state=42)          #Using MiniBatch kmeans mainly for memory purposes 
        kmeans.fit(X_train.astype("float32"))
        centers=kmeans.cluster_centers_
    #Finished getting the centers

    #Getting the sigma
    distances=sp.spatial.distance.pdist(centers)
    max=np.max(distances)
    sigma=max/math.sqrt(2*num_centers)
    t2=time.time()

    return centers,sigma


#The following function passes the whole X dataset through a specific RBF node of the Network. 
#It takes as input the X dataset, the center and the sigma of the current node.
#It returns a vector (1D array) with the transformed values. This will be a column in the output array of the RBF layer.
def node_pass(X, center, sigma, kernel):

    X_centered=X-center                         #Centered around the cunter of the current Node
    norms=np.zeros(shape=(len(X_centered),))    #The norms SQUARED!
    output=np.zeros(shape=(len(X_centered),))
    norms=np.einsum("ij,ij->i", X_centered, X_centered)
        
    
    if(kernel=="gaussian"):
        output=-norms/(sigma**2)  
        output=np.exp(output)

    if(kernel=="multiquadratic"):
        output=norms+sigma**2
        output=np.sqrt(output)

    return output

#This function passes the whole X dataset through the RBF layer. 
#It uses the node_pass function to pass the dataset through every single Layer
def RBF_layer_pass(X, centers, sigma, kernel):

    num_obs=len(X)
    num_features=len(centers)
    X_output=np.zeros(shape=(num_obs, num_features))

    for i in range(num_features):
        X_output[:,i]=node_pass(X,centers[i], sigma, kernel)
    
    return X_output


