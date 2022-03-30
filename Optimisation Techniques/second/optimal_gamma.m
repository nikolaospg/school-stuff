%This function takes a function handle of the form:
%   f=@(x,g,d), which helps model the f(xk+1) equation,
%And the values of xk and dk.
%It creates a new g(xk)=f(xk)|(gk,dk).
%It finds xk*=argmin(g) as of xk, using the golden_section method. 
function gamma=optimal_gamma(f, xk, dk, a, b, l)
    
    f_xk1=@(xk,gammak,dk)(f(xk+gammak*dk));
    g=@(gamma)f_xk1(xk,gamma,dk);
    
    [a_vector, b_vector]=golden_section(g, a,b,l);
    gamma=(b_vector(end)+a_vector(end))/2;


end