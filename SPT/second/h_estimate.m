%Function that we use to estimate the h coefficients of an MA system with Giannakis' formula.
% It takes as input the c3_reduced -> The estimation of the cumulants on the upper right quarter of the (tau1,tau2) plane.
% and the q_vec, which is a vector of all the q values, for which I want to estimate the parameters.
% It returns a matrix, where each row corresponds to the coefficients for a specific value of q.

function h_matrix=h_estimate(q_vec, c3_reduced)
    h_matrix=zeros(length(q_vec), max(q_vec)+1);
    reduced_length=length(c3_reduced(:,1));
    for i=1:length(q_vec)
        useful_column=c3_reduced(reduced_length-q_vec(i):reduced_length,q_vec(i)+1);
        denominator=useful_column(end);
        useful_column=flip(useful_column)';
        h_est=useful_column./denominator;
        h_est=[h_est, zeros(1,max(q_vec)-q_vec(i))];
        h_matrix(i,:)=[h_est ];
    end
 
 
 
end