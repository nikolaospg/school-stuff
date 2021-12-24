clc
clear
close all

%% Loading the data and getting the optimal results
num_epochs=400;
file_name=sprintf("final_model%d",num_epochs);      %The name of the file for the results to be written
load('feature_change_results.mat')
load('grid_search_results.mat')
row=4;          %The row and column that I decided to pick 
col=4;      

optimal_num_feat=num_features(row)
optimal_ra=ra_values(col)
%% Finished getting the optimal values

%% Training the model
train_set=final_Datasets.train;
validation_set=final_Datasets.validation;
test_set=final_Datasets.test;

train_set_reduced=[ train_set(:,1:optimal_num_feat), train_set(:,end)];
validation_set_reduced=[ validation_set(:,1:optimal_num_feat), validation_set(:,end)];
test_set_reduced=[ test_set(:,1:optimal_num_feat), test_set(:,end)];

initial_FIS=genfis2(train_set_reduced(:,1:end-1),train_set_reduced(:,end), optimal_ra);       %Using this specific radius value

[train_FIS,train_error,~,validation_FIS,validation_error]=anfis(train_set_reduced, initial_FIS, [num_epochs 0 0.01 0.9 1.1],[],validation_set_reduced);
%% Finished training the model

%% Now saving the result
final_model.initial_FIS=initial_FIS;
final_model.train_FIS=train_FIS;
final_model.validation_FIS=validation_FIS;
final_model.validation_error=validation_error;
final_model.train_error=train_error;

reduced_dataset.train=train_set_reduced;
reduced_dataset.validation=validation_set_reduced;
reduced_dataset.test=test_set_reduced;

save(file_name,'final_model','reduced_dataset')

