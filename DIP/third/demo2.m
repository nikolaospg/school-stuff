%This script involves the sift detection, and printing of the keypoints on the images
%The user can easily change the algorithm parameters in order to get better results

clc
clear
close all

%Getting the images
data=open("dip_hw_3.mat");
mountains=data.mountains;
roofs=data.roofs;
print_flag=1;
%Finished getting the images

%Printing the original images. They are printed only if print_flag==0.
if(print_flag==0)
    figure("Name", "Mountains - no blurring")
    imshow(mountains);

    figure("Name", "Roofs - no blurring")
    imshow(roofs)
end
%Finished printing the images

%Initialising variables and calling the myDoGs function
img=mountains;                       %Change the name to work on another image
img=imresize(img,4);            %Resizing because it gave me much better results
sigma=sqrt(2);
octaves=3;
k=sqrt(2);
levels=5;           %Recommended values: levels=s+3, where s is the sth root of two on the k value. 
K=7;
[ spacescales , DoGs] = myDoGs (img , sigma , levels , octaves, k, K);
keypoints=myKeypoints (DoGs);
%Got my Space scales and Dogs5


%Getting the filtering done
nspo=levels-2;
t= ( 2^(1/nspo) -1) *0.015 /(2^(1/3)-1);
p=0.8;
keypointsHighC = discardLowContrasted (DoGs , keypoints , t, p);
%Finished filtering and got the final DoGs.





%%%PRINTING THE KEYPOINTS:%%%

%First getting a matrix representation of the keypoints, so that I can
%easily handle them and print them. Every column of the matrix has the info
%for one salient point.
 for i=1:length(keypointsHighC)
    keypointsHighC_matrix(:,i)= cell2mat(keypointsHighC{i});
 end
 
 for i=1:length(keypoints)
    keypoints_matrix(:,i)= cell2mat(keypoints{i});
 end
 %Got the matrix representations.
 
 
%%Now doing the prints on the DoGs%%
%%FIRST ON THE NOT FILTERED ONES%%
num_figures=ceil(octaves/2);
octave_counter=1;
for i=1:num_figures
    
    %This if clause checks on whether we have reached the final octave:
    if(i<num_figures)
        name=sprintf("The space scales and Dogs for octaves=%d,%d - Not filtered\n",2*i-1,2*i);
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
                hold on
                indicator_vec=find( keypoints_matrix(1,:)==octave_counter & keypoints_matrix(2,:)==k);  %This vector tells me which columns of the keypoints_matrix have the keypoints I demand.
                data_x=keypoints_matrix(3,indicator_vec);   %The data to be scattered
                data_y=keypoints_matrix(4,indicator_vec);
                scatter(data_y,data_x, 20, 'g', '+')
                hold off
                pause(0.2)
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
            name=sprintf("The space scales and Dogs for octave=%d - Not filtered\n",octaves);
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
                hold on
                indicator_vec=find( keypoints_matrix(1,:)==octave_counter & keypoints_matrix(2,:)==k);  %This vector tells me which columns of the keypoints_matrix have the keypoints I demand.
                data_x=keypoints_matrix(3,indicator_vec);   %The data to be scattered
                data_y=keypoints_matrix(4,indicator_vec);
                scatter(data_y,data_x, 20, 'g', '+')
                hold off
                pause(0.2)

            end
            %Finished printing the DoGs too.
            octave_counter=octave_counter+1;
                
        %Finished for the case when the number of octaves is odd
            
        %If the number of octaves is even, then the final one has two
        %octaves
        else
            name=sprintf("The space scales and Dogs for octaves=%d,%d - Not filtered\n",2*i-1,2*i);
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
                    hold on
                    indicator_vec=find( keypoints_matrix(1,:)==octave_counter & keypoints_matrix(2,:)==k);  %This vector tells me which columns of the keypoints_matrix have the keypoints I demand.
                    data_x=keypoints_matrix(3,indicator_vec);   %The data to be scattered
                    data_y=keypoints_matrix(4,indicator_vec);
                    scatter(data_y,data_x, 20, 'g', '+')
                    hold off
                    pause(0.2)
                end
                %Finished printing the DoGs too.
                octave_counter=octave_counter+1;

            end
        end
        
        
    end
end

%%FINISHED WITH THE NON FILTERED ONES%%
 
 
 
%%Now doing the prints on the DoGs%%
%%NOW ON THE  FILTERED ONES%%
num_figures=ceil(octaves/2);
octave_counter=1;
for i=1:num_figures
    
    %This if clause checks on whether we have reached the final octave:
    if(i<num_figures)
        name=sprintf("The space scales and Dogs for octaves=%d,%d - Filtered\n",2*i-1,2*i);
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
                hold on
                indicator_vec=find( keypointsHighC_matrix(1,:)==octave_counter & keypointsHighC_matrix(2,:)==k);  %This vector tells me which columns of the keypoints_matrix have the keypoints I demand.
                data_x=keypointsHighC_matrix(3,indicator_vec);   %The data to be scattered
                data_y=keypointsHighC_matrix(4,indicator_vec);
                scatter(data_y,data_x, 20, 'g', '+')
                hold off
                pause(0.2)
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
            name=sprintf("The space scales and Dogs for octave=%d - Filtered\n",octaves);
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
                hold on
                indicator_vec=find( keypointsHighC_matrix(1,:)==octave_counter & keypointsHighC_matrix(2,:)==k);  %This vector tells me which columns of the keypoints_matrix have the keypoints I demand.
                data_x=keypointsHighC_matrix(3,indicator_vec);   %The data to be scattered
                data_y=keypointsHighC_matrix(4,indicator_vec);
                scatter(data_y,data_x, 20, 'g', '+')
                hold off
                pause(0.2)

            end
            %Finished printing the DoGs too.
            octave_counter=octave_counter+1;
                
        %Finished for the case when the number of octaves is odd
            
        %If the number of octaves is even, then the final one has two
        %octaves
        else
            name=sprintf("The space scales and Dogs for octaves=%d,%d - Filtered\n",2*i-1,2*i);
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
                    hold on
                    indicator_vec=find( keypointsHighC_matrix(1,:)==octave_counter & keypointsHighC_matrix(2,:)==k);  %This vector tells me which columns of the keypoints_matrix have the keypoints I demand.
                    data_x=keypointsHighC_matrix(3,indicator_vec);   %The data to be scattered
                    data_y=keypointsHighC_matrix(4,indicator_vec);
                    scatter(data_y,data_x, 20, 'g', '+')
                    hold off
                    pause(0.2)
                end
                %Finished printing the DoGs too.
                octave_counter=octave_counter+1;

            end
        end
        
        
    end
end

%%FINISHED WITH THE FILTERED ONES%%
 

%%Now doing the prints on the original image, so that we can see the
%%results of the SIFT algorithm.


%For the non filtered:
%I will find the positions of the salient points on the original image.
for index=1:length(keypoints)
    current_octave=keypoints_matrix(1,index);
    unfiltered_points(:,index)=2^(current_octave-1)*keypoints_matrix(3:4,index);
end
figure("Name","The Image with all the salient points (Not filtered)")
imshow(img)
hold on
scatter(unfiltered_points(2,:), unfiltered_points(1,:), 20, 'g', '+')
pause(0.2)
%Finished with the non filtered


%For the  filtered:
%I will find the positions of the salient points on the original image.
for index=1:length(keypointsHighC)
    current_octave=keypointsHighC_matrix(1,index);
    filtered_points(:,index)=2^(current_octave-1)*keypointsHighC_matrix(3:4,index);
end
figure("Name","The Image with all the salient points (Filtered)")
imshow(img)
hold on
scatter(filtered_points(2,:), filtered_points(1,:), 20, 'g', '+')
%Finished with the non filtered