%This is the function we use in order to calculate the maximum in one sample (Cases-Deaths), 
% which is calculated using our distribution (the loglogistic). 
%   inputs->    1)The id_vector, which tells us which countries we will work with
%                     2)The flag, which tells us whether to work with the Cases or with the deaths,
%                  if flag==1 we work with the cases, else we work with the deaths.
%   outputs->       The vector holding the maxima for all the countries asked.
function max_data=get_peaks(id_vector, flag)

    %Flag=1 means working with cases
    if(flag==1)
        [Cases_final,~,~,~,populations]=read_data('Covid19Confirmed.xlsx', 'Covid19Deaths.xlsx', id_vector);
        for i=1:size(populations,1)
            Cases=Cases_final(i,2:end);
            
            pd_cases=fitdist((1:length(Cases))','loglogistic', 'frequency', Cases);
            pdf_cases=pdf(pd_cases,1:length(Cases));
            max_data(i)=find(pdf_cases==(max(pdf_cases)));
            
        end
        %Finished working with the daily cases
        
    %If flag~=1 then I work with the deaths
    else
        [~,Deaths_final,~,~,populations]=read_data('Covid19Confirmed.xlsx', 'Covid19Deaths.xlsx', id_vector);
        for i=1:size(populations,1)
            Deaths=Deaths_final(i,2:end);
        
            pd_deaths=fitdist((1:length(Deaths))','loglogistic', 'frequency', Deaths);
            pdf_deaths=pdf(pd_deaths,1:length(Deaths));
            max_data(i)=find(pdf_deaths==(max(pdf_deaths)));
        end
    end


end
