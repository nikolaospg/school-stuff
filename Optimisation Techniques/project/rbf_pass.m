%The model matrix is a matrix with num_rbf x 5 dimensions
%Each row gives us the parameters for one RBF (2 for the center, 2 for the sigma, and one for the linear parameter)
%This function passes the X dataset through the RBF layer

function trans=rbf_pass(model_matrix, X)
    
    num_rbf=size(model_matrix);
    num_rbf=num_rbf(1);
    
    num_patterns=size(X);
    num_patterns=num_patterns(1);
    
    trans=zeros(num_patterns,num_rbf);
    %Each iteration of the following for loop corresponds to one RBF.
    for i=1:num_rbf
        %Getting the current parameters:
        c1=model_matrix(i,1);
        c2=model_matrix(i,2);
        var1=model_matrix(i,3);
        var2=model_matrix(i,4);
        current_Xin=X;
        
        %Applying the u1-c1, u2-c2 operation on current_Xin
        current_Xin(:,1)=current_Xin(:,1)-c1;
        current_Xin(:,2)=current_Xin(:,2)-c2;
        
        
        %Applying the squares on the nominators
        current_Xin=current_Xin.*current_Xin;
        
        
        
        %Dividing with the vars
        current_Xin(:,1)=current_Xin(:,1)./(2*var1);
        current_Xin(:,2)=current_Xin(:,2)./(2*var2);
        
        %Adding the components and getting the exponential
        column=current_Xin(:,1)+current_Xin(:,2);
        
        %Getting the current col
        current_out_col=exp(-column);
        
        %Saving the column
        trans(:,i)=current_out_col;
        
    end
        
    



end