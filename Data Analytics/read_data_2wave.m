
%The following function is similar to the read_data which gave us the data for the first wave, but in this
% one we get the data for the second wave.
%
% The inputs are quite similar to the first function, with the difference that now the user can also pass a special flag
% as a parameter. This flag informs the function that the user wants the history plots of the data in the second wave
% This was done to ensure that the time span that we chose as the second wave actually captures the information of 
% the second wave (maxima days and so on)., and also give a visual represantation too (we thought a history plot
% was better than a bargraph for this purpose). If plot_flag==1 then print.
%
% The outputs are the same

function [ Cases_final, Deaths_final,Cases_before, Deaths_before, populations]=read_data_2wave(cases_Name, deaths_Name, id_vector, plot_flag)
    
    
    id_vector=id_vector(:);
    num_countries=size(id_vector,1);
    id_vector=id_vector+1;                                  %Raising the ids by 1, so that they correspond to the correct row numbers of the files read by matlab.
    
   
    %Reading the files and storing the data in the Cases_before, Deaths_before Arrays.
    Cases_before=xlsread(cases_Name);
    populations=Cases_before(:,1);                                    %Getting the populations
    populations=populations(id_vector);
    Cases_before=Cases_before(:,2:end);                             %Getting the values and getting rid of the populations
    Deaths_before=xlsread(deaths_Name);
    Deaths_before=Deaths_before(:,2:end);
    %Finished reading and storing
    
    %Creating a for loop, in which we will get rid of the NaN and the negative Values. Every iteration corresponds to one country.
    for i=1:num_countries
        num_days=size(Cases_before,2);
        current_id=id_vector(i);
        temp_v1=Cases_before(current_id,:);                     %Temporary vector resembling the cases data. It will be changed and in the end stored in the Cases_final array
        temp_v2=Deaths_before(current_id,:);                  %Temporary vector resembling the deaths data. It will be changed and in the end stored in the Deaths_final array
        
       %While loop to get rid of negative values
       count=1;
       while(count<num_days)
            if(temp_v1(count)<0)                    %I found a negative value on the cases. I remove this value and the corresponding one on the deaths vector
                temp_v1=temp_v1([1:count-1 count+1:end]);
                temp_v2=temp_v2([1:count-1 count+1:end]);
                num_days=num_days-1;
                
            elseif(temp_v2(count)<0)             %I found a negative value on the deaths. I remove this value and the corresponding one on the cases vector
                 temp_v1=temp_v1([1:count-1 count+1:end]);
                 temp_v2=temp_v2([1:count-1 count+1:end]);
                 num_days=num_days-1;
            else
                count=count+1;
            end
       end
        %Finished getting rid of the negative values
        
        %While loop to get rid of the NaN values
        count=1;
        while(count<num_days)
            if(isnan(temp_v1(count)))            %I found a NaN value on the cases. I remove this value and the corresponding one on the deaths vector
                temp_v1=temp_v1([1:count-1 count+1:end]);
                temp_v2=temp_v2([1:count-1 count+1:end]);
                num_days=num_days-1;    
            elseif(isnan(temp_v2(count)))               %I found a NaN value on the deaths. I remove this value and the corresponding one on the cases vector
                 temp_v1=temp_v1([1:count-1 count+1:end]);
                 temp_v2=temp_v2([1:count-1 count+1:end]);
                 num_days=num_days-1;
            else
                count=count+1;
            end
            
        end
        %Finished getting rid of the NaN values
        
        
        %Now time to get the second wave. Deciding on when the second wave begun and ended was even more 
        % harder than deciding on the first one. By looking at the data and some history plots we made, we thought
        % that a proper time for the beginning of the second wave was around the beginning-middle of september for many of the
        % countries. Again, the main part of the wave was later but as in the first wave, we wanted to capture the info from the
        % buildup as well.
        %We also see that the second wave does not show any clear signs of finishing for most of the countries.
        % So it began around the middle of september and it did not end.
        % Because of these, we took the second wave as the last 100 days of the data.
        temp_v1=temp_v1(end-99:end);
        temp_v2=temp_v2(end-99:end);
        
        %We now have to fill out the Cases_final and Deaths_final for this country. 
        %In the first element of every row, we have the country id.
        %In the next size(temp_v,2) values we have the actual data
        
        Cases_final(i,1)=current_id-1;                                                        %The first element tells us the id
        Cases_final(i, 2:size(temp_v1,2)+1)=temp_v1;                      %The actual data
        
        Deaths_final(i,1)=current_id -1;                                                   %The first element tells us the id
        Deaths_final(i, 2:size(temp_v2,2)+1)=temp_v2;                   %The actual data
        %Finished getting the data
        
        %Now I will create the history plots if the user has asked for it.
        global figure_num;
        if(plot_flag==1)
            figure_num=figure_num+1;
            figure(figure_num)
            subplot(2,1,1)
            plot(temp_v1);
            title(sprintf('The history plot of the Cases of the country ID=%d',current_id-1));
            ylabel('Daily Cases');
            xlabel('Days (beg. of September-> middle of December)');
            subplot(2,1,2)
            plot(temp_v2);
            title(sprintf('The history plot of the Deaths of the country ID=%d',current_id-1));
            ylabel('Daily Deaths');
            xlabel('Days (beg. of September-> middle of December)');
        end
        %Finished with the plots as well
    end

end