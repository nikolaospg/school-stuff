%This script involves reading the data (Cases/Deaths) for one country and trying to fit
%a distribution object to the data

% We will work with Italy (67) 
clc
clear
close all
%Getting our data. Please take a Look at our Group39Exe1Fun1 if you want to comprehend what the function does.
[Cases_final, Deaths_final,Cases_before, Deaths_before, populations ]=read_data('Covid19Confirmed.xlsx', 'Covid19Deaths.xlsx', 67);
Cases=Cases_final(2:end);       %The first index corresponds to the id of the country, therefore I pick the data from the second index onwards
Deaths=Deaths_final(2:end);     %The first index corresponds to the id of the country, therefore I pick the data from the second index onwards

figure_num=1;
cases_norm=Cases/sum(Cases);
deaths_norm=Deaths/sum(Deaths);
%Finished getting the data



%We will be trying the: exponential, gamma, normal, logistic, rayleigh and
%loglogistic distributions. First We calculate the pdf vector
%Then We plot the pd functions We have calculated on a common histogram
pd_exp_cases=fitdist((1:length(Cases))','exponential', 'frequency', Cases);
exp_pdf_cases=pdf(pd_exp_cases,1:length(Cases));              %Command to calculate the pdf, in order to print it on a histogram.

pd_gamma_cases=fitdist((1:length(Cases))','gamma', 'frequency', Cases);
gamma_pdf_cases=pdf(pd_gamma_cases,1:length(Cases));  

pd_normal_cases=fitdist((1:length(Cases))','normal', 'frequency', Cases);
normal_pdf_cases=pdf(pd_normal_cases,1:length(Cases));

pd_logistic_cases=fitdist((1:length(Cases))','logistic', 'frequency', Cases);
logistic_pdf_cases=pdf(pd_logistic_cases,1:length(Cases));

pd_rayleigh_cases=fitdist((1:length(Cases))','rayleigh', 'frequency', Cases);
rayleigh_pdf_cases=pdf(pd_rayleigh_cases,1:length(Cases));

pd_loglogistic_cases=fitdist((1:length(Cases))','loglogistic', 'frequency', Cases);
loglogistic_pdf_cases=pdf(pd_loglogistic_cases,1:length(Cases));

%First printing the histogram
figure(figure_num)
figure_num=figure_num+1;
bar(cases_norm)
hold on
plot(exp_pdf_cases)
plot(gamma_pdf_cases)
plot(normal_pdf_cases)
plot(logistic_pdf_cases)
plot(rayleigh_pdf_cases)
plot(loglogistic_pdf_cases)
title('The Cases histogram with the fitted distributions')
legend('The cases histogram','The exponential distribution','The gamma distribution', 'The normal distribution','The logistic distribution',...
    'The rayleigh distribution','The loglogistic distribution')
%Finished printing the histogram


%To judge on the goodness of fit, we decided to use the mean square difference, between the values 
% we get from the fitted distribution and the according values we get from the sample(which is normalised!!!)
% Due to the fact that it is normalised, it is important for us to be careful with the decimal numbers (we actually
% use the exponential notation), to look at differences between the MSE values.
% If one distribution gives us a smaller MSE then we know that it "the difference" between the distribution
% and the sample is less and therefore the data in the sample is described with a better way.
distribution_array=[exp_pdf_cases' gamma_pdf_cases' normal_pdf_cases' logistic_pdf_cases' rayleigh_pdf_cases' loglogistic_pdf_cases'];
mse_cases=distr_MSE(cases_norm, distribution_array);
%Finished Calculating the MSE
%Finished working with the Cases

%Now i Will work with the daily deaths.
pd_exp_deaths=fitdist((1:length(Deaths))','exponential', 'frequency', Deaths);
exp_pdf_deaths=pdf(pd_exp_deaths,1:length(Deaths));              %Command to calculate the pdf, in order to print it on a histogram.

pd_gamma_deaths=fitdist((1:length(Deaths))','gamma', 'frequency', Deaths);
gamma_pdf_deaths=pdf(pd_gamma_deaths,1:length(Deaths));  

pd_normal_deaths=fitdist((1:length(Deaths))','normal', 'frequency', Deaths);
normal_pdf_deaths=pdf(pd_normal_deaths,1:length(Deaths));

pd_logistic_deaths=fitdist((1:length(Deaths))','logistic', 'frequency', Deaths);
logistic_pdf_deaths=pdf(pd_logistic_deaths,1:length(Deaths));

pd_rayleigh_deaths=fitdist((1:length(Deaths))','rayleigh', 'frequency', Deaths);
rayleigh_pdf_deaths=pdf(pd_rayleigh_deaths,1:length(Deaths));

pd_loglogistic_deaths=fitdist((1:length(Deaths))','loglogistic', 'frequency', Deaths);
loglogistic_pdf_deaths=pdf(pd_loglogistic_deaths,1:length(Deaths));

%First printing the histogram
figure(figure_num)
figure_num=figure_num+1;
bar(deaths_norm)
hold on
plot(exp_pdf_deaths)
plot(gamma_pdf_deaths)
plot(normal_pdf_deaths)
plot(logistic_pdf_deaths)
plot(rayleigh_pdf_deaths)
plot(loglogistic_pdf_deaths)
title('The Deaths histogram with the fitted distributions')
legend('The deaths histogram','The exponential distribution','The gamma distribution', 'The normal distribution','The logistic distribution',...
    'The rayleigh distribution','The loglogistic distribution')
%Finished printing the histogram

%Now Calculating the MSE
distribution_array=[exp_pdf_deaths' gamma_pdf_deaths' normal_pdf_deaths' logistic_pdf_deaths' rayleigh_pdf_deaths' loglogistic_pdf_deaths'];
mse_deaths=distr_MSE(deaths_norm, distribution_array);
%Finished Calculating the MSE
%Finished working with the Deaths

%Now it is time to look at the mse values and choose the distributions:
%Making my prints
fprintf('Below are the mse values for the cases and deaths.\n\nWe have the 1)exponential,  2)gamma,  3)normal,  4)logistic,  5)rayleigh and  6)loglogistic distributions:\n\n');
format short g;
format compact;
fprintf('For the cases:');
disp(mse_cases)
fprintf('The index of the distribution with the minimum mse for cases is %d\n\n',find(mse_cases==(min(mse_cases))));
fprintf('For the deaths:');
disp(mse_deaths)
fprintf('The index of the distribution with the minimum mse for deaths is %d\n\n',find(mse_deaths==(min(mse_deaths))));
fprintf('The index of the distribution with the minimum value of added mean square errors is %d\n\n',find((mse_deaths+mse_cases)==(min(mse_deaths+mse_cases))));


%Conclusion: By looking at the results, we can see that the distribution which best describes the daily Cases/Deaths
% in the way asked by the exercise (for Italy) is non other than the loglogistic distribution. It gives us the minimum 
% mse both for the cases and for the deaths, so both of these datasets can be described better using the same 
% distribution.
% Another thing that we can comment is that there are other distribution who do give us great results too (e.g.
% the gamma distribution). In Italy, the loglogistic is better but not by a long margin, so there is a chance that 
% another distribution might actually do better for some other county.



