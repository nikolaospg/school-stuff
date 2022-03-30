%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function implements the fibonacci method
%fun-> Function handle for the function to be minimised
%a,b-> The borders of the search interval
%l->   Parameter defining the accuracy of the algorithm
%
%Returns the a_vector, b_vector which are the a,b values on every iteration.
%Also returns the k iteration where the algorithm stops and the number of times 
%I had to evaluate the f function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [a_vector, b_vector, k, f_comp]=Fibonacci(fun, a, b, l)

    %First calculating the fibonacci series and the n number
    % Matlab uses 1 based indexing, so we have to be careful!!
    fib(1)=0;       %This is the first element of the fibonacci series
    fib(2)=1;
    limit=(b-a)/l;
    
    count=3;
    while(true)
        new_fib=fib(count-1)+fib(count-2);
        fib(count)=new_fib;
        if(new_fib>limit)
            break
        end
        count=count+1;
    end
    n=count-1;     %I subtract 1 due to the 1 based indexing.
    %Finished calculating the fibonacci series and the n number
    

    %Initialising
    a_vector=NaN(1,n-1);
    b_vector=NaN(1,n-1);
    
    a_vector(1)=a;
    b_vector(1)=b;
    k=1;
    
    x1_current=a+ (fib(n-1)/fib(n+1))*(b-a);
    x2_current=a+ (fib(n)/fib(n+1))*(b-a);
    
    fx1_current=fun(x1_current);
    fx2_current=fun(x2_current);
    f_comp=2;       %Counting how many times I calculate the f function
    %Finished initialising
    
    while(k<n-1)
        if(fx1_current>fx2_current)
            a_vector(k+1)=x1_current;
            b_vector(k+1)=b_vector(k);
            x1_current=x2_current;
            x2_current=a_vector(k+1) + (fib(n-k)/fib(n-k+1))* (b_vector(k+1) - a_vector(k+1));
            
            fx1_current=fx2_current;
            fx2_current=fun(x2_current);
            %f_comp=f_comp+1;
        else
            a_vector(k+1)=a_vector(k);
            b_vector(k+1)=x2_current;
            x2_current=x1_current;
            x1_current=a_vector(k+1) + (fib(n-k-1)/fib(n-k+1))* (b_vector(k+1) - a_vector(k+1));
            
            fx2_current=fx1_current;
            fx1_current=fun(x1_current);
        end
        k=k+1;
        f_comp=f_comp+1;
    end
end