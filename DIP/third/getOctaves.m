function octave=getOctaves(sigma, initialL, levels, initialI, k, K)
%---------------------------------------------------------------------
%This function calculates the space scales of one specific octave. The
%way it is done is described on the report.
%Inputs:
%       1)sigma ->  The standard deviation parameter, helps me create the
%       filters
%
%       2)initialL-> The first space scale (appropriately sampled) of the current
%       octave
%
%       3)levels-> The number of levels of the octave
%
%       4)initialI->  The i parameter of the first space scale of the octave
%       (more details about this on the report), where k^i*sigma is the total
%       std of the octave
%
%       5) k->  The k parameter (specifies the std of the filters)
%
%       6) K->  The size of the filters
%Outputs:  
%       octave-> A 3D array containing the space scales of the octave.
%---------------------------------------------------------------------

    %Initialising useful variables
    dims=size(initialL);     %Getting the dimensions of the first space scale (equal to the ones for the others)
    octave=zeros(dims(1), dims(2),levels);  %Initialising the 3D array to be returned
    octave(:,:,1)=initialL;     %Storing the first space scale
    %Finished initialising useful variables
        
    %Now finding the next space scales and storing in the octave matrix
    current_I=initialI+1;
    previous_L=initialL;
    for index=2:levels
        lambda=sqrt( (k^current_I)^2 - ( k^(current_I-1) )^2 );
        current_I=current_I+1;          %Changing the I parameter, so that it will be appropriate for the next iteration
        kernel = my2DGaussianFilter (K, sigma*lambda );
        current_L=conv2(previous_L, kernel, "same");
        octave(:,:,index)=current_L;
        previous_L=current_L;
    end
    %Finished
end