%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function implements the bisection method, using the derivative.
%fun-> Function handle FOR THE DERIVATIVE of the function
%a,b-> The borders of the search interval
%l->   Parameter defining the accuracy of the algorithm
%
%Returns the a_vector, b_vector which are the a,b values on every iteration.
%Also returns the k iteration where the algorithm stops and the number of times 
%I had to evaluate the derivative of the function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [a_vector, b_vector, k, der_comp]=bisection_der(fun, a, b, l)
    
    %First getting the number of iterations, n
    %I do this by calculating the log(l/(b-a)) with 0.5 as the base (explained in the report).
    %Of course I convert the correct integer by getting the ceiling
    n=log(l/(b-a))/log(0.5);
    n=ceil(n);
    %Finished getting the number of n
    
    %Initialising
    a_vector=zeros(1,n);
    b_vector=zeros(1,n);
    
    a_vector(1)=a;
    b_vector(1)=b;
    k=1;
    der_comp=0;
    %Finished initialising
    
    for k=1:n-1
        current_x=(a_vector(k)+b_vector(k))/2;
        current_der=fun(current_x);
        der_comp=der_comp+1;
        if(current_der==0)
            fprintf("Early Stopping on bisection with the use of derivatives!\nOn the %d iteration, with x=%d the derivative is zero\n",i,current_x)
            break
        elseif(current_der>0)
            a_vector(k+1)=a_vector(k);
            b_vector(k+1)=current_x;
            
        elseif(current_der<0)
            b_vector(k+1)=b_vector(k);
            a_vector(k+1)=current_x;            
                
        end
    end


end