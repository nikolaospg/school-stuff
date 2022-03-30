%This function implements the Newton method
%Inputs:
%   f->                 Function handle for our function
%   gradf->             Function handle for the gradient of the function
%   hssf->              Function handle for the hessian of the function
%   x0->                The initial x point
%   e->                 The parameter determining the stopping point
%   gamma_method->      STRING that specifies the gamma choice method.
% The choices are 'constant', 'optimal', 'armijo'
%   gamma_params->      The parameters of the gamma choice algorithm (vector!!!)
%   e.g. if we want a=3, b=4, l=0.01 on the optimal method, gamma_params=[3,4,0.01]
%   for the constant method, gamma=gamma_params


function [x_values, f_values, grad_values]=Newton(f, gradf, hessf, x0, e, gamma_method, gamma_params)


    %Working with the arguments
    x0=x0(:);
    fprintf("Implementing Newton on f, with x0=(%d,%d) and e=%d\n", x0(1), x0(2), e);
    if(gamma_method=="constant")
        fprintf("Using a constant gamma=%d\n",gamma_params(1));
        gamma=gamma_params;
    elseif(gamma_method=="optimal")
        fprintf("Using the optimal gamma, a=%d b=%d l=%d\n", gamma_params(1), gamma_params(2), gamma_params(3));
    elseif(gamma_method=="armijo")
        fprintf("Using the armijo gamma, a=%d b=%d s=%d\n",gamma_params(1), gamma_params(2), gamma_params(3));
    else
        error("'%s' method is invalid. Please type 'constant', 'optimal' or 'armijo'\n",gamma_method)
    end
    %Finished working with the arguments
    
    
    %Initialising 
    x_values(:,1)=x0;
    f_values(1)=f(x0);
    n=1;
    
    x_current=x0;
    %Finished initialising
    
    while(n<1000)
      
        current_grad=gradf(x_current);
        grad_values(:,n)=current_grad;
        if(norm(current_grad)<e)
            break
        end
        current_hessian=hessf(x_current);
        %eig(current_hessian)
        
        %Finding the d by solving hessianf*d=-gradf
        d=linsolve(current_hessian, -current_grad);
        
        %Choosing gamma
        if(gamma_method=="optimal")
            gamma=optimal_gamma(f, x_current, d, gamma_params(1), gamma_params(2), gamma_params(3));
        elseif(gamma_method=="armijo")
            gamma=armijo(f, gradf, x_current, d, gamma_params(1), gamma_params(2), gamma_params(3));
        end
        x_current=x_current+gamma*d;     %Getting the next x value
            
            
        
        n=n+1;
        x_values(:,n)=x_current; 
        f_values(n)=f(x_current);
        
   
    end


end