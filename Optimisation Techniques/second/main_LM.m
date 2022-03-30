clc
clear
close all

%Function handles
f=@(x)(x(1)^3 * exp(-x(1)^2 - x(2)^4));
gradf=@(x)[  3*x(1)^2*exp(- x(1)^2 - x(2)^4) - 2*x(1)^4*exp(- x(1)^2 - x(2)^4) ;  -4*x(1)^3*x(2)^3*exp(- x(1)^2 - x(2)^4) ];
hessf=@(x)[ 6*x(1)*exp(- x(1)^2 - x(2)^4) - 14*x(1)^3*exp(- x(1)^2 - x(2)^4) + 4*x(1)^5*exp(- x(1)^2 - x(2)^4),  8*x(1)^4*x(2)^3*exp(- x(1)^2 - x(2)^4) - 12*x(1)^2*x(2)^3*exp(- x(1)^2 - x(2)^4) 
            8*x(1)^4*x(2)^3*exp(- x(1)^2 - x(2)^4) - 12*x(1)^2*x(2)^3*exp(- x(1)^2 - x(2)^4),                    16*x(1)^3*x(2)^6*exp(- x(1)^2 - x(2)^4) - 12*x(1)^3*x(2)^2*exp(- x(1)^2 - x(2)^4)];


% %Parameters for the algorithm
x0=[1;1];
e=0.01;
increase_step=1;                   %Step I use when converting the hessian to positive definit

% gamma_method="constant";                      %Uncomment to apply the "constant" algorithm, with the parameters you want
% gamma_params=1;

% gamma_method="optimal";                       %Uncomment to apply the "optimal" algorithm, with the parameters you want
% gamma_params=[0, 100, 0.001]; 

gamma_method="armijo";                        %Uncomment to apply the "armijo" algorithm, with the parameters you want
gamma_params=[0.1, 0.1, 1];

[x_values, f_values, grad_values]=LM(f, gradf, hessf, x0, e, increase_step, gamma_method, gamma_params);


%Parameters for the plots
grid_vals=-5:0.1:5;
result_flag=1;
make_plots(f, grid_vals, result_flag, x_values, f_values)