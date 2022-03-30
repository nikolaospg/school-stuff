%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function implements the golden_section method
%fun-> Function handle for the function to be minimised
%a,b-> The borders of the search interval
%l->   Parameter defining the accuracy of the algorithm
%
%Returns the a_vector, b_vector which are the a,b values on every iteration.
%Also returns the k iteration where the algorithm stops and the number of times 
%I had to evaluate the f function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [a_vector, b_vector, k, f_comp]=golden_section(fun, a, b, l)

    %Initialisation
    a_vector(1)=a;
    b_vector(1)=b;
    k=1;
    gamma=0.618;
    x1_current=a+(1-gamma)*(b-a);
    x2_current=a+gamma*(b-a);
    
    fx1_current=fun(x1_current);
    fx2_current=fun(x2_current);
    f_comp=2;       %Number of times I evaluated the f function
    %Finished initialising
    
    %Iterative algorithm
    while(b_vector(k) - a_vector(k) >= l)
        
        if(fx1_current<=fx2_current)
            a_vector(k+1)=a_vector(k);
            b_vector(k+1)=x2_current;
            
            x2_current=x1_current;
            x1_current=a_vector(k+1) + (1-gamma)*(b_vector(k+1) - a_vector(k+1));
            
            fx2_current=fx1_current;
            fx1_current=fun(x1_current);
        else
            a_vector(k+1)=x1_current;
            b_vector(k+1)=b_vector(k);
            
            x1_current=x2_current;
            x2_current=a_vector(k+1) + gamma*(b_vector(k+1) - a_vector(k+1));
            
            fx1_current=fx2_current;
            fx2_current=fun(x2_current);
        end
        k=k+1;
        f_comp=f_comp+1;
            
        
    end
    


end