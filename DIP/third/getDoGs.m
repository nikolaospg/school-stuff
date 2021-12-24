function DoG=getDoGs(octave)
%---------------------------------------------------------------------
%This function calculates the DoGs for one specific octave. The
%way it is done is the usual way we have discussed on the presentation.
%Inputs:
%       1)octave-> 3D Array with the space scales of the octave
%Outputs:  
%       DoG-> A 3D array containing the DoGs of the octave.
%---------------------------------------------------------------------

    %Initialising useful variables
    dims=size(octave);    %Getting the dimensions of the octave
    num_DoGs=dims(3)-1;
    DoG=zeros(dims(1), dims(2), num_DoGs);
    %Finished initialising useful variables
    
    %For loop to calculate the DoGs. Every iteration corresponds to one DoG
    for i=1:num_DoGs
        DoG(:,:,i)=octave(:,:,i) - octave(:,:,i+1);
    end
    %Finished


end