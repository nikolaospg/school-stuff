clc
clear
close all



%First loading the datasets:
dataset=load("simple_dataset.mat");
dataset=dataset.current_dataset;

train_set=dataset.train;
val_set=dataset.val;
test_set=dataset.test;

%Loading train set:
X_train=train_set(:,1:2);
y_train=train_set(:,3);

mean_ytrain=mean(y_train);
y_train=y_train-mean(y_train);

%Loading validation set:
X_val=val_set(:,1:2);
y_val=val_set(:,3);

y_val=y_val-mean(y_val);

%Loading test set:
X_test=test_set(:,1:2);
y_test=test_set(:,3);

y_test=y_test-mean(y_train);          %I am not allowed to use the mean(y_test)
%Finished loading


%Parameters for the G.A.
pop_size=100;
num_centers=15;
bits_per_chromosome=num_centers*60;                    %This is derived from the fact that we have 12 bits for every parameter and 5*15 parameters total
crossover_prob=0.7;
fitness_flag=1;                             %This corresponds to fitness evaluated via MSE (if ==0 then evaluated via MAE)
num_generations=3000;
initialisation_flag="rndom";               %If is is "random", then initialised randomly, else initialised based on the hybrid kmeans-OLS training 
apply_early_stopping=1;
%Finished with the parameters

% %Now initialising the population
tic;
if(initialisation_flag=="random")
    population=rand(pop_size,bits_per_chromosome);
    population(find(population>0.5))=1;
    population(find(population<0.5))=0;
else
    % %Training RBF Using hybrid Kmeans/Least squares
    %Getting the centers
    rng(42)                                    %Setting a random seed
    [~,centers]=kmeans(X_train,num_centers);            %Got the centers

    %Maximum distance
    distances=pdist2(centers,centers);
    max_dist=max(max(distances));


    sigma=max_dist/sqrt(2*num_centers);        %Got the sigma value


    %Now transforming dataset (passing through RBF Layer)
    model_matrix=[centers(:,1), centers(:,2), ones(num_centers,2)*sigma];

    X_trans=rbf_pass(model_matrix, X_train);


    %Now getting ols solution
    theta=linsolve(X_trans'*X_trans, X_trans'*y_train);
    model_matrix(:,5)=theta;
    
    hybrid_chromosome=get_chromosome(model_matrix);
    % %Finished training with the Hybrid method
    
    
    
    %Now the actual initialisation
    population=zeros(pop_size, bits_per_chromosome);
    
    for i=1:pop_size
        population(i,:)=hybrid_chromosome;
    end
    
    for i=2:pop_size                %Now making small changes to this chromosome for variability
        if(population(i,i)==1)
            population(i,i)=0;
        else
            population(i,i)=1;
        end
    end
    
end
% % Finished initialising the population


%Training:
current_pop=population;
opt_fitnesses=zeros(num_generations,1);
train_metrics=zeros(num_generations,1);
val_metrics=zeros(num_generations,1);


for i=1:num_generations
    q=compute_fitness(X_train,y_train, current_pop, fitness_flag);
    [train_metric,val_metric]=compute_metrics(current_pop, q, num_centers, X_train, y_train, X_val, y_val, fitness_flag);
    train_metrics(i)=train_metric;
    val_metrics(i)=val_metric;
    
    if(apply_early_stopping==1)                     %If we apply early stopping then we get the population where the validation set error is minimal
        if(val_metrics(i)==min(val_metrics(1:i)))
            early_stopping_optimal_pop=current_pop;
            chosen_generation=i;
        end
    end
    
    fit_sort=sort(q,"descend");
    fprintf("%f %f %f\n",fit_sort(1), fit_sort(2), fit_sort(3))
    opt_fitnesses(i)=fit_sort(1);                      
    
    current_pop=change_population(current_pop, X_train, y_train, fitness_flag, crossover_prob);
end
fprintf("%d generations, %d centers, 3 best fitness values for each generation\n",num_generations, num_centers)
q=compute_fitness(X_train,y_train, current_pop, fitness_flag);

fprintf("\n\n")
toc;
%Finished training

%Creating a plot with the fitness values over the generations
figure(1)
plot(1:num_generations, opt_fitnesses)
a=sprintf("Fitness values over the generations, Final Max=%f",max(q));
title(a)
xlabel("generation")
if fitness_flag==1
    ylabel("Fitness based on MSE")
else
    ylabel("Fitness based on MAE")
end

%Plotting the training curves
figure(2)
plot(2:num_generations, train_metrics(2:end))
hold on
plot(2:num_generations, val_metrics(2:end))
legend("Train Metrics","Validation Metrics")
a=sprintf("Training Curves");
title(a)
xlabel("generation")
if fitness_flag==1
    ylabel("RMSE")
else
    ylabel("MAE")
end
%Finished with the plots



%Calculating metrics on train and test sets
if(apply_early_stopping==1)
    fprintf("\nBased on early stopping we chose the %dth generation\n",chosen_generation)
    current_pop=early_stopping_optimal_pop;
    q=compute_fitness(X_train,y_train, current_pop, fitness_flag);
end

[train_RMSE,test_RMSE]=compute_metrics(current_pop, q, num_centers, X_train, y_train, X_test, y_test, 1);
[train_MAE,test_MAE]=compute_metrics(current_pop, q, num_centers, X_train, y_train, X_test, y_test, 0);
fprintf("\ntrain_RMSE=%f train_MAE=%f test_RMSE=%f test_MAE=%f  \n",train_RMSE, train_MAE, test_RMSE, test_MAE)


fprintf("\n\n")

fitness_values=q;
max_fitness=max(fitness_values);
max_pos=find(fitness_values==max_fitness);
max_pos=max_pos(1);
optimal_chromosome=current_pop(max_pos,:);
model_matrix=get_model_matrix(optimal_chromosome, num_centers);


mytable=table([model_matrix(:,1)], [model_matrix(:,2)], [model_matrix(:,3)], [model_matrix(:,4)], [model_matrix(:,5)]  );
mytable.Properties.VariableNames = {'C1' 'C2' 'Sigma1' 'Sigma2' 'Beta'};
disp(mytable)

