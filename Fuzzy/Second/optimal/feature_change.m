%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
%This script loads the train.mat datasets and passes it onto the split_scale function.
% It applies the relieff algorithm ON THE TRAINING set, and gets the indices of importance about the features
%It rearranges the 3 datasets based on the features returnes by the relieff algorithm applied on the training set. (the columns have descending importance).
%We can now easily get the datasets for the grid search by just getting rid of the non important features on the right side of the X data.
%
%The function saves the final Datasets (again on a struct) and the relieff_res_indices -> The results of the relieff algorithm
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%


clc
clear
close all

%% Getting  the initial data
data=load('train.mat');
data=data.data;
%% Finished getting the initial data

%%  Normalising and separating the data
[train_set, validation_set, test_set]=split_scale(data, 1); 
%% Got training/validation/test sets

 %% Separating X and Y values from the datasets
 X_train=train_set(:,1:end-1);
 Y_train=train_set(:,end);
    
 X_validation=validation_set(:,1:end-1);
 Y_validation=validation_set(:,end);
    
 X_test=test_set(:,1:end-1);
 Y_test=test_set(:,end);
 %% Finished separating
 
    
 %% Now applying the relieff algorithm. I can only use the training data, because I have to avoid getting info from the other 2 datasets in this point
 relieff_res_indices = relieff(X_train, Y_train, 10) ;         %Relieff with k=10
 %% Finished applying the relieff
    
 %% Changing the order of the features on the datasets (the order of the columns) so that we have columns of descending importance. Getting the final datasets
 X_train_changed=X_train(:,relieff_res_indices);
 X_validation_changed=X_validation(:,relieff_res_indices);
 X_test_changed=X_test(:,relieff_res_indices);
    
 final_train=[X_train_changed, Y_train];
 final_validation=[X_validation_changed, Y_validation];
 final_test=[X_test_changed, Y_test];
    
   
 final_Datasets.train=final_train;
 final_Datasets.validation=final_validation;
 final_Datasets.test=final_test;

 
 save("feature_change_results.mat","final_Datasets","relieff_res_indices");     %Saving my results
  %% Finished with the algorithm