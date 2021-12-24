%In this script I attempt to create linear regression models to predict the daily deaths values from
%the daily cases of each country (one regressor - one output). The choices are done using a tau parameter
%to model the day difference between the cases and the deaths. Diagnostic plots (regression residuals) are made
%to check the quality of the models


clc
clear
%We chose to work with the countries:
%   Austria           (8)
%   Belgium          (13)
%   Greece           (54)
%   Italy               (67)    (the initial one)
%   Serbia            (121)
%   UK                  (147)


%Getting our data
country_id_vector=[8 13 54 67 121 147];
[Cases_final, Deaths_final,Cases_before, Deaths_before, populations ]=read_data('Covid19Confirmed.xlsx', 'Covid19Deaths.xlsx',...
    country_id_vector);
figure_num=1;
%Finished Getting the data


%Every iteration of this for loop corresponds to one country
for i=1:size(populations,1)
    Cases=Cases_final(i,2:end);         %The first index corresponds to the id of the country, therefore I pick the data from the second index onwards
    Deaths=Deaths_final(i,2:end);           %The first index corresponds to the id of the country, therefore I pick the data from the second index onwards
    
    %Initialising the following arrays that will hold the residuals and the fitted values
    % Because every time the tau rises there are less elements, we initialise with zeros,
    % so that we dont have empty values
    residuals_array=zeros(20, length(Deaths));
    fitted_array=zeros(20, length(Deaths));
    %FInished initialising the arrays
    
    %Calculating the residuals for tau=0:19 for one country
    for tau=0:19
        cases_reduced=Cases(1:end-tau);
        deaths_reduced=Deaths(1+tau:end);
        model=fitlm(cases_reduced, deaths_reduced);
        
        residuals_norm=table2array(model.Residuals(:,1));
        residuals_norm=residuals_norm/std(residuals_norm);
        residuals_array(tau+1,1:length(cases_reduced))=residuals_norm;
        
        fitted_vector=model.Fitted;
        fitted_array(tau+1,1:length(cases_reduced))=fitted_vector;
        
        r_squared(tau+1)=model.Rsquared.Ordinary;
    end
    %Finished getting the residuals
    
    %Now to create the diagnostic scatter plots. We decided to use subplots in order to 
    % be able to show diagnostic plots for each country. At first it might seem a little hard
    % to study the subplots, but we thought that It would be better than making 100+ scatter
    % plots for every possible tau for every country (which is asked by us to do from the exercise)
    figure(figure_num)
    scatter_plot(fitted_array,residuals_array, country_id_vector(i), r_squared)
    figure_num=figure_num+1;
    %Finished with the subplots
    
    %The optimal tau in terms of best fit can be found by finding the max of the r_squared array.
    % we find the index where we get the maximum value and reduce by 1 (because the vectors are 1-based)
    opt_tau(i)=find(r_squared==max(r_squared))-1;
end

%Printing the optimal tau for each country
fprintf('The Countries we chose are:\nAustria(8), Belgium(13), Greece(54), Italy(67), Serbia(121), Uk(147)\n\n')
fprintf('The tau that lead to the best fitting for the simple linear models for each country are:\n');
disp(opt_tau)
%Finished printing



% Comments on the results and answers to your question:
% 
% 1) The fitting: As we can see from the various subplots for each country, the tau parameter greatly
%   affects how well the fitting is. But I can also see that not all of the countries can be described by the simple
%   linear model. Italy and Serbia have quite high maximum R^2 values (0.93, 0.85), while for example Belgium 
%   has a relatively low R^2 value (0.26). So the fitting of the simple linear model is not equally good in the countries
%   we chose
% 
%  2) Looking at the diagnostic plots, we observe that in general, too many values are outside of the statistical 
%   significance barriers, which means that the error terms most probably are not gaussian
%   The points sometimes tend to gather on some areas and are more loose on some others, and generally they seem
%   to be having some structure which seems non stochastic
%   These mean that the hypothesis of Homoscedasticity is violated and that the linear model is inadequate to
%   properly describe the information that should be, when trying to make the regression study.
% 
%   PS: Also how the points are distributed on the plots is affected on a significant part by the tau parameter
%   Although, generally the residuals have the problems we described about the structure and the variance 
%   on every plot, no matter the tau.
%  
%   3) The fitting is quite good on some countries, but we generally saw that the simple linear model is not enough.
%   One could actually make some predictions on the Deaths from the Cases and the would generally be better
%   than a total random guess, but in our opinion a proper method for predicting should be searched in other regression
%   models.
%   
%   4)  We see that the optimal correlation leads to the same tau values as the optinal fitting (R^2), which was
%   something we did expect a-priory due to theory of regression. The value of Serbia is of course different, (on
%   exercise 4 it was tau=-1), but on the fifth exercise we dont look at negative tau values to begin with (there
%   is no reason to study the regression of the daily deaths with the future Cases as regressors)

