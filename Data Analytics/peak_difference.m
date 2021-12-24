%In this script, I find the days where the daily deaths and the daily cases peak in each country
%I later apply hypothesis test to check on whether the difference between the two values is actually 14 days
%using parametric and non parametric ways


clc
clear
close all
%We remind you that our countries are:
%   Austria           (8)
%   Belgium          (13)
%   Finland            (47)
%   France            (48)
%   Germany        (52)
%   Greece           (54)
%   Italy               (67)    (the initial one)
%   Netherlands   (97)
%   Norway          (103)
%   Portugal         (113)
%   Serbia            (121)
%   UK                  (147)

%Getting the maxima
country_id_vector=[8 13 47 48 52 54 67 97 103 113 121 147];
cases_maxima=get_peaks(country_id_vector,1);
deaths_maxima=get_peaks(country_id_vector,2);
days_diff=deaths_maxima-cases_maxima;
%Finished getting the maxima

%Now doing the tests.I will find the CI for the mean.
% If the CI contains the hypothesized day difference then the hypothesis cannot be rejected.
% But if it does not, then I will reject the fact that the day difference is equal to the one stated in the exercise.

%Parametric
[~,~,ci_par,~]=ttest(days_diff, 14);
hypothesized_difference=14;
fprintf('The parametric CI is :\n');
disp(ci_par);
if(hypothesized_difference>ci_par(1) & hypothesized_difference<ci_par(2))
    fprintf('The parametric CI contains the difference, therefore we cannot reject the hypothesis that the difference is the one stated(14)\n');
else
    fprintf('The parametric CI does not contain the difference, therefore we will reject the fact that the difference is the one stated(14) \n');
end
%Finished with the parametric

%Bootstrap
B=1000;                     %The Bootstrap samples to be created
boot_estimators=bootstrp(B, @mean, days_diff);          %Creating B bootstrap samples from the days_diff sample, with the mean as the estimator function.
CI_boot=[prctile(boot_estimators,2.5) prctile(boot_estimators,97.5)];
fprintf('The bootstrap CI is :\n');
disp(CI_boot);
if(hypothesized_difference>CI_boot(1) & hypothesized_difference<CI_boot(2))
    fprintf('The bootstrap CI contains the difference, therefore I cannot reject the hypothesis that the difference is the one stated(14)\n');
else
    fprintf('The bootstrap CI does not contain the difference, therefore we will reject the fact that the difference is the one stated(14) \n');
end
%Finished with the bootstrap

fprintf('\nThe day differences we observe in:\nAustria (8), Belgium(13), Greece(54), Italy(67), Serbia(121), UK(147) are:\n');
fprintf('\nAu=%d, Bel=%d, Gr=%d, It=%d, Ser=%d, Uk=%d\n', days_diff(1), days_diff(2), days_diff(6), days_diff(7), days_diff(11), days_diff(12))
fprintf('\nThese values are useful for a comparison with Exercise 4\n')
