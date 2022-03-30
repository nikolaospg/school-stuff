%This function uses the probability of survival (calculated in change_population) and 
%selects two chromosomes from the population (it returns the indices-rows where the chromosomes are saved)

function indices=select_chromosomes(prob_survival)
    permutation=randperm(length(prob_survival));
    
    %Getting the first out of 2 chromosomes:
    found_flag=0;                              
    while(found_flag==0)
        for i=1:length(permutation)
            current_index=permutation(i);
            current_prob=prob_survival(current_index);
            if(judge_probability(current_prob)==1)
                indices(1)=current_index;
                found_flag=1;
                break
            end
        end
    end
        
        
    
    %Getting the second one:
    found_flag=0;
    count=0;  
    while(found_flag==0)
        for i=1:length(permutation)
            current_index=permutation(i);
            current_prob=prob_survival(current_index);
            if(current_index~=indices(1))
                if(judge_probability(current_prob)==1)
                    indices(2)=current_index;
                    found_flag=1;
                    break
                end
            end
        end
        count=count+1;
        if(count==100)              %This means that the probabilities are so low that we have not managed to find a probability large enough so that it passes the judge_probability
            break
        end
    end
    
    if(found_flag==0)               %In the case that the probabilities are so low we randomly pick one chromosome and continue
        indices(2)=permutation(1);
    end

end