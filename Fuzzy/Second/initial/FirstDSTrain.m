%% This is the script I use to train the 4 models and get all the data I need Later on %%

clc
clear
close all
 
%% Initial Parameters
num_epochs=230;
file_name=sprintf("Results%d",num_epochs);      %The name of the file for the results to be written
%% Finished with the initial parameters

%% Loading the data and creating the Training/ Validation/ Test sets
data=load("airfoil_self_noise.dat");        %Loaded the data
[train_set, validation_set, test_set]=split_scale(data, 1); 
%% Finished getting the Data on an appropriate form

%% Initialising the Models with grid partitioning
Models(1).initial_FIS=genfis1(train_set, 2, 'gbellmf', 'constant');
Models(2).initial_FIS=genfis1(train_set, 3, 'gbellmf', 'constant');
Models(3).initial_FIS=genfis1(train_set, 2, 'gbellmf', 'linear');
Models(4).initial_FIS=genfis1(train_set, 3, 'gbellmf', 'linear');
%% Finished initialising the 4 models

%% Training the models
fprintf("Began with the first\n")
tic 
[Models(1).train_FIS, Models(1).train_error, ~,  Models(1).validation_FIS, Models(1).validation_error]=anfis(train_set, Models(1).initial_FIS,[num_epochs 0 0.01 0.9 1.1],[],validation_set);
toc
fprintf("Began with the second\n")
tic 
[Models(2).train_FIS, Models(2).train_error, ~,  Models(2).validation_FIS, Models(2).validation_error]=anfis(train_set, Models(2).initial_FIS,[num_epochs 0 0.01 0.9 1.1],[],validation_set);
toc
fprintf("Began with the third\n")
tic 
[Models(3).train_FIS, Models(3).train_error, ~,  Models(3).validation_FIS, Models(3).validation_error]=anfis(train_set, Models(3).initial_FIS,[num_epochs 0 0.01 0.9 1.1],[],validation_set);
toc
fprintf("Began with the fourth\n")
tic 
[Models(4).train_FIS, Models(4).train_error, ~,  Models(4).validation_FIS, Models(4).validation_error]=anfis(train_set, Models(4).initial_FIS,[num_epochs 0 0.01 0.9 1.1],[],validation_set);
toc
fprintf("Finally Finished\n")
%% Finished training the models


%% Saving my results
Datasets.train=train_set;
Datasets.validation=validation_set;
Datasets.test=test_set;
save(file_name, 'Models', 'Datasets', 'num_epochs');
%% Finished Saving

