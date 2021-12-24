%Function I use to reshape my images, using either nearest neighbour or the bilinear interpolation method.

function xrgbres = myresize (xrgb , N, M, method )
    [N0 M0]=size(xrgb(:,:,1));             %Getting the dimensions of the original image

    %Case of the nearest neighbour algorithm
    if(method=="nearest")
        fprintf("Resampling with the nearest neighbour method, N=%d, M=%d,\n",N,M)
        xrgbres=zeros(N,M,3);

        %Finding the x_vec, y_vec vectors, tha tell me the exact locations
        %of the pixels of the downsampled image.
        %I "move" the new image so that the 2 versions (original and resampled) have the same
        %centre. This is done with the diff variable.
        x_step=N0/N;
        x_vec=(1:x_step:N0);
        diff=N0-max(x_vec);                  
        x_vec=x_vec+diff/2;
        x_vec=x_vec';

        y_step=M0/M;
        y_vec=(1:y_step:M0);
        diff=M0-max(y_vec);
        y_vec=y_vec+diff/2;
        %Got the positions of the samples for the new image.

        %Double for loop to implement the nearest neighbour interpolation method.
        %For each point (pixel) of the new image, I find the nearest pixel on the plane
        %of the original image. The value I give to the pixel of the resampled is the 
        %value of this nearest pixel
        for i=1:N
            x_temp=x_vec(i);
            x_temp=round(x_temp);               %With the round command I find the nearest integer, which is the coordinate on the original Image.
            for j=1:M
                y_temp=y_vec(j);
                y_temp=round(y_temp);
                xrgbres(i,j,:)=xrgb(x_temp,y_temp,:);
            end
        end
        %Finished calculating the xrgbres values
    end
    %Finished with the NN algorithm.
    
    
    %Case of the linear interpolation algorithm
    if(method=="linear")
        fprintf("Resampling with the bilinear interpolation method, N=%d, M=%d,\n",N,M)
        xrgbres=zeros(N,M,3);
        
        %Finding the x_vec, y_vec vectors, tha tell me the exact locations
        %of the pixels of the downsampled image.
        %I "move" the new image so that the 2 versions (original and resampled) have the same
        %centre. This is done with the diff variable.
        x_step=N0/N;
        x_vec=(1:x_step:N0);
        diff=N0-max(x_vec);
        x_vec=x_vec+diff/2;
        x_vec=x_vec';

        y_step=M0/M;
        y_vec=(1:y_step:M0);
        diff=M0-max(y_vec);
        y_vec=y_vec+diff/2;
        %Got the positions of the samples for the new image.

        %Double for loop to implement the bilinear interpolation method.
        %In each iteration of the double for loop, I get the coefficients of one pixel of the new resampled image
        %and apply the bilinear interpolation method, by calling my function (bilinearinterp.m).
        for i=1:N
            x_temp=x_vec(i);
            for j=1:M
                y_temp=y_vec(j);

                xrgbres(i,j,:)=bilinearinterp(xrgb,x_temp,y_temp);
            end
        end
        %Finished calculating the xrgbres values
    end
end