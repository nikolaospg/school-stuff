%This is the function that helped us create the subplots with the diagnostic scatters.
%Inputs:   1) fitted_values -> Array where every row represends the fitted values by the OLS 
%       simple linear model for that specific tau
%               2) residuals_norm-> The normalised residuals we got from this model
%               3) current_id-> The id of the country for which we print the subplots
%               4)  r_squared->     A vector containing the R^2 values for the various tau.

%   In each subplot the title states the county id, the tau value, the R^2 coefficients but also the number of points
%(in case someone wants to count the ones that are over the statistical importance limits for alpha=0.05 test)
function scatter_plot(fitted_values, residuals_norm, current_id, r_squared, adj_squared)
   
%Each iteration corresponds to one tau value
    for i=1:20
        
        %In the beginning We get the rows of the fitted and residuals arrays, and also we get rid of the zeroes in the end
        fitted_vector=fitted_values(i,:);
        residuals_vector=residuals_norm(i,:);
        fitted_last_non_zero=find(fitted_vector~=0,1,'last');
        if(~isempty(fitted_last_non_zero))
            fitted_vector=fitted_vector(1:fitted_last_non_zero);
            residuals_vector=residuals_vector(1:fitted_last_non_zero);
        end
        %Finished getting the fitted and residuals vectors
        
        %Now the subplot commands
        subplot(4,5,i)
        scatter(fitted_vector, residuals_vector);
        title(sprintf('Id=%d, tau=%d, pts=%d, R2=%.2f', current_id, i-1, fitted_last_non_zero, r_squared(i)));
        hold on
        xlabel('fitted values');
        ylabel('Res. normalised');
        plot( [min(min(fitted_vector),0) max(max(fitted_vector),0)], [1.96 1.96]);
        plot( [min(min(fitted_vector),0) max(max(fitted_vector),0)], [-1.96 -1.96]);
        %Finished with the current subplot
    end
end