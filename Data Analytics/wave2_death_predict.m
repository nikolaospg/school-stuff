%This script includes models predicting the deaths for both the first and the second wave.
%We first use stepwise regression to fit the model on the first wave and then use the learned model
%to make prediction on the second wave

clc
clear
close all

Rsq = @(ypred,y) 1-sum((ypred-y).^2)/sum((y-mean(y)).^2);
adjRsq = @(ypred,y,n,k) ( 1 - (n-1)/(n-1-k)*sum((ypred-y).^2)/sum((y-mean(y)).^2));     %Function handle for the adjRsq
%We chose to work with the countries:
%   Austria           (8)
%   Belgium          (13)
%   Greece           (54)
%   Italy               (67)    (the initial one)
%   Serbia            (121)
%   UK                  (147)

%Getting the first wave data
country_id_vector=[8 13 54 67 121 147];
[Cases_final1, Deaths_final1,~, ~, populations ]=read_data('Covid19Confirmed.xlsx', 'Covid19Deaths.xlsx',...
    country_id_vector);
global figure_num;          %Global because I have to create the figures in the function.
figure_num=0;
%Finished with the first wave data

%Now with the second wave. Please read the documentation of our function to see how we chose the second wave.
[Cases_final2, Deaths_final2,~, ~, ~ ]=read_data_2wave('Covid19Confirmed.xlsx', 'Covid19Deaths.xlsx',...
    country_id_vector,1);
%Finished with the second one as well.

%In order to combat the problem with the different order of values in the two waves,
    % we decided to normalise the data with the sum of the total elements, for the cases
    % and for the deaths (the common normalisation with the mean and the standard deviation
    % We did this thing in every country


%Each iteration corresponds to one country
for i=1:size(populations,1)
    
    %Working with the first wave
    Cases1=Cases_final1(i,2:end);           %The first index corresponds to the id of the country, therefore I pick the data from the second index onwards
    Deaths1=Deaths_final1(i,2:end);         %The first index corresponds to the id of the country, therefore I pick the data from the second index onwards
    Cases1_norm=normalize(Cases1);              %Doing the normalisation.           
    Deaths1_norm=normalize(Deaths1);
    X1=zeros(20, length(Deaths1)-19);               %Creating the X1 array with the regressors
    for j=0:19
        reg_temp=Cases1_norm(1:end-j);          
        reg_temp=reg_temp(20-j:end);
        X1(j+1,:)=reg_temp;
    end
    X1=X1';
    Y1=Deaths1_norm(20:end);
    
    
    %Fitting the model. We decided to use the stepwise for this purpose (this is what we regarded as "optimal"
    %from exercise 6 because it gives large adjR^2 and reduces the dimensionality).
    [~, ~, ~ , model2temp]=stepwisefit( X1,Y1');       %we use this command to get the model2temp vector, which tells us the variables that we should use.
    X_red1=X1(:,model2temp);
    model=fitlm(X_red1,Y1);                                     %I got the model.
    adj_rsq_array(i,1)=model.Rsquared.Adjusted;         %In the first column We will have the adjR^2 on the first wave
    rsq_array(i,1)=model.Rsquared.Ordinary;
    %Finished with the first wave
    
    %Now with the second wave. We will get the data, normalise, and then make predictions.
    %Getting the data
    Cases2=Cases_final2(i,2:end);
    Deaths2=Deaths_final2(i,2:end);
    X2=zeros(20, length(Deaths2)-19);
    Cases2_norm=normalize(Cases2);
    Deaths2_norm=normalize(Cases2);
    for j=0:19
        reg_temp=Cases2_norm(1:end-j);          %getting the temp regressor.
        reg_temp=reg_temp(20-j:end);
        X2(j+1,:)=reg_temp;
    end
    X2=X2';
    Y2=Deaths2_norm(20:end);
    %Finished getting the data
    %Finished normalising
    
    %Now to make predictions.
    X_red2=X2(:,model2temp);           %Applying the DR on the regressor data from the second wave
    y_pred=predict(model,X_red2);       %Using the model with the parameters estimated from the first wave, we predict with the regressors of the second.
    y_pred_array(i,:)=y_pred;           %Predicting using the model from the first wave, on data of cases from the second
    
    k=length(table2array(model.Coefficients(:,1)))-1
    n=length(Y2);
    adj_rsq_array(i,2)=adjRsq(y_pred, Y2', n, k);
    rsq_array(i,2)=Rsq(y_pred, Y2');
    %got the predictions
    %Finished with the second wave
    clc
end

%Printing the results of the comparison of the behaviour of the model fitted on the normalised data
% for the 2 different waves
fprintf('Below lie the R^2 and adjR^2 for both waves for the countries:\nAustria(8), Belgium(13), Greece(54), Italy(67), Serbia(121). UK(147)\n');
fprintf('\nR^2:\n');
fprintf('1st wave:   ');
disp((rsq_array(:,1))');
fprintf('2nd wave:   ');
disp((rsq_array(:,2))');
fprintf('\nadjR^2:\n');
fprintf('1st wave:   ');
disp((adj_rsq_array(:,1))');
fprintf('2nd wave:   ');
disp((adj_rsq_array(:,2))');

%Some comments on how the models generally behave can be seen on exercise 8.



