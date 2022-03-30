%As the name implies,this function takes 2 chromosomes and mutates them (when the judge_probability is satisfied)

function new_chromosomes=induce_mutation(chromosome1, chromosome2)

    num_centers=length(chromosome1)/60;
    
    %Each iteration of the following loop corresponds to one parameter (which has 12 bits)
    for i=1:num_centers*5                   
        current_init=(i-1)*12 +1;           %This helps me locate the current
        
        %For every bit of this parameter:
        for j=0:11
            current_init+j;
            %These are the four most significant bits, therefore I give of a small probability of mutation
            if(mod(j,12)<4)        
                
                if(judge_probability(0.001)==1)
                    if(chromosome1(current_init+j)==1)
                        chromosome1(current_init+j)=0;
                    else
                        chromosome1(current_init+j)=1;
                    end
                end
            end
            
            
            %These are the four bits with medium importance, therefore I give of a medium probability of mutation
            if(3<mod(j,12) && mod(j,12)<8)           
                if(judge_probability(0.005)==1)
                    if(chromosome1(current_init+j)==1)
                        chromosome1(current_init+j)=0;
                    else
                        chromosome1(current_init+j)=1;
                    end
                end
            end
            
            %These are the four bits with the least importance, therefore I give of a small probability of mutation
            if(mod(j,12)>7)           
                if(judge_probability(0.01)==1)
                    if(chromosome1(current_init+j)==1)
                        chromosome1(current_init+j)=0;
                    else
                        chromosome1(current_init+j)=1;
                    end
                end
            end 
            
        end
                
    end
    
    
    %Each iteration of the following loop corresponds to one parameter (which has 12 bits)
    for i=1:num_centers*5                   
        current_init=(i-1)*12 +1;           %This helps me locate the current
        
        %For every bit of this parameter:
        for j=0:11
            
            %These are the four most significant bits, therefore I give of a small probability of mutation
            if(mod(j,12)<4)           
                if(judge_probability(0.001)==1)
                    if(chromosome2(current_init+j)==1)
                        chromosome2(current_init+j)=0;
                    else
                        chromosome2(current_init+j)=1;
                    end
                end
            end
            
            
            %These are the four bits with medium importance, therefore I give of a medium probability of mutation
            if(3<mod(j,12) && mod(j,12)<8)           
                if(judge_probability(0.005)==1)
                    if(chromosome2(current_init+j)==1)
                        chromosome2(current_init+j)=0;
                    else
                        chromosome2(current_init+j)=1;
                    end
                end
            end
            
            %These are the four bits with the least importance, therefore I give of a small probability of mutation
            if(mod(j,12)>7)           
                if(judge_probability(0.01)==1)
                    if(chromosome2(current_init+j)==1)
                        chromosome2(current_init+j)=0;
                    else
                        chromosome2(current_init+j)=1;
                    end
                end
            end 
            
        end
                
    end
    
    
    new_chromosomes=[chromosome1; chromosome2];

end