% % This is the script I use to show the results (plots, error statistics etc)

clc
clear
close all


% % First Loading the results I got from the FirstDSTrain.m file
load("Results230.mat");
R_sq = @(y_est,y_true) (1-sum((y_true-y_est).^2)/sum((y_true-mean(y_true)).^2));        %Function Handle for R squared
% % Got my Results

% % First printing the Membership Functions - Both before and after the Validation
for model_index=1:length(Models)
    
    %Getting useful data for the current model
    current_title=sprintf("The MFs for Model %d",model_index);
    current_model=Models(model_index).validation_FIS;
    current_untrained_model=Models(model_index).initial_FIS;
    num_inputs=length(current_model.input);
    % Finished getting the data for the current model
    
    
    % Making the plots %
    figure('Name', current_title)
    
    %For the untrained model:
    for rule_index=1:num_inputs
        subplot(2, num_inputs, rule_index)
        plotmf(current_untrained_model, 'input', rule_index)
    end
    %Finished with the untrained model
    
    %For the trained model:
    for rule_index=1+num_inputs:2*num_inputs
        subplot(2, num_inputs, rule_index)
        plotmf(current_model, 'input', rule_index-num_inputs)
    end
    %Finished with the trained model
    
    % Finished making the plots %
end
% % Finished with the MF plots.


% % Now printing the Learning Curves
for model_index=1:length(Models)
    
    %Getting useful data for the current model
    current_title=sprintf("The Learning Curve for Model %d",model_index);
    current_train_errors=Models(model_index).train_error;
    current_validation_errors=Models(model_index).validation_error;
    % Finished getting the data for the current model
    
    figure("Name",current_title)
    plot(current_train_errors)
    hold on
    plot(current_validation_errors)
    legend("Train Error","Validation Error")
    ylabel("MSE")
    xlabel("Iteration Num")
    
end
%% Finished printing the Learning Curves


% Now printing the prediction errors on the test set
 Y_true=Datasets.test(:,end);
for model_index=1:length(Models)
    
    %Getting useful data for the current model
    current_title=sprintf("The prediction errors for Model %d",model_index);
    current_validation_model=Models(model_index).validation_FIS;

    Y_pred_validation=evalfis(Datasets.test(:,1:end-1),current_validation_model);
    Models(model_index).val_pred=Y_pred_validation;     %%Adding a new field in the struct, it has the info about the predictions
    %Got the useful data
    
    %Making the plot
    figure("Name",current_title)
    
    subplot(2,1,1)      %First plotting the predictions and the true values on the same plot
    plot(Y_true)
    hold on
    plot(Y_pred_validation)
    legend("The true values", " Predictions from validated model")
    
    subplot(2,1,2)
    residuals=Y_true-Y_pred_validation;
    plot(residuals)
    legend("The residuals of the predictions (prediction errors)")
    %Finished with the plot
end
 

%% Now I calculate the error statistics
for model_index=1:length(Models)
    
    %Info for the current model
    current_y_est=Models(model_index).val_pred;
    current_residuals=Y_true-current_y_est;
    %Finished with the current model
    
    %Calculating stats
    MSE=var(current_residuals);
    RMSE(model_index)=sqrt(MSE);
    Rsq(model_index)=R_sq(current_y_est, Y_true);
    NMSE(model_index)=1 -Rsq(model_index);
    NDEI(model_index)=sqrt(NMSE(model_index));
    %Finished with the stats
    
end

%Printing the table
Data_Table=[RMSE; Rsq; NMSE; NDEI];
varnames={'TSK_model_1','TSK_model_2','TSK_model_3','TSK_model_4'};
rownames={'RMSE','Rsq', 'NMSE', 'NDEI'};
Data_Table=array2table(Data_Table,'VariableNames',varnames,'RowNames',rownames);
disp(Data_Table)
%% Finished with the statistics
