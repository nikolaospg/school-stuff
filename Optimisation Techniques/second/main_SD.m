clc
clear
close all

%Function handles
% f=@(x)((x(1)^3)*(exp(-x(1)^2-x(2)^4)));
% gradf=@(x)[  3*x(1)^2*exp(- x(1)^2 - x(2)^4) - 2*x(1)^4*exp(- x(1)^2 - x(2)^4) ;  -4*x(1)^3*x(2)^3*exp(- x(1)^2 - x(2)^4) ];
f=@(x)(0.5*x(1)^2 + 2*x(2)^2);
gradf=@(x)[ x(1);4*x(2)];


% %Parameters for the algorithm
x0=[-7;5];
e=0.01;         %I chose this value because it seemed the most approptiate (regarding the tradeoff between accuracy and number of repetitions)

%Uncomment the lines that correspond to the method you want to try
gamma_method="constant";        
gamma_params=10;

% gamma_method="optimal";
% gamma_params=[0, 100, 0.001]; 

% gamma_method="armijo";
% gamma_params=[0.01, 0.1, 3];

[x_values, f_values, grad_values]=steepest_descent(f, gradf, x0, e, gamma_method, gamma_params);


grid_vals=-10:0.1:10;
result_flag=1;
make_plots(f, grid_vals, result_flag, x_values, f_values)

