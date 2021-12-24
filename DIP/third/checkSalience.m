function salience= checkSalience(DoG_previous, DoG_current, DoG_next, point_m, point_n)
%---------------------------------------------------------------------
%This function tells us whether a specific point can be considered as a
%salient keypoint or not. The way it is done is by checking whether it is
%the max or the min of the 26 neighbours.
%Inputs:
%       1)DoG_previous ->  The previous DoG array
%
%       2)DoG_current-> The DoG of our point
%
%       3)DoG_next-> The next DoG array
%
%       4)point_m->  The m coordinate of the point
%
%       5) point_n-> The n coordinate of the point
%
%Outputs:  
%       1)salience -> If the point is salient then the return variable is
%       equal to one, else it is equal to 0.
%---------------------------------------------------------------------

    point_value=DoG_current(point_m, point_n);
    is_min=1;           %Flags that help me understand whether the point is salient.
    is_max=1;
    
    for DoG_index=-1:1
        
        %Getting the temporary DoG, with which we will be comparing
        if(DoG_index==-1)
            temp_DoG=DoG_previous;
        end
        if(DoG_index==0)
            temp_DoG=DoG_current;
        end
        if(DoG_index==1)
            temp_DoG=DoG_next;
        end
        %Finished getting the temporary DoG
        
        %In the following double for Loop, I am getting the difference
        %between the point_value and any other point which is a neighbour.
        %I use diff=neighbour_value - point_value.
        %If the difference>0, then the neighbour_value is larger therefore
        %the point cannot be a maximum, if the diff<0 then the point cannot
        %be a minimum:
        for row_index=-1:1
            for col_index=-1:1
                diff=temp_DoG(point_m+row_index, point_n+col_index)-point_value;
                if(diff>0)
                    is_max=0;
                     
                end
                if(diff<0)
                    is_min=0;
                     

                end
            end
        end
    end
    %Finished with the comparisons
    
    if(is_min==0 && is_max==0)
        salience=0;
    else
        salience=1;
    end


end