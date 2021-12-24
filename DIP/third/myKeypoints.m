function keypoints = myKeypoints (DoGs)
%---------------------------------------------------------------------
%This function calculates the salient keypoints using the DoGs. The way it
%is done is by checking whether the point is a minimum/maximum among its 26
%neighbours (calling the checkSalience function for help)
%Inputs:
%       1)DoGs-> The cell array with the DoGs of each octave
%Outputs:  
%       1)keypoints-> A list (implemented with a cell array on Matlab)
%       where every cell has info about a specific salient point (as
%       described on the exercise)
%---------------------------------------------------------------------

    %Getting useful variables
    octaves=length(DoGs);
    points_counter=1;
    keypoints={};
    %Finished with the useful variables
    
    %In the following for loop, each iteration corresponds to one octave.
    for octave_index=1:octaves
        current_octave_DoGs=cell2mat(DoGs(octave_index));
        current_size=size(current_octave_DoGs);
        
        previousDoG=current_octave_DoGs(:,:,1);
        currentDoG=current_octave_DoGs(:,:,2);
        nextDoG=current_octave_DoGs(:,:,3);
        
        %In the following loop, every iteration corresponds to searching on
        %one DoG of this specific octave.
        for DoG_index=2:current_size(3)-1
            for row_index=2:current_size(1)-1
                for col_index=2:current_size(2)-1
                   result=checkSalience(previousDoG, currentDoG, nextDoG, row_index, col_index);
                   
                   %If the result==1, then is is a salient point.
                   %Storing it inside the keypoints cell array
                   if(result==1)
                       tuple={octave_index, DoG_index, row_index, col_index};
                       keypoints(points_counter)={tuple};
                       points_counter=points_counter+1;
                   end
                   %Finished storing the salient point
                    
                end
            end
            %Changing the DoGs to be searched (for the next iteration):
            if(DoG_index<current_size(3)-1)
                
                previousDoG=currentDoG;
                currentDoG=nextDoG;
                nextDoG=current_octave_DoGs(:,:,DoG_index+2);
            end
            %Finished changing the DoGs to be searched
            
        end
    end
        
end