%The following function takes as arguments a sample (should be normalised), and an array with each column
%representing a distribution function. It calculates a vector containing the MSE for each distribution and returns it to us.
%BEWARE. EACH DISTRIBUTION IS REPRESENTED BY A COLUMN, NOT BY A ROW
%e.g. distribution_vector=[exp_pdf_cases' gamma_pdf_cases' normal_pdf_cases' logistic_pdf_cases' rayleigh_pdf_cases' loglogistic_pdf_cases'];
%        mse_cases=Group39Exe1Fun2(cases_norm, distribution_vector)

function MSE=distr_MSE(sample_norm, distribution_array)
    n=size(distribution_array,2);
    sample_norm=sample_norm(:);
    %Each iteration corresponds to one distribution column
    for i=1:n
        distribution_vector=distribution_array(:,i);
        square_diffs=(sample_norm-distribution_vector).^2;
        MSE(i)=mean(square_diffs);
    end
end
