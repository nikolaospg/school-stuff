%This function implements the steepest descent algorithm with projection.
%Inputs:
%   f->                 Function handle for the function
%   gradf->             Function handle for the gradient of the function
%   x0->                The initial x point
%   e->                 The parameter determining the stopping point
%   gamma->             The (regarded) constant gamma value.
%   s->             The (regarded) constant s value.
%   e.g. if we want a=3, b=4, l=0.01 on the optimal method, gamma_params=[3,4,0.01]
%   for the constant method, gamma=gamma_params
%   x1_limits, x2_limits->       The parameters defining the area from the constraints

function [x_values, f_values, grad_values]=SD_projection(f, gradf, x0, e, gamma, s, x1_limits, x2_limits)
    x0=x0(:);
    fprintf("Implementing Steepest descend with projection on f, with x0=(%d,%d) and e=%d\n", x0(1), x0(2), e);
    fprintf("The s=%d (constant) and the gamma=%d (constant)\n",s, gamma);
    
    %Initialising 
    x_values(:,1)=x0;
    f_values(1)=f(x0);
    n=1;
    
    x_current=x0;
    x_current=project(x_current, x1_limits, x2_limits);     %In case the x_current is out of the area
    %Finished initialising
 
    
    while(n<1000)
        current_grad=gradf(x_current);
        grad_values(:,n)=current_grad;
        if(norm(current_grad)<e)
            break
        end
        
        bef_projection=x_current - s*current_grad;
        after_projection=project(bef_projection, x1_limits, x2_limits);     %Projecting
        
        
        x_current=x_current + gamma* (after_projection - x_current);     %Updating
        n=n+1;
        x_values(:,n)=x_current; 
        f_values(n)=f(x_current);
    end




end
