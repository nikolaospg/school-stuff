function myAffinityMat = Image2Graph (imIn)
%---------------------------------------------------------------------
%The function takes as an input a MxN image with n channels, calculates its
%affinity matrix (as it is defined on the project), and returns the
%affinity matrix ((MN)x(MN)).
%Input:
%       1)imIn->   The input image
%Output:
%       1)myAffinityMat->      The affinity matrix.
%--------------------------------------------------------------------

    %Initialising useful variables (the dimensions of the image)
    dimensions=size(imIn);
    M=dimensions(1);
    N=dimensions(2);
    n=dimensions(3);
    %Finished initialising useful variables
    
    %Initialising the affinity matrix as a (MN)x(MN) identity matrix. The
    %elements in the diagonal are ones because they are the similarity of
    %two same points. 
    myAffinityMat=diag(diag(ones(M*N)));  
    
    %The following loop is used to make the computation. Each i iteration
    %corresponds to one row, and each j iteration to one column (i.e. an element of the row).
    %The affinity matrix is symmetric, so I only make the computation on
    %the lower triangular part, the rest is filled out using the symmetry
    %property
    for i=2:M*N
        pixel1_coords=getCoords(i,M,N,1);     %Working with a row major manner, getting the coordinates.
        pixel1=imIn(pixel1_coords(1), pixel1_coords(2), :); %Using the coordinates, I get the values of the pixel
        jreps=i-1;      %The amount of columns that are in this row (only lower triangular part)
        for j=1:jreps
            pixel2_coords=getCoords(j,M,N,1);     %Working with a row major manner, getting the coordinates.
            pixel2=imIn(pixel2_coords(1), pixel2_coords(2), :);     %Using the coordinates, I get the values of the pixel
            diff=squeeze(pixel1-pixel2);  %Finding the difference and storing in 1D array(column), using squeeze command
            myAffinityMat(i,j)= exp(- norm(diff));      %Finding the weight W(i,j)
            myAffinityMat(j, i)=myAffinityMat(i,j);     %Storing it to W(j,i) as well
        end
    end      
    %Finished with the computations and got the affinity matrix
            
end