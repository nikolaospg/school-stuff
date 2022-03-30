%This function takes the population and the fitness values, finds the optimal chromosome, decodes it to get the actual model
%and uses the model to calculate the metrics on the train and the validation set (used to get the training curves)
%if(fitness_flag==1)->  RMSE is used
%else->                 MAE is used


function [train_metric,val_metric]=compute_metrics(current_pop, fitness_values, num_centers, X_train, y_train, X_val, y_val, fitness_flag)
    
    %First decoding the population to get the model
    max_fitness=max(fitness_values);
    max_pos=find(fitness_values==max_fitness);
    max_pos=max_pos(1);
    optimal_chromosome=current_pop(max_pos,:);
    model_matrix=get_model_matrix(optimal_chromosome, num_centers);
    %Finished decoding
    
    
    %Getting predictions
    train_preds=infer_dataset(model_matrix, X_train);
    val_preds=infer_dataset(model_matrix, X_val);
    
    train_errors=train_preds-y_train;
    val_errors=val_preds-y_val;
    
    if(fitness_flag==1)         %This means RMSE
        train_metric=sqrt(mean(train_errors.*train_errors));
        val_metric=sqrt(mean(val_errors.*val_errors));
    else
        train_metric=mean(abs(train_errors));
        val_metric=mean(abs(val_errors));
    end
    %Finished getting predictions





end