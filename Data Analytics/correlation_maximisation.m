%In these scripts, I take the samples of the daily cases and the daily deaths for each country and I try to find the
%tau (shift parameter) which maximises the correlation of the two empirical distributions. 
%This is done to compare the result with the hypothesis testing done in a different script.

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
%Finished getting the data

    
 %Every iteration of this for loop corresponds to one country
for i=1:size(populations,1)
    Cases=Cases_final(i,2:end);             %The first index corresponds to the id of the country, therefore I pick the data from the second index onwards.
    Deaths=Deaths_final(i,2:end);           %The first index corresponds to the id of the country, therefore I pick the data from the second index onwards
    
    %This for loop is used to calculate the r when the tau<0. 
    count=1;
    for tau=-20:-1
        cases_moved=Cases((-tau+1):end);     %When tau<0, the cases are moved (so we cut some observations from the left)
        new_size=size(cases_moved,2);
        r=corrcoef(cases_moved, Deaths(1:new_size));            %Computing the r between the two samples/signals.
        r=r(2,1);
        r_array(i,count)=r;
        count=count+1;
    end
    %Finished for tau<0
    

    %For the case of tau==0
    r=corrcoef(Cases, Deaths); 
    r=r(2,1);
    r_array(i,count)=r;
    count=count+1;
    %Finished for tau==0
    
    %And finally when tau>0
    for tau=1:20
        deaths_moved=Deaths(tau+1:end);     %When tau<0, the deaths are moved to the right
        new_size=size(deaths_moved,2);
        r=corrcoef(Cases(1:new_size), deaths_moved);            %Computing the r between the two samples/signals.
        r=r(2,1);
        r_array(i,count)=r;
        count=count+1;
    end
    %Finished for tau>0
end
%Finished finding the r_array

%After having calculated the r_array I will find the time of maximisation
for i=1:size(populations,1)
    opt_tau(i)=find(r_array(i,:)==max(r_array(i,:)));
end
opt_tau=opt_tau-21;              %We make this reduction on the tau vector, because the first 20 indices correspond to the negative tau values

fprintf('The Countries we chose are:\nAustria(8), Belgium(13), Greece(54), Italy(67), Serbia(121), Uk(147)\n\n')
fprintf('The tau which maximises the correlation between the Cases and the Deaths for each of the countries chosen for this exercise is:\n')
disp(opt_tau)

%Conclusions and Comparison:
% We were quite impressed when we saw the results. The two methods we tried, the one in Exercise 3 with the differemce
% of the maxima and the one here with the maximum correlation gave us quite similar results on a general basis.

% For the countries of Belgium, Greece, Italy and the UK the two methods gave results which only differed in 1 or 0 days
% while for the case of Belgium, the result was different by  days. This is interesting to us, as we managed to
% use the theory of random variables and statistics with 2 different ways and with both ways we managed to see that 
% how a maximisation of the Cases 'lead' to a maximisation of the Deaths.

%  However, for the Country of Serbia the difference was six whole days, and on ex.4 the tau value is negative!
%  This tells us that even though the results were very nice for the other countries, there
%  might be exceptions on some others. This made us quite curious to find out why it happened.
%  We guess that this might be due to this reason: To write exercise 4 we made the hypothesis that the Cases and Deaths 
%  processes for one country are similar, with a time difference that makes them apart. As one could easily think,
%  this hypothesis cannot always be regarded as true. There also exist imperfections due to trying to describe the 
%  daily Cases/Deaths phenomena with the distributions

%   In the end, an analyst should be aware when using these methods to determine the day difference, because there
%   are countries where deciding on it based solely on these methods cannot be easily done(e.g. Serbia)