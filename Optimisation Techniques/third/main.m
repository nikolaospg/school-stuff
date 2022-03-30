clc
clear
close all

%This is the main script I use to run the results for the projection method, with steepest descent

%Function handles
f=@(x)(0.5*x(1)^2 + 2*x(2)^2);
gradf=@(x)[ x(1);4*x(2)];

%Parameters for the algorithm
x0=[17;-5];
e=0.01;
gamma=0.1;
s=0.5;
x1_limits=[-15, 15];
x2_limits=[-20, 12];

[x_values, f_values, grad_values]=SD_projection(f, gradf, x0, e, gamma, s, x1_limits, x2_limits);

%Parameters for the plots
grid_vals=-25:1:25;
result_flag=1;
make_plots(f, grid_vals, result_flag, x_values, f_values, x1_limits, x2_limits)

