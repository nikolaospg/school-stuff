function mean_validation_error=kfold_validate(kfold_struct, dataset, current_ra, num_epochs)
%------------------------------------------------------------------------------------------------------------------------------------------------%
%This function takes a specific reduced training dataset (it comes from reducing the training dataset based on the 
%amount of features parameter) and a specific ra value, and uses k-fold (k=5) cross validation to validate the model
%Inputs:
%               1)kfold_struct: The partition structure we created before starting the grid search. It is the same for every parameter pair
%               2)dataset:  The (reduced) training dataset. Reduced means that it has less features than the initial one
%               3)current_ra:       The current radius value
%               4)num_epochs:   The number of epochs (iterations) of the training
%It gets the MSE vectors from the validation set for every fold, and finds the mean value. This is a new vector with the mean MSE for every epoch
%I regarded the minimum value of this vector as the min MSE for the model - the criterion.
%------------------------------------------------------------------------------------------------------------------------------------------------%


    k=kfold_struct.NumTestSets;
    
    %Each iteration of the following loop corresponds to one fold 
    validation_error_matrix=zeros(k,num_epochs);
    for i=1:k
        %Getting the indices of the training and validation sets for this spefic iteration of kfold
        current_training_indices=training(kfold_struct,i);
        current_validation_indices=test(kfold_struct,i);
        %Finished getting the indices
        
        %Now, using the indices I get the actual training/validation sets
        current_training_set=dataset(current_training_indices, :);
        current_validation_set=dataset(current_validation_indices, :);
        %Finished getting the training and validation sets
        
        %Initialising, training the FIS and getting the validation errors
        initial_fis=genfis2(current_training_set(:,1:end-1),current_training_set(:,end), current_ra);       %Using this specific radius value
        [train_FIS,train_error,~,validation_Fis,validation_error]=anfis(current_training_set, initial_fis, [num_epochs 0 0.01 0.9 1.1],[],current_validation_set);
        validation_error_matrix(i,:)=validation_error;
        %Finished initialising and training
    end
    %Got the MSE of the Kfold for the k folds
    
    mean_validation_error=sum(validation_error_matrix,1)./k;        %The mean validation errors - It is a vector with the mean values for each epoch
    mean_validation_error=min(mean_validation_error);
    
    


end