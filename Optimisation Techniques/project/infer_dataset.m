%The model matrix is a matrix with num_rbf x 5 dimensions
%Each row gives us the parameters for one RBF (2 for the center, 2 for the sigma, and one for the linear parameter)
%This function takes a dataset as an input and returns the y values predicted by the model

function preds=infer_dataset(model_matrix, X)
    
    X_trans=rbf_pass(model_matrix, X);          %Passing through the RBF Layer
    theta_vals=model_matrix(:,end);             %Getting linear model parameters
    preds=X_trans*theta_vals;                  %Linear output
    

end