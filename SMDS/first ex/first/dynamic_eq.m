% This is the function I use in order to get the function handle that is needed for the simulation using
% the ode function. 
% It gets as inputs all the parameters for the state equations, and 
% returns a vector with the derivatives of the current state variables.\
% It is based on the equations from the theoretical analysis

function dx= dynamic_eq(t, x, u, k, m, b)
    
    dx1=x(2);
    dx2=-b*x(2)/m -k*x(1)/m +u(t)/m;
    dx=[dx1 dx2]';

end