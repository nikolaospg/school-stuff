%This script continues the work done by the simple_death_predict model, and 
%creates multiple linear models (and stepwise multiple linear models) to try and have
%a better prediction on the deaths based on the daily cases
%Scatter plots and R^2/adjR^2 are used for validation

clc
clear
close all

%we chose to work with the countries:
%   Austria           (8)
%   Belgium          (13)
%   Greece           (54)
%   Italy               (67)    (the initial one)
%   Serbia            (121)
%   UK                  (147)


%Getting the data
country_id_vector=[8 13 54 67 121 147];
[Cases_final, Deaths_final,Cases_before, Deaths_before, populations ]=read_data('Covid19Confirmed.xlsx', 'Covid19Deaths.xlsx',...
    country_id_vector);
figure_num=0;
simple_lin_tau=[12 5 6 6 0 0];
%Finished getting the data.


%Every iteration of this for loop corresponds to one country
%   The rsq_array is an array, where in every row we have the R^2 from the three models for one country
%   The adj_rsq_array is the equivalent for the adjR^2
for i=1:size(populations,1)
    figure_num=figure_num+1;
    figure(figure_num)
    Cases=Cases_final(i,2:end);             %The first index corresponds to the id of the country, therefore I pick the data from the second index onwards
    Deaths=Deaths_final(i,2:end);           %The first index corresponds to the id of the country, therefore I pick the data from the second index onwards
    current_tau=simple_lin_tau(i);
    
    %First model: The simple linear
    cases_reduced=Cases(1:end-current_tau);
    deaths_reduced=Deaths(1+current_tau:end);
    model=fitlm(cases_reduced, deaths_reduced);         %Fitting the model
    rsq_array(i,1)=model.Rsquared.Ordinary;
    adj_rsq_array(i,1)=model.Rsquared.Adjusted;
    residuals_norm=table2array(model.Residuals(:,1));
    residuals_norm=residuals_norm/std(residuals_norm);      %Getting the normalised residuals vector
    fitted_vector=model.Fitted;                                     % Getting the fitted values
 
    %Now we will print the diagnostic plot
    subplot(3,1,1)
    scatter(fitted_vector, residuals_norm);
    title(sprintf('Simple linear Id=%d, tau=%d, pts=%d, R2=%.2f, AR2=%.2f', country_id_vector(i)...
        , current_tau, length(residuals_norm), rsq_array(i,1), adj_rsq_array(i,1)));
    hold on
    xlabel('fitted values');
    ylabel('Res. normalised');
    plot( [min(min(fitted_vector),0) max(max(fitted_vector),0)], [1.96 1.96]);
    plot( [min(min(fitted_vector),0) max(max(fitted_vector),0)], [-1.96 -1.96]);
    %Finished the diagnostic plot
    %FInished with the simple linear model.
    
    
    %The models with 20 regressors.
    %First of all the regressor vectors must have all the same length
    %In this for loop we will create an X array with all the regressor vectors
    X=zeros(20, length(Deaths)-19);
    for j=0:19
        reg_temp=Cases(1:end-j);          %getting the temp regressor.
        reg_temp=reg_temp(20-j:end);
        length(reg_temp);
        X(j+1,:)=reg_temp;
    end
    X=X';
    Y=Deaths(20:end);
    %we now have the Y and X data to fit the multiple linear models
    
    
    %The one with 20 regressors
    model2=fitlm(X,Y);
    rsq_array(i,2)=model2.Rsquared.Ordinary;
    adj_rsq_array(i,2)=model2.Rsquared.Adjusted;
    residuals_norm=table2array(model2.Residuals(:,1));
    residuals_norm=residuals_norm/std(residuals_norm);      %Getting the normalised residuals vector
    fitted_vector=model2.Fitted;                                     % Getting the fitted values
 
    %Now we will print the diagnostic plot
    subplot(3,1,2)
    scatter(fitted_vector, residuals_norm);
    title(sprintf('Multiple linear Id=%d, maxtau=%d, pts=%d, R2=%.2f, AR2=%.2f', country_id_vector(i)...
        , 19, length(residuals_norm), rsq_array(i,2), adj_rsq_array(i,2)));
    hold on
    xlabel('fitted values');
    ylabel('Res. normalised');
    plot( [min(min(fitted_vector),0) max(max(fitted_vector),0)], [1.96 1.96]);
    plot( [min(min(fitted_vector),0) max(max(fitted_vector),0)], [-1.96 -1.96]);
    %Finished the diagnostic plot
    %Finished with the multiple linear(20 regressors)
    
    
    %The last one, with dimensionality reduction
    %we will use stepwise regression
    [~, ~, ~ , model2temp]=stepwisefit( X,Y');       %we use this command to get the model2temp vector, which tells me the variables that i should use.
    X_red=X(:,model2temp);
    model3=fitlm(X_red,Y);
    rsq_array(i,3)=model3.Rsquared.Ordinary;
    adj_rsq_array(i,3)=model3.Rsquared.Adjusted;
    residuals_norm=table2array(model3.Residuals(:,1));
    residuals_norm=residuals_norm/std(residuals_norm);      %Getting the normalised residuals vector
    fitted_vector=model3.Fitted;                                     % Getting the fitted values
 
    %Now we will print the diagnostic plot
    subplot(3,1,3)
    scatter(fitted_vector, residuals_norm);
    title(sprintf('Stepwise Id=%d, maxtau=%d, pts=%d, R2=%.2f, AR2=%.2f', country_id_vector(i)...
        , 19, length(residuals_norm), rsq_array(i,3), adj_rsq_array(i,3)));
    hold on
    xlabel('fitted values');
    ylabel('Res. normalised');
    plot( [min(min(fitted_vector),0) max(max(fitted_vector),0)], [1.96 1.96]);
    plot( [min(min(fitted_vector),0) max(max(fitted_vector),0)], [-1.96 -1.96]);
    %Finished diagnostic
    %Finished with the last model as well
    clc
end

%Comments- Answers to the questions:

% 1) The way the three models are generally compared can be mostly seen by the R^2 coefficients.
%   By using more regressors on the multiple linear model, the R^2 gets larger because there is better
%   fitting. The adjusted R^2 also gets larger but not that much, because there is penalty due to the higher
%   complexity of the model . Of course this is not true for all countries, as there could be a situation where
%   the difference is not very significant(Serbia-figure 5)
%   The dimensionality reduction model has lower R^2 than the multiple linear with all the regressors, and the
%   adjR^2 generally gets a little smaller (lower complexity and worse fitting). But this model offers to us 
%   a great advantage, and that is that i get rid of the large number of regressors and succesfuly reduce
%   the dimensionality.

%   2) As for the fitting, not all the countries enjoy equally good fittings from the model (just like before with
%   the simple linear models). But with the multiple linear models, we manage to increase by some amount
%   the R^2 coefficients of the countries that had a serious problem previously (on Greece Fig.3 it goes from 0.26
%   to 0.39). Of course the problem does not completely get solved but it surely is some improvement

%   3) As for the prediction, by looking at the improvement of the R^2 coefficients, or more correctly the
%   adjR^2 coefficients who induce a penalty on complex models and are a criterion for the general quality of 
%   the model, we can say that the ability to predict has improved when using the multiple linear models.

