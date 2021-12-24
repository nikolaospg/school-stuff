clc
clear
close all

%%Initialising variables
print_flag=1;                                  %Set it =0 if you don't want to print the plots

%Variables regarding the sampling
time_step=0.1;
time_limit=200;
time_vec=0:time_step:time_limit;                      %The sampling moments
time_vec=time_vec';
%Finished with the variables regarding the sampling

%Variables regarding the algorithm
lambda=1;                                     %The parameter of the filter
a=2;
b=1;
gamma=10;
state0=[-lambda 0 0 0 0 0]';        %Initialising the first state to 0.
u=@(t)(5*sin(3*t));
%Finished with the algorithm variables.
%%Finished initialising the variables.



%%Simulating the system
eq_handle=@(t,state)(diff_eqs(t, state, u, gamma, lambda, a, b));
[t ,state]=ode45(eq_handle, time_vec, state0);              %Solving the differential equations

%Getting the results
a_hat=state(:,1)+lambda;
b_hat=state(:,2);
zeta1=state(:,3);
zeta2=state(:,4);
y=state(:,5);
y_hat=state(:,6);
%Finished getting the results
%%Finished simulating the system


%%Making the plots
title=sprintf("The estimated parameters, lambda=%d, gamma=%d",lambda, gamma);
figure("Name",title)
plot(time_vec,a_hat)
hold on
plot(time_vec,b_hat)
legend("a estimation", "b estimation")

title2=sprintf("The y plot lambda=%d, gamma=%d",lambda, gamma);
figure("Name", title2)
plot(time_vec,y)
hold on
plot(time_vec,y_hat)
legend("The actual y values","the y\_hat values")

title3=sprintf("The error plot(y-y_hat) lambda=%d, gamma=%d",lambda, gamma);
figure("Name", title3)
plot(time_vec,y-y_hat)
%%Finished with the plots
