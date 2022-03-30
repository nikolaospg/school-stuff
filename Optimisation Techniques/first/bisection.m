%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function implements the bisection method
%fun-> Function handle for the function to be minimised
%a,b-> The borders of the search interval
%l->   Parameter defining the accuracy of the algorithm
%e->   The e parameter
%
%Returns the a_vector, b_vector which are the a,b values on every iteration.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [a_vector, b_vector, k, f_comp]=bisection(fun, a, b, l, e)
    %Initialisation
    a_vector(1)=a;
    b_vector(1)=b;
    k=1;
    
    f_comp=0;       %Number of times I evaluated the f function
    
    %Iterative algorithm
    while(b_vector(k) - a_vector(k) >= l)
        x1_current= (b_vector(k) + a_vector(k))/2 -e;
        x2_current= (b_vector(k) + a_vector(k))/2 +e;
        
        fx1_current=fun(x1_current);
        fx2_current=fun(x2_current);
        
        if(fx1_current<=fx2_current)
            a_vector(k+1)=a_vector(k);
            b_vector(k+1)=x2_current;
        else
            a_vector(k+1)=x1_current;
            b_vector(k+1)=b_vector(k);
        end
        k=k+1;
        f_comp=f_comp+2;
    end
    

end