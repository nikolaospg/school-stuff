clc
clear
close all

%%Initialising variables
print_flag=1;                                  %Set it =0 if you don't want to print the plots

%Variables about the sampling
time_step=0.1;
time_limit=100;
time_vec=0:time_step:time_limit;                      %The sampling moments
time_vec=time_vec';
%Finished with the variables about the sampling

%Variables of the algorithm.
A=[-0.25 3; -5 -1];
B=[1;2.2];
gamma1=1;
gamma2=1;
state0=[0 0 0 0 0 0 0 0 0 0]';
u=@(t)(10*sin(2*t) +5*sin(7.5*t)) ;
%Finished with the variables of the algorithm
%%Finished initialising variables



%%Simulating the system
eq_handle=@(t,state)(dyn_eq3(t,state,u, gamma1, gamma2, A, B));
[t, state]=ode45( eq_handle, time_vec, state0);
a11_est=state(:,1);
a12_est=state(:,2);
a21_est=state(:,3);
a22_est=state(:,4);
b1_est=state(:,5);
b2_est=state(:,6);
x1_est=state(:,7);
x2_est=state(:,8);
x1=state(:,9);
x2=state(:,10);
%%Finished simulating the system



%%Making the plots
if(print_flag==1)
title=sprintf("The a11 coefficient estimate, gamma1=%d, gamma2=%d",gamma1,gamma2);
figure("Name",title)
plot(time_vec, a11_est);
title=sprintf("The a12 coefficient estimate, gamma1=%d, gamma2=%d",gamma1,gamma2);
figure("Name",title)
plot(time_vec,a12_est);

title=sprintf("The a21 coefficient estimate, gamma1=%d, gamma2=%d",gamma1,gamma2);
figure("Name",title)
plot(time_vec,a21_est);

title=sprintf("The a22 coefficient estimate, gamma1=%d, gamma2=%d",gamma1,gamma2);
figure("Name",title)
plot(time_vec,a22_est);
    
title=sprintf("The b1 coefficient estimate, gamma1=%d, gamma2=%d",gamma1,gamma2);
figure("Name",title)
plot(time_vec,b1_est);

title=sprintf("The b2 coefficient estimate, gamma1=%d, gamma2=%d",gamma1,gamma2);
figure("Name",title)
plot(time_vec,b2_est);

title=sprintf("The x1 coefficients, gamma1=%d, gamma2=%d",gamma1,gamma2);
figure("Name",title)
plot(time_vec,x1_est)
hold on
plot(time_vec,x1)
legend("The estimation","The actual values")

title=sprintf("The x2 coefficients, gamma1=%d, gamma2=%d",gamma1,gamma2);
figure("Name",title)
plot(time_vec,x2_est)
hold on
plot(time_vec,x2)
legend("The estimation","The actual values")

title=sprintf("The x1 coefficient error (x1-x1_est), gamma1=%d, gamma2=%d",gamma1,gamma2);
figure("Name",title)
plot(time_vec,x1-x1_est);

title=sprintf("The x2 coefficient error (x2-x2_est), gamma1=%d, gamma2=%d",gamma1,gamma2);
figure("Name",title)
plot(time_vec,x2-x2_est);
end
%%Finished making the plots

