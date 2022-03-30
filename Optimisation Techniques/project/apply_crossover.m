%As the name implies this function takes 2 chromosomes and applies the crossover operation

function new_chromosomes=apply_crossover(chromosome1, chromosome2)
    permutation=randperm(length(chromosome1));
    crossover_position=permutation(1);          %Randomly getting the position for the cut
    
    new_chromosome1=[chromosome1(1:crossover_position), chromosome2(crossover_position+1:end)];
    new_chromosome2=[chromosome2(1:crossover_position), chromosome1(crossover_position+1:end)];

    new_chromosomes=[new_chromosome1;new_chromosome2];


end