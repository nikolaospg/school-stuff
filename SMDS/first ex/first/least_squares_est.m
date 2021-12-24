%This is the implementation of the least squares algorithm, in this specific case.
% Arguments:
%       1) inputs->                     The values of the system input (the ones we used while simulating)
%       2) outputs->                  The values we got from the simulation, for the system output.
%       3) time_vec->                The vector of the time moments when we took samples by measuring.
%       4) lamda_coeffs->         The coefficients of the lamda polynomial.

function [par_est, par_final]=least_squares_est(inputs, outputs, time_vec, lamda_coeffs)

    inputs=inputs(:);               %making sure that these are all column vectors
    outputs=outputs(:);   
    
    % First I will create the filters I need, and then I will filter the timeseries of the measured samples.
    % This is the implementation of the theoretical analysis, specified in the report.
    filt1=tf([-1 0],lamda_coeffs);          %First creating the filters
    filt2=tf(-1, lamda_coeffs);
    filt3=tf(1,lamda_coeffs);
    phi1=lsim(filt1, outputs, time_vec);            %Now filtering the measured values
    phi2=lsim(filt2, outputs, time_vec);
    phi3=lsim(filt3, inputs, time_vec);
    PHI=[phi1 phi2 phi3];                      
    %Finished with the filtering and got the PHI array (each column is a vector with the filtered observated values of
    % a specific element of the regressor vector)
    
    % Now solving the matrix equation, that will give me the estimator vector (theta_star)
    % Then, using this result I easily get the parameters of the system
    PHI_TR=PHI';            %calculating the transpose
    Q=PHI_TR*PHI;
    R=(outputs')*PHI;
    theta_star=R*inv(Q);                %The thera_star estimator vector
    par_est=[theta_star(1:2)+lamda_coeffs(2:end) theta_star(3)]';   
    par_final(3)=1/par_est(3);                          %This parameter is the mass
    par_final(2)=par_est(2)*par_final(3);          % This parameter is the k coefficient
    par_final(1)=par_est(1)*par_final(3);           % This parameter is the b coefficient
    par_final=par_final';
    % Finished estimating the parameters

end