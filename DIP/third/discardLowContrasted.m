function keypointsHighC = discardLowContrasted (DoGs , keypoints , t, p)
%---------------------------------------------------------------------
%This function gets the salient keypoints that were calculated using the
%myKeypoints functions, and discards the ones with a Low Contrast
%Inputs:
%       1)DoGs-> The cell array with the DoGs of each octave
%       2)keypoints-> The cell array with the results of the myKeypoints
%       function. It has information about every salient keypoint found
%       3)t->   A threshold parameter, which helps to determine the limit
%       by which the keypoints are discarded
%       4)p->   The p parameter (again used to determine the limit)
%Outputs:  
%       1)keypointsHighC-> A list (implemented with a cell array on Matlab)
%       where every cell has info about a specific salient point (as
%       described on the exercise). The salient keypoints are the filtered
%       ones!
%---------------------------------------------------------------------


    num_keypoints=length(keypoints);
    limit=t*p;
    keypointsHighC={};
    keypointsHighC_counter=1;
    
    for keypoint_index=1:num_keypoints
        
        %Extracting the data from the keypoint:
        current_keypoint=keypoints{keypoint_index};
        current_octave=current_keypoint{1};
        current_DoG=current_keypoint{2};
        current_m=current_keypoint{3};
        current_n=current_keypoint{4};
        %Finished extracting the data
        
        %Now getting the value of the keypoint:
        DoG=DoGs{current_octave};
        DoG=DoG(:,:,current_DoG);
        size(DoG);
        current_value=DoG(current_m,current_n);
        %Finished getting the value of the keypoint
        
        %Now filtering
        if(abs(current_value)>limit)
            keypointsHighC(keypointsHighC_counter)={current_keypoint};
            keypointsHighC_counter=keypointsHighC_counter+1;
        end
        %Finished filtering
        
        
    end

end