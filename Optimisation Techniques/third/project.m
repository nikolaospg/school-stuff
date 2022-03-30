%Function I use to project some point into the feasible region
function projected= project(x, x1_limits, x2_limits)
    
    used_flag=0;        %This flag tells me whether I actually did a projection or not. If ==0 then I did not project, I was already on the area
    %First projecting the x1 coordinate
    if(x(1)<x1_limits(1))       %Left side
        projected(1)=x1_limits(1);
        used_flag=1;
    elseif(x1_limits(2)<x(1))   %Right side
        projected(1)=x1_limits(2);
        used_flag=1;
    else                        
        projected(1)=x(1);
    end
    
    %Now projecting the x2 coordinate
    if(x(2)<x2_limits(1))
        projected(2)=x2_limits(1);
        used_flag=1;
    elseif(x2_limits(2)<x(2))
        projected(2)=x2_limits(2);
        used_flag=1;
    else
        projected(2)=x(2);
    end
    
    projected=projected(:);         %Converting to column matrix
    if(used_flag==1)
        fprintf("For the point (%d,%d) I used the project function and got the (%d,%d) \n",x(1),x(2),projected(1), projected(2));
    end
end
