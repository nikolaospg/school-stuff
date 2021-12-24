%The following function is used, when the user wants to get the data from the xlsx file. It returns the data for multiple countries at once, and also removes NaN and negative values.

%Inputs:    cases_Name: String containing the name of the daily confirmed cases file
%                deaths_Name:String containing the name of the daily deaths file
%                id_vector: Vector containing the ids of the countries that we want to study. BE CAREFUL! DO NOT JUST PASS THE ROW NUMBER! THE FIRST ROW DOES NOT CORRESPOND TO A COUNTRY

%Outputs:       Cases_before, Deaths_before-> The arrays containing the data from the file,without the country population.
%                       Cases_final, Deaths_final -> The arrays containing the data we want
%                       populations-> The populations of the countries that the user wants to study
%
%   e.g. If I want to study Italy and Ireland from the xlsx files we have been given, I call
%           [Cases_final, Deaths_final,Cases_before, Deaths_before, populations ]=Group39Exe1Fun1('Covid19Confirmed.xlsx', 'Covid19Deaths.xlsx', [65 67]);
%
%
%For the final arrays, we have:
%   In the first element of every row, the country id.
%   In the remaining elements the actual data.

function [ Cases_final, Deaths_final,Cases_before, Deaths_before, populations]=read_data(cases_Name, deaths_Name, id_vector)
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
        
        
        %Calculating where the first wave begins. We took it as the day where the first confirmed case was announced.
        % The reason for this choice is that we want for our data to have the information about the buildup of the epidemic
        % too, and not just the data around the peak of the epidemic
        count=1;
        while(temp_v1(count)<1)
            count=count+1;
        end
        temp_v1=temp_v1(count:end);
        temp_v2=temp_v2(count:end);
        %Finished calculating where the first wave begins. We reduced the length of the vectors from the left.
        
        
        %Now we have to decide on when the first wave ends. This is a very hard thing to decide, as there are too
        % many parameters on when to decide that the wave ended. The mathematical criteria we have tried to apply
        % failed because even though they gave some good results on some countries, on some others they were not able
        % to give good results (they might never end, or said that the wave ended 40 days after it started and many other problems)
        % In the end, we decided that 150 days after the first case was a good and simple barrier as at that time
        % the borders had opened, the lockdown was stopped the businesses were on the go and so on.
        % It might seem like a very large span, but our decision was to be "on the safe side" and include a longer span
        % as there were many countries that continued to have a high amount of cases and deaths even in the summer.
        temp_v1=temp_v1(1:150);
        temp_v2=temp_v2(1:150);
        %Finished with the calculation of the end... The temp_v1 temp_v2 vectors are now ready to be put on the final arrays
        
        
        
        %We now have to fill out the Cases_final and Deaths_final for this country. 
        %In the first element of every row, we have the country id.
        %In the next size(temp_v,2) values we have the actual data
        
        Cases_final(i,1)=current_id-1;                                                        %The first element tells us the id
        Cases_final(i, 2:size(temp_v1,2)+1)=temp_v1;                      %The actual data
        
        Deaths_final(i,1)=current_id -1;                                                   %The first element tells us the id
        Deaths_final(i, 2:size(temp_v2,2)+1)=temp_v2;                   %The actual data
    end
end