function [ spacescales , DoGs] = myDoGs (img , sigma , levels , octaves, k, K)
%---------------------------------------------------------------------
%This function calculates the space scales and the DoGs of a specific
%function.
%Inputs:
%       1)img ->  The initial (not blurred) image.
%
%       2)sigma-> The sigma parameter, which helps us calculate the
%       standard deviation of the low pass filters
%
%       3)levels-> The number of levels of each octave
%
%       4)octaves->  The number of octaves that will be created
%
%       5) k->  The k parameter (specifies the std of the filters)
%
%       6) K->  The size of the filters
%Outputs:  
%       1)spacescales-> A cell array containing all of the space scales of
%       our image. Every element of this array is a cell, which contains
%       all of the space scales of one octave
%
%       2)DoGs-> A cell array containing all of the DoGs of
%       our image. Every element of this array is a cell, which contains
%       all of the DoGs of one octave
%---------------------------------------------------------------------
    
    %Initialising useful variables
    spacescales=cell(1,octaves);
    DoGs=cell(1,octaves);
    %Finished initialising the variables
    
    %Calculating the first space scale (needed for the first octave)
    gauss_filter=my2DGaussianFilter (K, sigma );
    initialL=conv2(img, gauss_filter, "same");  
    %Got the first space scale
    
    %Calling the getOctaves function to calculate the first Octave. 
    initialI=0;
    octave=getOctaves(sigma, initialL, levels, initialI, k, K);
    spacescales(1)={octave};    %Storing the first octave
    %Finished with the first octave
    
    %Now iteratively calling the getOctaves function to get the rest of the
    %octaves
    for index=2:octaves
        initialL=octave(:,:,end-2);     %Picking the L with the appropriate sigma
        initialL=initialL(1:2:end, 1:2:end);    %Undersampling
        
        exponent=2^(index-1);               %For more info about the exponent look at the report
        initialI=log(exponent)/log(k);    %Calculating the initial I (the exponent of k for the first ss of the octave)
        
        octave=getOctaves(sigma, initialL, levels, initialI, k, K);
        spacescales(index)={octave};
    end
    %Got all of the octaves
    
    %Now getting the DoGs
    for index=1:octaves
        DoG_current=getDoGs(cell2mat(spacescales(index)));
        DoGs(index)={DoG_current};
    end
    %Finished getting the DoGs
    
    %Finished with the function
    
    
    
    

end