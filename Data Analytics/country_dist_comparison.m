%This script involves fitting various distributions to the data of each country and comparing the goodness of the
%fit

clc
clear
close all

%For this exercise we decided to work with the following countries:
%   Austria           (8)
%   Belgium          (13)
%   Finland            (47)
%   France            (48)
%   Germany        (52)
%   Greece           (54)
%   Netherlands   (97)
%   Norway          (103)
%   Portugal         (113)
%   Serbia            (121)
%   UK                  (147)

%Getting the data
country_id_vector=[8 13 47 48 52 54 97 103 113 121 147];
[Cases_final, Deaths_final,Cases_before, Deaths_before, populations ]=read_data('Covid19Confirmed.xlsx', 'Covid19Deaths.xlsx',...
    country_id_vector);
%Finished getting the data


%We will follow a similar process with the first exercise. Please take a look there to comprehend the process.
%We will get vectors that will hold the mse for the Cases and for the Deaths.

%The distribution that best described both the Cases and the Deaths of Italy was the loglogistic.
% Therefore we will use it to the other countries as well and see what results we will get.
% We also gave the user the ability to choose and look at the other distributions that were used on the read_data.m file
% We did this because we were not so sure on whether the loglogistic on its own could describe well the
% other countries. So we worked with the other distributions as well and made comparisons


while(true)
    fprintf("If you only want to study the loglogistic, then choose it.\nWe took the initiative to study the other distributions too, to make better conclusions of the effectiveness of the loglogistic.\n");
    fprintf("To force quit the program before making any test press ctrl+c\n\n");
    prompt = 'Pick one distribution:\n1->exponential\n2->gamma\n3->normal\n4-> logistic\n5->rayleigh\nOther number>loglogistic(standard- best for Italy)  ';
    
    x = input(prompt);
    if(x==1)
        distri_string='exponential';
    elseif(x==2)
        distri_string='gamma';
    elseif(x==3)
        distri_string='normal';
    elseif(x==4)
        distri_string='logistic';
    elseif(x==5)
        distri_string='rayleigh';
    else
        distri_string='loglogistic';
    end

     %Each iteration here corresponds to one country
    for i=1:size(populations,1)
        Cases=Cases_final(i,2:end);         %The first index corresponds to the id of the country, therefore I pick the data from the second index onwards
        Deaths=Deaths_final(i,2:end);      %The first index corresponds to the id of the country, therefore I pick the data from the second index onwards
        cases_norm=Cases/sum(Cases);
        deaths_norm=Deaths/sum(Deaths);

        %Working with the daily cases:
        pd_cases=fitdist((1:length(Cases))',distri_string, 'frequency', Cases);
        pdf_cases=pdf(pd_cases,1:length(Cases));

        mse_cases(i)=distr_MSE(cases_norm, pdf_cases');
        %Finished working with the daily cases

        %Now working with the daily deaths:
        pd_deaths=fitdist((1:length(Deaths))',distri_string, 'frequency', Deaths);
        pdf_deaths=pdf(pd_cases,1:length(Deaths));

        mse_deaths(i)=distr_MSE(deaths_norm, pdf_deaths');
        %Finished with the daily deaths too.
    end

    %Making the prints to the command line
    fprintf('\nThe %s distribution is used for both deaths and cases:\n\n', distri_string);
    fprintf('Below are the mse values for the cases and deaths for the countries\n\n');
    fprintf('8) Austria, 13) Belgium, 47) Finland, 48) France, 52) Germany, 54) Greece, 97) Netherlands, 103) Norway, 113) Portugal, 121) Serbia, 147) UK\n\n');
    format compact;

    fprintf('For the cases:');
    disp(mse_cases)

    fprintf('\nFor the deaths:');
    disp(mse_deaths)

    [mse_cases sorted_indices]=sort(mse_cases);
    sorted_id_cases=country_id_vector(sorted_indices);
    fprintf('\nThe id values of the countries, sorted based on the least cases MSE :\n');               %This is for the ranking you ask for in the exercise.
    disp(sorted_id_cases)

    [mse_deaths sorted_indices]=sort(mse_deaths);
    sorted_id_deaths=country_id_vector(sorted_indices);
    fprintf('\nThe id values of the countries, sorted based on the least deaths MSE :\n');               %This is for the ranking you ask for in the exercise.
    disp(sorted_id_deaths)

    fprintf('\nThe mean MSE for the Cases is %e and for the deaths %e  (%s)\n',mean(mse_cases), mean(mse_deaths), distri_string)
    %Finished with the prints
    
    %The following lines are used to judge whether to try another distribution or not
    prompt='\nTest another one?\n1-> Yes\nOther number-> No  ';
    z = input(prompt);
    if (z==1)
        prompt='\nWould you like to clear the console?\n1-> Yes\nOther number-> No  ';
        y= input(prompt);
        if (y==1)
            clc
        end
    else
        break
    end
end
    %Finished with the prints
    
% Comments on the results:
%   1) By testing on the distributions we had from before (6 of them) we see that the log logistic continues to be 
% the distribution that actually describes the Cases and the deaths for the other european countries in the best way
% That is because the mean MSE calculated is the least for both the Cases and the Deaths.
% Surely, there are some values that are  quite large (e.g deaths of Finland), but this MSE was large for 
% the other distributions too- so it generally is large but the loglogistic makes it smaller.

%   2) Another thing that we find interesting is that the MSE in countries like Norway and the UK is significantly larger
% for the deaths than it is for the Cases, while for other countries the difference is not that large(albeit it exists). In our opinion
% one reason why the difference between the mse of the cases and the one of the deaths for these countries is so
% large is simply because the Cases are described very well (and the Deaths cannot touch this level of goodness).
% To sum up, the distributions (and the loglogistic which is the one we chose on exercise 1), do not describe the Cases
% and the Deaths in an equally good way. In some countries the difference(like Greece) is not that large,
% but in some others the difference is large (like in Finland)

