%This function takes the population as an input and computes the fitness of each chromosome
%The fitness is calculated through the MSE and MAE
%To be specific, I use the naive 1/MSE and 1/MAE as fitness. (Small MSE => good fit)


function fitness=compute_fitness(X_train, y_train, population, fitness_flag)
    dimensions=size(population);
    num_chromosomes=dimensions(1);
    num_centers=dimensions(2)/60;
    
    fitness=zeros(num_chromosomes,1);
    for i=1:num_chromosomes
       current_chromosome=population(i,:);
       current_model_matrix=get_model_matrix(current_chromosome, num_centers);
       
       %If the train_preds contains NaN values, set a fitness near zero and continue
       train_preds=infer_dataset(current_model_matrix, X_train);
       row= find(isnan(train_preds));
       if(length(row)>0)                %If we have NaN values just continue
           fitness(i)=0.0001;
           continue
       end
       
       
       errors=y_train-train_preds;
       if(fitness_flag==1)
           current_fitness=mean(errors.*errors);
       else
           current_fitness=mean(abs(errors));
       end
       if(current_fitness>10^16)                %This is done to avoid possible numeric errors
           fitness(i)=0 + 0.0001;
       else
           fitness(i)=1/current_fitness + 0.0001;
       end
    end
    



end