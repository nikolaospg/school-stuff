clc
clear
close all


%%Initialising variables
print_flag=1;                                  %Set it =0 if you don't want to print the plots

%Noise variables. Change them to change the noise of the x measurement
n=@(t,n0,f)(n0*sin(2*pi*f*t));

n0=0.15;      %Change the value in order to change the amplitude of the noise .    
f=20;   %Change the value in order to change the frequency of the noise.
%Finished with the Noise variables

%Variables about the sampling
time_step=0.1;
time_limit=50;
time_vec=0:time_step:time_limit;                      %The sampling moments
time_vec=time_vec';
%Finished with the variables about the sampling

%Variables of the algorithm.
thetaM=3;                                     %The gain of the error (only on Series-Parallel)
a=2;
b=1;
gamma1=1;
gamma2=1;
state0=[0 0 0 0]';                          %Initialising the initial state
u=@(t)(5*sin(3*t));
%Finished with the variables of the algorithm
%%Finished initialising variables.



%%Simulating for the Parallel structure, no noise.
structure=0; %For a Parallel simulation, we set the variable =0. 
eq_handle_Par=@(t,state)(dyn_eq2(t,state, structure, u, gamma1, gamma2, a, b, thetaM, n, 0, f));
[t ,state]=ode45(eq_handle_Par, time_vec, state0);
states_parallel=state;
%%Finished Simulating for the Parallel structure.


%%Simulating for the Series-Parallel structure, no noise.
structure=1; %For a Series-Parallel simulation, we set structure =1.
eq_handle=@(t,state)(dyn_eq2(t,state, structure, u, gamma1, gamma2, a, b, thetaM));
eq_handle_SP=@(t,state)(dyn_eq2(t,state, structure, u, gamma1, gamma2, a, b, thetaM, n, 0, f));
[t ,state]=ode45(eq_handle_SP, time_vec, state0);
states_SP=state;
%%Finished Simulating for the Series-Parallel structure.


%%Printing Plots
if(print_flag==1)
    
%For the a estimate
title=sprintf("The a coefficient estimate (no noise), gamma1=%d, gamma2=%d",gamma1,gamma2);
figure("Name",title)
plot(states_parallel(:,1));
hold on
plot(states_SP(:,1));
legend("Parallel Estimation","SP Estimation")
%Finished with the a coefficient estimate

%For  the b estimate
title=sprintf("The b coefficient estimate (no noise), gamma1=%d, gamma2=%d",gamma1,gamma2);
figure("Name",title)
plot(states_parallel(:,2));
hold on
plot(states_SP(:,2));
legend("Parallel Estimation","SP Estimation")
%Finished with the b coefficient estimate

%For the x Parallel estimate
title=sprintf("The Parallel estimate for x (no noise), gamma1=%d, gamma2=%d",gamma1,gamma2);
figure("Name",title)
plot(states_parallel(:,3));
hold on
plot(states_parallel(:,4));
legend("Parallel x Estimation","Actual x values")

title=sprintf("The error of the parallel estimation (no noise), gamma1=%d, gamma2=%d",gamma1,gamma2);
figure("Name",title)
plot(states_parallel(:,3)- states_parallel(:,4));
%Finished with the x Parallel estimate

%For the x SP estimate
title=sprintf("The SP estimate for x (no noise), gamma1=%d, gamma2=%d",gamma1,gamma2);
figure("Name",title)
plot(states_SP(:,3));
hold on
plot(states_SP(:,4));
legend("SP x Estimation","Actual x values")

title=sprintf("The error of the SP estimation (no noise), gamma1=%d, gamma2=%d",gamma1,gamma2);
figure("Name",title)
plot(states_SP(:,3)- states_SP(:,4));
%Finished with the x SP estimate

end
%%Finished Printing Plots




%%%ADDING NOISE%%%
%%Doing the simulations for the Parallel structure
structure=0;
eq_handle_Par=@(t,state)(dyn_eq2(t,state, structure, u, gamma1, gamma2, a, b, thetaM, n, n0, f));
[t ,state]=ode45(eq_handle_Par, time_vec, state0);
states_par_noise=state;
%%Finished Doing the simulations for the Parallel structure.

%%Doing the simulations for the SP structure
structure=1;
eq_handle_SP=@(t,state)(dyn_eq2(t,state, structure, u, gamma1, gamma2, a, b, thetaM, n, n0, f));
[t ,state]=ode45(eq_handle_SP, time_vec, state0);
states_SP_noise=state;
%%Finished Doing the simulations for the SP structure.


%%Doing the plots with the noise
if(print_flag==1)
    
%Plotting for the a coefficient estimates
title=sprintf("The a coefficient estimate with noise, gamma1=%d, gamma2=%d",gamma1,gamma2);
figure("Name",title)
plot(states_par_noise(:,1));
hold on
plot(states_SP_noise(:,1));
legend("The Parallel estimation","The SP estimation")
%Finished with the a coefficient

%Plotting for the b coefficient estimates
title=sprintf("The b coefficient estimate with noise, gamma1=%d, gamma2=%d",gamma1,gamma2);
figure("Name",title)
plot(states_par_noise(:,2));
hold on
plot(states_SP_noise(:,2));
legend("The Parallel estimation","The SP estimation")
end
%Finished with the b coefficient

%Plotting the x Parallel estimate
title=sprintf("The Parallel estimate for x, with noise, gamma1=%d, gamma2=%d",gamma1,gamma2);
figure("Name",title)
plot(states_par_noise(:,3));
hold on
plot(states_parallel(:,4));
legend("Parallel x Estimation","Actual x values")

title=sprintf("The error of the parallel estimation, with noise, gamma1=%d, gamma2=%d",gamma1,gamma2);
figure("Name",title)
plot(states_par_noise(:,3)- states_parallel(:,4));
%Finished with the x Parallel estimate

%Plotting the x SP estimate
title=sprintf("The SP estimate for x, with noise, gamma1=%d, gamma2=%d",gamma1,gamma2);
figure("Name",title)
plot(states_SP_noise(:,3));
hold on
plot(states_SP(:,4));
legend("SP x Estimation","Actual x values")

title=sprintf("The error of the SP estimation, with noise, gamma1=%d, gamma2=%d",gamma1,gamma2);
figure("Name",title)
plot(states_SP_noise(:,3)- states_SP(:,4));
%Finished with the x SP estimate
%%Finished doing the plots

%%%Finished with the noise and the algorithm%%%

