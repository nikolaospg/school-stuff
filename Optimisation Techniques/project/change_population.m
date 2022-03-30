%This function is used to change the population, needed in every generation

function new_population=change_population(initial_population, X_train, y_train, fitness_flag, crossover_prob)

    fitness=compute_fitness(X_train, y_train, initial_population, fitness_flag);
    max_fitness=max(fitness);
    max_pos=find(fitness==max_fitness);
    max_pos=max_pos(1);
    min_fitness=min(fitness);
    beta=1/(1-max_fitness/min_fitness);
    alpha=-beta/min_fitness;
    
    for i=1:length(fitness)
        fitness(i)=alpha*fitness(i)+beta;
    end
    sum_fitness=sum(fitness);
    prob_survival=fitness/sum_fitness;
    num_chromosomes=length(initial_population(:,1));
    

    %I choose the optimal chromosome to immediately survive 
    new_population=ones(size(initial_population)); 
    new_population(1,:)=initial_population(max_pos,:);

    new_chromosomes=2;
    while(new_chromosomes<num_chromosomes)
        current_indices=select_chromosomes(prob_survival);
        current_chromosome1=initial_population(current_indices(1),:);
        current_chromosome2=initial_population(current_indices(2),:);
        %If the following condition is satisfied then apply crossover on the chromosomes
        if(judge_probability(crossover_prob)==1)
            result_chromosomes=apply_crossover(current_chromosome1, current_chromosome2);
            new_chromosome1=result_chromosomes(1,:);
            new_chromosome2=result_chromosomes(2,:);
        else
            new_chromosome1=current_chromosome1;
            new_chromosome2=current_chromosome2;
        end
        
        final_chromosomes=induce_mutation(new_chromosome1, new_chromosome2);
        new_population(new_chromosomes,:)=final_chromosomes(1,:);
        new_population(new_chromosomes+1,:)=final_chromosomes(2,:);
        new_chromosomes=new_chromosomes+2;
    end


end