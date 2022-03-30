clc
clear
close all

%This script is used for the first demonstration of the genetic algorithm
%I just show how the fitness increases using various values for the number of centers

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

%Loading test set:
X_test=test_set(:,1:2);
y_test=test_set(:,3);

mean_ytest=mean(y_test);
y_test=y_test-mean(y_train);          %I am not allowed to use the mean(y_test)
%Finished loading


%Parameters for the G.A.
pop_size=100;
num_centers=15;
bits_per_chromosome=num_centers*60;                    %This is derived from the fact that we have 12 bits for every parameter and 5*15 parameters total
crossover_prob=0.7;
fitness_flag=1;                             %This corresponds to fitness evaluated via MSE (if ==0 then evaluated via MAE)
num_generations=100;

%Randomly initialising population
population=rand(pop_size,bits_per_chromosome);
population(find(population>0.5))=1;
population(find(population<0.5))=0;



current_pop=population;
opt_fitnesses=zeros(num_generations,1);
for i=1:num_generations
    q=compute_fitness(X_train,y_train, current_pop, fitness_flag);
    fit_sort=sort(q,"descend");
    fprintf("%f %f %f\n",fit_sort(1), fit_sort(2), fit_sort(3))
    opt_fitnesses(i)=fit_sort(1);
    current_pop=change_population(current_pop, X_train, y_train, fitness_flag, crossover_prob);
end
fprintf("%d generations, %d centers, 3 best fitness values for each generation\n",num_generations, num_centers)
fitness_values=compute_fitness(X_train,y_train, current_pop, fitness_flag);

%Creating a plot with the fitness values over the generations
figure(1)
plot(1:num_generations, opt_fitnesses)
a=sprintf("Fitness values over the generations, Final Max=%f, %d Centers",max(fitness_values), num_centers);
title(a)
xlabel("generation")
if fitness_flag==1
    ylabel("Fitness based on MSE")
else
    ylabel("Fitness based on MAE")
end


fprintf("\n\n")
%First decoding the population to get the model
max_fitness=max(fitness_values);
max_pos=find(fitness_values==max_fitness);
max_pos=max_pos(1);
optimal_chromosome=current_pop(max_pos,:);
model_matrix=get_model_matrix(optimal_chromosome, num_centers);
%Finished decoding
mytable=table([model_matrix(:,1)], [model_matrix(:,2)], [model_matrix(:,3)], [model_matrix(:,4)], [model_matrix(:,5)]  );
mytable.Properties.VariableNames = {'C1' 'C2' 'Sigma1' 'Sigma2' 'Beta'};
disp(mytable)
