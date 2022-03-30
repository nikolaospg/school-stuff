%The function applies the model_matrix->chromosome tranform
%To do this we have to use the encoding function that converts real number parameters to bit strings
function chromosome=get_chromosome(model_matrix)
    dims=size(model_matrix);
    num_centers=dims(1);
    
    chromosome=zeros(60*num_centers,1);
    
    for i=1:num_centers
       
        current_c1=model_matrix(i,1);
        current_c2=model_matrix(i,2);
        current_var1=model_matrix(i,3);
        current_var2=model_matrix(i,4);
        current_beta=model_matrix(i,5);
        
        current_c1_genes=encode(current_c1, -16,16,12)';
        current_c2_genes=encode(current_c2, -16,16,12)';
        current_var1_genes=encode(current_var1, -16,16,12)';
        current_var2_genes=encode(current_var2, -16,16,12)';
        current_beta_genes=encode(current_beta, -16,16,12)';
        
        current_RBF_genes=[current_c1_genes, current_c2_genes, current_var1_genes, current_var2_genes, current_beta_genes];
        
        chromosome( (i-1)*60 +1:i*60)=current_RBF_genes;
    end
    




end