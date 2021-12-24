%This function is used to convert an image into bayer format to an rgb one.


function xrgb = bayer2rgb(xb)

%I decided to mirror my image, so that I can work with the border pixels in a way that seems more
%correct to me. Specifically, I mirror the pixels that are the neighbours of the border pixels, and not
%the border pixels themselves. This is why I use the wextend function.
mirrored=wextend(2, 'symw', xb, [1 1]);


%To solve my problem, I decided to create some indexing arrays, that will tell me where the R,G or B
%pixels in the raw format image (mirrored) are. 
%I found it easier to study the G pixels as two different teams, the G1 pixels are the ones that have
%B pixels on their left/right, and the G2 pixels have R pixels on their left/right.

%Declaring the Indexing arrays:
G_indexing1=zeros(size(xb));
G_indexing2=zeros(size(xb));
B_indexing=zeros(size(xb));
R_indexing=zeros(size(xb));

%Initialising the indexing arrays
rows_vec=1:2:size(xb,1);
cols_vec=1:2:size(xb,2);

G_indexing1(rows_vec,cols_vec)=1;
G_indexing2(rows_vec+1,cols_vec+1)=1;
B_indexing(rows_vec,cols_vec+1)=1;
R_indexing(rows_vec+1,cols_vec)=1;
%Finished with the indexing arrays


%Now with the masks.
%I though that I could solve the problem using only 4 convolutions on the mirrored image, using 4 different masks
%The first mask gives me the G component on the R and the B pixels of the initial image
%The second mask gives me R component for the B and the B component for the R pixels of the initial image.
%The third mask gives me the R component for the G2 and the B component for the G1 pixels of the in. image.
%The fourth mask gives me the R component for the G1 and the B component for the G2 pixels of the initial image.

%Later on, by convolving and using the correct indexing matrices I get the proper information to store in the final
%RGB image.

%Creating the masks. I multiply by a proper number so that I take the means, and not just a sum.
mask1=[0 1 0;1 0 1; 0 1 0]*0.25;
mask2=[1 0 1; 0 0 0; 1 0 1]*0.25;
mask3=[1 0 1]*0.5;
mask4=[1 ;0 ;1]*0.5;
fprintf('The first kernel is :\n')
disp(mask1)
fprintf('The second kernel is :\n')
disp(mask2)
fprintf('The third kernel is :\n')
disp(mask3)
fprintf('The fourth kernel is :\n')
disp(mask4)
%Finished creating the masks


%Now taking my final RGB values.
%First initialising the R G B arrays.
R=zeros(size(xb));
G=zeros(size(xb));
B=zeros(size(xb));

%Now assigning to them the values from the raw format, before the convolutions.
%The indexing arrays are used for this.
R=xb.*R_indexing;
G=xb.*G_indexing1+xb.*G_indexing2;
B=xb.*B_indexing;

%In the following part, I make the 4 convolutions on my mirrored image. Of course, I only get the 
%valid pixels (as I already padded the image)
%From each convolution I get the proper information for each color (using my indexing arrays)
%and store them in the R G B arrays.
convolution1=conv2(mirrored,mask1, 'valid');            %Convolving with the first mask
Green_for_Red=convolution1.*R_indexing;
Green_for_Blue=convolution1.*B_indexing;
G=G+Green_for_Red+Green_for_Blue;

convolution2=conv2(mirrored,mask2,'valid');           %Convolving with the second mask
Red_for_blue=convolution2.*B_indexing;
Blue_for_red=convolution2.*R_indexing;
R=R+Red_for_blue;
B=B+Blue_for_red;

convolution3=conv2(mirrored(2:end-1,:),mask3,'valid');              %Convolving with the third mask
Red_for_G2=convolution3.*G_indexing2;
Blue_for_G1=convolution3.*G_indexing1;
R=R+Red_for_G2;
B=B+Blue_for_G1;

convolution4=conv2(mirrored(:,2:end-1),mask4,'valid');              %Convolving with the fourth mask
Red_for_G1=convolution4.*G_indexing1;
Blue_for_G2=convolution4.*G_indexing2;
R=R+Red_for_G1;
B=B+Blue_for_G2;
%%Finished with the convolutions and got my final R G B values

xrgb=cat(3,R,G,B);          % Creating the xrgb returned image.
%Finished with the bayer2rgb function
end