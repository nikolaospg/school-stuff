function myGFilter = my2DGaussianFilter (K, sigma )
%---------------------------------------------------------------------
%This function calculates and returns the matrix describing a 2D gaussian
%filter, according to the formula given in the exercise.
%Inputs:
%       1)K ->      The dimension of the matrix (I implemented for an odd K only)
%       2)sigma->   The standard deviation of the filter
%Outputs:  
%       myGFilter-> The matrix describing the filter (2D)
%---------------------------------------------------------------------


    %Testing whether the k coefficient is odd
    if(mod(K,2)==0)
        fprintf("In my2DGaussianFilter, the k coefficient should be odd. You passed K=%d\n",K)
        return
    end
    %Finished testing whether the k coefficient is odd
    
    %Initialising useful variables. 
    half_dim=floor(K/2);
    var=sigma^2;
    [X_coeffs, Y_coeffs]=meshgrid(-half_dim:1:half_dim);
    %Finished initialising useful variables
    
    %Applying the gaussian formula and normalising
    myGFilter=(1/(2*pi*var)) * exp( -(X_coeffs.^2 + Y_coeffs.^2)/(2*var));
    
    total_sum=sum(sum(myGFilter));
    myGFilter=myGFilter/total_sum ;    %Done the normalisation
    %Finished
    

end