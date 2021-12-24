% This script tests the results of the estimation for a lot of pole choices. This is a way to 
% apply the trial and error idea and create an opinion on a suitable pole choice.

clc
clear

fprintf('The process takes less than a couple of minutes...\n')
% Initialising the given parameters for the simulation
m=15;
b=0.2;
k=2;
u=@(t) (5*sin(2*t) +10.5);        %I use a function handle to easily manipulate the input (force u).
time_vec=0:0.1:10;                    
x0=[0 0];       
%Finished with the parameter initialisation

%Now simulating. I will call the ode function, and create the function handle that is needed
eq_handle=@(t,state)dynamic_eq(t, state, u, k, m, b);
%The simulation is done by solving the differential equations, with the proper parameters and initial state.
[t, state]=ode15s(eq_handle, time_vec, x0);    
inputs=u(time_vec);
%Solved the equations.


% In the first test (the following loop), I only change the value of one pole. Due to the lower complexity, I set the 
% step between two consecutive iterations to be -0.1. We begin at -0.1 and finish at -100.
% Due to the symmetry, there is no difference in changing the first or the second pole.
pole1=-0.1;
count=1;
error_sum=zeros(1000,1);

pole2=-5;           %I apply a constant value to the second pole, in order to see how the difference of one pole affects me
for i=1:1000
        lamda_coeffs=[1 -(pole1+pole2) pole1*pole2];            %The coefficients of the lamda polynomial
        [theta_star, theta]=least_squares_est(inputs, state(:,1),time_vec,lamda_coeffs);
        m_error=abs((theta(3)-m)/m);
        k_error=abs((theta(2)-k)/k);
        b_error=abs((theta(1)-b)/b);
        error_sum(count)=m_error+k_error+b_error;
        count=count+1;
        pole1=pole1-0.1;
end
figure(1)
plot(0.1:0.1:100,error_sum)
title('The results of the first test (pole2=-5 const, pole1 changes)')
ylabel('Sum of normalised errors')
%Finished with the first test


% In the second (double) for loop, I test how the error changes when changing both of the poles. Initially they both 
% have values equal to -0.1
% With the value of the first pole constant, I change the value of the second one and once it becomes 
% equal to -100, I reset the second one to -0.1 and decrease the first one by 0.1 .
% The process stops when both of them are equal to -100.
count=1;
error_sum2=zeros(10000,1);
inputs=u(time_vec);

pole1=-0.1;
pole2=-0.1;
for i=1:100
    pole2=-0.1;
    for j=1:100
        lamda_coeffs=[1 -(pole1+pole2) pole1*pole2];            %The coefficients of the lamda polynomial
        [theta_star, theta]=least_squares_est(inputs, state(:,1),time_vec,lamda_coeffs);
        m_error=abs((theta(3)-m)/m);
        k_error=abs((theta(2)-k)/k);
        b_error=abs((theta(1)-b)/b);
        error_sum2(count)=m_error+k_error+b_error;
        count=count+1;
        pole2=pole2-1;
    end
    pole1=pole1-1;
end
figure(2)
plot(error_sum2)
title('The results of the second test (changing both of the poles)')
ylabel('Sum of normalised errors')
%Finished with the second test too

    
