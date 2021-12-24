clc
clear
close all

%% First loading the data (results from the feature_change.m)
load("feature_change_results.mat")

train_set=final_Datasets.train;
validation_set=final_Datasets.va lidation;
test_set=final_Datasets.test;
%% Finished loading the data

%% Setting some values for the grid search
num_features=[15, 30, 50, 70];
ra_values=[0.2, 0.4, 0.6, 0.85];
num_epochs=75;
%% Finished setting the values


%% For loop to apply the grid search
num_patterns=size(train_set,1);
kfold_struct=cvpartition(num_patterns, 'kfold', 5);         %Struct to implement 5 fold cross validation
%Each iteration of the following loop corresponds to a number of the num_features variable
for feature_index=1:length(num_features)
    %Getting useful variables for the current feature_index
    current_num_features=num_features(feature_index);
    
    current_train_set=[ train_set(:,1:current_num_features), train_set(:,end)];
    %Finished getting useful variables
    
    %Each iteration of the following for loop corresponds to one number of the ra value variable
    for ra_index=1:length(ra_values)
        feature_index
        ra_index
        current_ra=ra_values(ra_index);
        min_MSE(feature_index,ra_index)= kfold_validate(kfold_struct, current_train_set, current_ra, num_epochs)
    end
    %Finished with the ra values for this num_features value
end
%Finished with the grid search

save('grid_search_results.mat', 'min_MSE', 'num_features', 'ra_values')