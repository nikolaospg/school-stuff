clc
clear
close all

%Initialising parameters for the dataset creation:
f=@(u1,u2)( sin(u2.^2) .* sin(u1+u2));
train_size=400;
val_size=200;
test_size=200;
total_size=train_size+val_size+test_size;

add_noise_flag=0;   
noise_SNR=0.7;                %in DB

add_outliers_flag=1;
train_outliers=2;
val_outliers=1;
test_outliers=1;


file_name="outlier_dataset.mat";               %The name of the file for the datasets to be written


%Datasets:
u1=3*rand(total_size,1)-1;
u2=3*rand(total_size,1)-2;
y=f(u1,u2);

y_old=y;
if(add_noise_flag==1)
    y_var=var(y);
    noise_var=y_var/(10^(noise_SNR/10));
    noise_std=sqrt(noise_var);
    noise=randn(length(y),1)*noise_std;
    y=y+noise;
end
    
    
    

dataset=[u1,u2,y];


%Randomly splitting datasets
permutation=randperm(total_size)';
perm1=permutation(1:train_size);
perm2=permutation(train_size+1:train_size+val_size);
perm3=permutation(train_size+val_size+1:end);

    
train_set=dataset(perm1,:);
val_set=dataset(perm2,:);
test_set=dataset(perm3,:);



if(add_outliers_flag==1)
    
    %For the train:
    permutation_train=randperm(train_size)';
    for i=1:train_outliers
        current_row=permutation_train(i);
        train_set(current_row,3)=20;
    end
    
    %For the validation:
    permutation_val=randperm(val_size)';
    for i=1:val_outliers
        current_row=permutation_val(i);
        val_set(current_row,3)=20;
    end
    
    %For the train:
    permutation_test=randperm(test_size)';
    for i=1:test_outliers
        current_row=permutation_test(i);
        test_set(current_row,3)=20;
    end
    
    
end

current_dataset.train=train_set;
current_dataset.test=test_set;
current_dataset.val=val_set;

save(file_name,"current_dataset");