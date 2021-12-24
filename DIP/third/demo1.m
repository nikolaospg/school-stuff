%Demo used to demonstrate the process of creating the gaussian space scales

clc
clear
close all

%Getting the images
data=open("dip_hw_3.mat");
mountains=data.mountains;
roofs=data.roofs;
print_flag=1;       %Set it =0 if you want to print the original images
%Finished getting the images

%Printing the images (only if print_flag==0)
if(print_flag==0)
    figure("Name", "Mountains - no blurring")
    imshow(mountains);

    figure("Name", "Roofs - no blurring")
    imshow(roofs)
end
%Finished printing the images

%Initialising variables and calling the myDoGs function
img=mountains;              %Change the value in order to work on another image
sigma=sqrt(2);
octaves=7;
k=sqrt(2);
levels=3;       %Recommended values: levels=s+3, where s is the sth root of two on the k value.    
K=7;
[ spacescales , DoGs] = myDoGs (img , sigma , levels , octaves, k, K);
%Got my Space scales and Dogs

%Now creating the plots. I have decided to only include the plots regarding
%two octaves in each figure, so that it can be more easily seen. That means
%that I have 2 Spaces scales and their DoGs in each figure.
num_figures=ceil(octaves/2);
octave_counter=1;
for i=1:num_figures
    
    %This if clause checks on whether we have reached the final octave:
    if(i<num_figures)
        name=sprintf("The space scales and Dogs for octaves=%d,%d\n",2*i-1,2*i);
        figure("Name",name)
        
        %Each j iteration corresponds to one octave:
        for j=1:2
            %First printing the Space Scales of the octave
            current_octave=cell2mat(spacescales(octave_counter));
            for k=1:levels
                subplot(4,levels,k+(j-1)*2*levels)
                imshow(current_octave(:,:,k))
            end
            %Finished with the space scales
            
            %Now printing the DoGs of the octave
            current_DoGs=cell2mat(DoGs(octave_counter));
            for k=1:levels-1
                subplot(4,levels,k+(j-1)*2*levels +levels)
                imshow(current_DoGs(:,:,k),[min(min(current_DoGs(:,:,k))), max(max(current_DoGs(:,:,k)))])
            end
            %Finished printing the DoGs too.
            octave_counter=octave_counter+1;
            
        end
    %Finished printing the results for the octaves before the final one
    
    
    %For the final octave:
    else
        
        %If the number of octaves is odd, then the final figure has only
        %one octave
        if(mod(octaves,2)==1)
            name=sprintf("The space scales and Dogs for octave=%d\n",octaves);
            figure("Name",name)
            
            %First printing the Space Scales of the octave
            current_octave=cell2mat(spacescales(octave_counter));
            for k=1:levels
                subplot(2,levels,k)
                imshow(current_octave(:,:,k))
            end
            %Finished with the space scales

            %Now printing the DoGs of the octave
            current_DoGs=cell2mat(DoGs(octave_counter));
            for k=1:levels-1
                subplot(2,levels,k +levels)
                imshow(current_DoGs(:,:,k),[min(min(current_DoGs(:,:,k))), max(max(current_DoGs(:,:,k)))])

            end
            %Finished printing the DoGs too.
            octave_counter=octave_counter+1;
                
        %Finished for the case when the number of octaves is odd
            
        %If the number of octaves is even, then the final one has two
        %octaves
        else
            name=sprintf("The space scales and Dogs for octaves=%d,%d\n",2*i-1,2*i);
            figure("Name",name)
            
            for j=1:2
                %First printing the Space Scales of the octave
                current_octave=cell2mat(spacescales(octave_counter));
                for k=1:levels
                    subplot(4,levels,k+(j-1)*2*levels)
                    imshow(current_octave(:,:,k))
                end
                %Finished with the space scales

                %Now printing the DoGs of the octave
                current_DoGs=cell2mat(DoGs(octave_counter));
                for k=1:levels-1
                    subplot(4,levels,k+(j-1)*2*levels +levels)
                    imshow(current_DoGs(:,:,k),[min(min(current_DoGs(:,:,k))), max(max(current_DoGs(:,:,k)))])

                end
                %Finished printing the DoGs too.
                octave_counter=octave_counter+1;

            end
        end
        
        
    end
end
