%This function takes a chromosome and applies appropriate decoding to get the 
%model matrix structure
%It applies the chromosome->model_matrix transform

function model_matrix=get_model_matrix(chromosome, num_centers)
    chromosome=chromosome(:);
    model_matrix=zeros(num_centers,5);
    
    
    for i=1:num_centers
        current_rbf_genes=chromosome( (i-1)*60+1: i*60);
        current_c1_genes=current_rbf_genes(1:12);
        current_c2_genes=current_rbf_genes(13:24);
        current_var1_genes=current_rbf_genes(25:36);
        current_var2_genes=current_rbf_genes(37:48);
        current_beta_genes=current_rbf_genes(49:60);
        
        current_c1=Decode(current_c1_genes, -16, 16, 12);
        current_c2=Decode(current_c2_genes, -16, 16, 12);
        current_var1=Decode(current_var1_genes, -16, 16, 12);
        current_var2=Decode(current_var2_genes, -16, 16, 12);
        current_beta=Decode(current_beta_genes, -16, 16, 12);
        
        model_matrix(i, 1)=current_c1;
        model_matrix(i, 2)=current_c2;
        model_matrix(i, 3)=current_var1;
        model_matrix(i, 4)=current_var2;
        model_matrix(i, 5)=current_beta;
        
        
    end
    




end