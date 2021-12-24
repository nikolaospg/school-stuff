%This script is similar to wave2_death_predict but also uses a LASSO regressor to check the results.

% clc
clear
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

%Now with the second wave
[Cases_final2, Deaths_final2,~, ~, ~ ]=read_data_2wave('Covid19Confirmed.xlsx', 'Covid19Deaths.xlsx',...
    country_id_vector,0);
%Finished with the second one as well.

%Results from the previous exercise
step_rsq=[0.6538    0.4221; 0.9777    0.5480; 0.3830    0.8348; 0.9593    0.9038; 0.6620    0.9554; 0.9196    0.4463];
step_adjrsq=[0.6428    0.3917; 0.9758    0.4834; 0.3684    0.8284; 0.9584    0.9000; 0.6567    0.9543; 0.9136    0.3761];



%Each iteration corresponds to one country.
for i=1:size(populations,1)
    
    %Working with the first wave
    %As in exercise 7 we normalise the data again.
    Cases1=Cases_final1(i,2:end);
    Deaths1=Deaths_final1(i,2:end);
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
    
    %To estimate the parameters of the DR model we will use the LASSO method. The choice 
    % of the lambda coefficient really was a pain for us. After many trials, we thought that this value is OK.
    % So we chose the lambda based on trials we did.
    % Nevertheless, there could be other ones that fit the user better, according to his needs
    % If the user wants mainly to reduce the dimensionality, then a larger lambda will suit him better,
    % on other cases a smaller lambda might be better.
    
    %We first center the data, to apply the lasso command (centered data). The previous normalisation was not done on these vectors
    % but on the initial datasets, therefore these ones do not necessarily have mean=0.
    % This way I will get the b coefficients for the model on the centered data. Later I will find the b0 to have the model
    % for the non centered data.
    X1_c=normalize(X1,1,'center');               %I use this to make sure that the data is centered (the norm. before was made on the whole deaths)
    Y1_c=normalize(Y1,2,'center');
    b=lasso(X1_c, Y1_c,'lambda',0.1);          
    non_zeros=find(b~=0);
    X1_red=X1(:,non_zeros);
    
    %These are the b values for the centered model. I want to take the b values for the non centered!
    b0=mean(Y1') -mean(X1) *b(:);
    blasso=[b0 b(non_zeros)']';         %This is the b for the whole model
    y_pred1=[ones(size(X1_red,1),1) X1_red]*blasso;
    rsq(i,1)=Rsq(y_pred1, Y1');
    n=length(Y1);
    k=length(b);
    adjrsq(i,1)=adjRsq(y_pred1, Y1', n, k);
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
    X2_red=X2(:,non_zeros);                     %Getting the reduced X data.
    y_pred2=[ones(size(X2_red,1),1) X2_red]*blasso;
    rsq(i,2)=Rsq(y_pred2, Y2');
    n=length(Y2);
    k=length(b);
    adjrsq(i,2)=adjRsq(y_pred2, Y2', n, k);
    %got the predictions
    %Finished with the second wave
end

fprintf('For the countries:\nAustria(8), Belgium(13), Greece(54), Italy(67), Serbia(121). UK(147)\n\nResults on the first wave:\n');
fprintf('Stepwise R^2:');
disp((step_rsq(:,1))');
fprintf('LASSO R^2:');
disp((rsq(:,1))');
fprintf('Stepwise adjR^2:');
disp((step_adjrsq(:,1))');
fprintf('LASSO adjR^2:');
disp((adjrsq(:,1))');
fprintf('\n\nResults one the second wave:\n');
fprintf('Stepwise R^2:');
disp((step_rsq(:,2))');
fprintf('LASSO R^2:');
disp((rsq(:,2))');
fprintf('Stepwise adjR^2:');
disp((step_adjrsq(:,2))');
fprintf('LASSO adjR^2:');
disp((adjrsq(:,2))');


%Answers

% 1) As for the FITTING in the first wave, we can observe it by seeing the MSE of the two models, or the R^2 
% (the comparisons are equivalent). To judge on the better model on general terms the adjR^2 is better.
% So, looking at the first wave, we see that the R^2 of the models are equivalent. The lasso is a little better
% for the case of Greece, while the stepwise is better for UK (an R^2 is better when it is larger). In terms of 
% fitting the two models seem similar.
% One more thing worth noticing is that the adjR^2 seems lower(worse) for the LASSO model. We guess
% that It is probably due to the fact that these models are a little more complex.

% 2) As for the second wave, the R^2 of the LASSO seem actually better than those of the stepwise. In most
% of the countries the difference is not that large, but for UK the LASSO does  better than the stepwise.
% For the adjR^2 we see that the LASSO model continues to do much better in the UK than the stepwise, but
% for the rest of the countries the stepwise seems better (not by a very long margin for the most)

%Conclusions
%   From this exercise we made the conclusion that there is no model that can always be regarded as the optimal
% Depending on the data and many other factors, the analyst could try many models and judge which suits him best
% Also, we see by making tests that the LASSO method relies heavily on its parameters and especially the lambda.
% The way we chose the lambda parameter was a total beginners way, where we just tested some values and 
% chose one that seemed like a good choice. We guess there are also other more advanced methods so that we can get 
% an 'optimal' lambda, based on what we want. Maybe then, the LASSO would seem better than the stepwise 
% for more countries.

%We also saw that on general the models that managed to describe the data of the first wave well enough 
% generally did not manage to describe the data of the second model that well. But on some cases the ones that
% were not very good on the first wave actually did better on the second one. There was no clear pattern that
% one could actually describe for all of the countries, regarding how the model behaved on the validation phase and 
% we think that the best choice is to just study every country on its own and make separate choices and conclusions.
    


