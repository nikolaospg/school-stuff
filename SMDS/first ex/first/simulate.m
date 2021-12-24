%This is the script I use to make the simulations for the first system
clc
clear

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

%Making the necessary figures
figure('Name','The position of the mass')
plot(time_vec, state(:,1));
xlabel('time (sec)')
ylabel('position (m)')

figure('Name', 'The velocity of the mass')
plot(time_vec, state(:,2));
xlabel('time (sec)')
ylabel('velocity (m/sec)')

figure('Name', 'Velocity vs position')
plot(state(:,1), state(:,2));
xlabel('position (m)')
ylabel('velocity (m/sec)')
%Finished with the figures


%Now with the parameter estimation. I use the least_squares_est that I wrote specifically for this 
% reason
pole1=-1;           %Easily changing the poles
pole2=-1;
lamda_coeffs=[1 -(pole1+pole2) pole1*pole2] ;           %The coefficients of the lamda polynomial
[theta_star, theta]=least_squares_est(inputs, state(:,1),time_vec,lamda_coeffs);
fprintf('The estimations are:\nMass-> m=%f,\nk coefficient-> k=%f,\nb coefficient-> b=%f\n', theta(3),theta(2),theta(1));
%Finished with the parameter estimation

% I also make calculate some statistics that I use to judge on whether the estimation is 
% appropriate or not. These are the normalised errors of the estimation. 
m_error=abs((theta(3)-m)/m);
k_error=abs((theta(2)-k)/k);
b_error=abs((theta(1)-b)/b);
error_sum=m_error+k_error+b_error;
fprintf('\nThe normalised errors are:\nMass error-> m_error=%f,\nk coefficient error-> k_error=%f,\nb coefficient error-> b_error=%f,\nsum->error_sum=%f\n', m_error,k_error,b_error, error_sum);


