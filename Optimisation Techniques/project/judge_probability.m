%I give a probability to this function and it returns 1 if the according condition is 
%satisfied and 0 if it is not.

function flag=judge_probability(probability)
    a=rand(1);
    if(a<probability)
        flag=1;
    else
        flag=0;
    end
        
end