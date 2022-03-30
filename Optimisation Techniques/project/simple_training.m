clc
clear 
close all


%In this script I will be using a kmeans combined with least squares to train the model
%I do this to have a vague idea of how a solution should look like

dataset=load("simple_dataset.mat");
dataset=dataset.current_dataset;

train_set=dataset.train;
val_set=dataset.val;
test_set=dataset.test;

num_centers=15;
fprintf("Using a kmeans-OLS hybrid RBF network with %d centers\n",num_centers)
%Loading train set:
X_train=train_set(:,1:2);
y_train=train_set(:,3);

mean_ytrain=mean(y_train);
y_train=y_train-mean(y_train);

%Loading test set:
X_test=test_set(:,1:2);
y_test=test_set(:,3);

mean_ytest=mean(y_test);
y_test=y_test-mean(y_train);                %I am not allowed to use the mean(y_test)


%Getting the centers
rng(42)                                    %Setting a random seed
[~,centers]=kmeans(X_train,num_centers);            %Got the centers

%Maximum distance
distances=pdist2(centers,centers);
max_dist=max(max(distances));


sigma=max_dist/sqrt(2*num_centers);        %Got the sigma value


%Now transforming dataset (passing through RBF Layer)
model_matrix=[centers(:,1), centers(:,2), ones(num_centers,2)*sigma];

X_trans=rbf_pass(model_matrix, X_train);


%Now getting ols solution
theta=linsolve(X_trans'*X_trans, X_trans'*y_train);
model_matrix(:,5)=theta;



%Now infering
train_preds=infer_dataset(model_matrix,X_train);
train_errors=y_train-train_preds;
train_MSE=mean(train_errors.*train_errors);
train_RMSE=sqrt(train_MSE);
train_MAE=mean(abs(train_errors));



test_preds=infer_dataset(model_matrix,X_test);
test_errors=y_test-test_preds;
test_MSE=mean(test_errors.*test_errors);
test_RMSE=sqrt(test_MSE);
test_MAE=mean(abs(test_errors));

fprintf("train_RMSE=%f train_MAE=%f test_RMSE=%f train_MAE=%f \n",train_RMSE, train_MAE, test_RMSE, test_MAE)



fprintf("\n\n")
mytable=table([model_matrix(:,1)], [model_matrix(:,2)], [model_matrix(:,3)], [model_matrix(:,4)], [model_matrix(:,5)]  );
mytable.Properties.VariableNames = {'C1' 'C2' 'Sigma1' 'Sigma2' 'Beta'};
disp(mytable)