%%This is the script I used to design my classical PI controller.
%%It plots the root locus and the step response.
%%It prints the various models (plant, controller, open loop and close loop system) and the step response data.

clc
clear
close all

%% Initialising parameters
c=0.3;          %%This is a parameter value - to be changed

pole1=0.1;
pole2=10;
%% Finished with the parameters


%% Studying the actual system, using the root locus in order to pick a kp gain
plant=zpk( [], [-pole1, -pole2], 25)
controller=zpk( [-c], [0], 1)
L=controller*plant
title1=sprintf("Root Locus for c=%d",c);         %The title of the following Figure
figure("Name",title1)
rlocus(L)
Kp=1;       %Chosen by the root locus plot
%% Finished with the root locus and finished designing the controller (kp,c)

%% Getting the closed loop system and checking whether the specs are satisfied
open_loop=Kp*L
closed_loop=feedback(open_loop, 1, -1)
[response, moments]=step(closed_loop);
title2=sprintf("The step response for c=%d and kp=%d",c,Kp);
figure("Name",title2)
plot(moments,response)
fprintf("\n\nThe results from the step response are:\n")
stepinfo(closed_loop)
%% Finished with the step response and the relevant data
