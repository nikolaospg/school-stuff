%Demo that quantises and dequantises an image

clc
clear
close all


%Getting the data and converting to the RGB image
load('march.mat');
xb=x;
xrgb=bayer2rgb (xb);
%Got the RGB image

%Initialising the w values and calling the quantiser/dequantiser.
%The reasoning for choosing the w values can be found on the report.
n=3;                                                    %Number of bits for every binary word
w=1/(2^n); 
q=imagequant(xrgb, w, w, w);                %The quantised image
xhat=imagedequant(q, w, w, w);              %The dequantised image

figure('Name','Dequantised Image')
imshow(xhat)            %Showing the dequantised image
%Finished with Demo 3.