%% This is the script I sue to print the results I have for the second part of the exercise

clc
clear
close all

%% Loading the results from previous .m files
load("feature_change_results.mat")
load("final_model230.mat")                  %Change the name in order to study the models trained with a different number of epochs
load("grid_search_results.mat")

R_sq = @(y_est,y_true) (1-sum((y_true-y_est).^2)/sum((y_true-mean(y_true)).^2));        %Function Handle for R squared
Model=final_model;
%% Finished loading the results from previous .m files

%% First printing the Results from the grid_search algorithm
figure('Name','MSE vs ra values')
for i=1:length(num_features)
    current_row=min_MSE(i,:);
    plot(ra_values,current_row)
    hold on
    legend_matrix(i)=sprintf("Num of Feat=%d",num_features(i));
end
xlabel("Ra values")
ylabel("Mean MSE")
legend(legend_matrix)


figure('Name','MSE vs num of features')
for i=1:length(ra_values)
    current_col=min_MSE(:,i);
    plot(num_features, current_col)
    hold on
    legend_matrix(i)=sprintf("Ra=%d",ra_values(i));
end
xlabel("Number of features")
ylabel("Mean MSE")
legend(legend_matrix)
%% Finished printing the results

%% Printing the learning curve for the final Model
figure("Name","Learning Curve")
plot(Model.train_error)
hold on
plot(Model.validation_error)
legend("Training error","Validation Error")
xlabel("Epochs")
ylabel("MSE")
%% Finished with the learning curve

%% Making predictions on the test set.
test_set=reduced_dataset.test;              %Getting the reduced dataset

%Plotting the True values vs the predicted ones
Y_true=test_set(:,end);         %The measured values
validated_model=Model.validation_FIS;
Y_pred=evalfis(test_set(:,1:end-1),validated_model);
clc
figure("Name","Predictions vs True values")
plot(Y_pred)
hold on
plot(Y_true)
legend("Predictions","True values")
%Finished plotting these values

% Plotting the residuals
residuals=Y_true-Y_pred;
figure("Name","The Test Set residuals")
plot(residuals)
%Finished with the residuals
%% Finished plotting the predictions on the test set.


%% Calculating the statistics
MSE=var(residuals);
RMSE=sqrt(MSE);
Rsq=R_sq(Y_pred, Y_true);
NMSE=1 -Rsq;
NDEI=sqrt(NMSE);

%Printing the table
Data_Table=[RMSE; Rsq; NMSE; NDEI];
varnames={'Statistics_Values'};
rownames={'RMSE','Rsq', 'NMSE', 'NDEI'};
Data_Table=array2table(Data_Table,'VariableNames',varnames,'RowNames',rownames);
disp(Data_Table)
%% Finished with the statistics


%% Printing Some Membership Functions
figure("Name","Printing Some Rules")
input_num1=1;            %This is the input number to be printed - change it to print something else
input_num2=3;       

subplot(2,2,1)
plotmf(final_model.initial_FIS, 'input', input_num1)
plot_title=sprintf("Input=%d on the initial FIS",input_num1);
title(plot_title)

subplot(2,2,2)
plotmf(final_model.initial_FIS, 'input', input_num2)
plot_title=sprintf("Input=%d on the initial FIS",input_num2);
title(plot_title)

subplot(2,2,3)
plotmf(final_model.validation_FIS, 'input', input_num1)
plot_title=sprintf("Input=%d on the validation FIS",input_num1);
title(plot_title)

subplot(2,2,4)
plotmf(final_model.validation_FIS, 'input', input_num2)
plot_title=sprintf("Input=%d on the validation FIS",input_num2);
title(plot_title)
