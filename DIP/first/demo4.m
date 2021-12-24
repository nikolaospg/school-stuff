%This script opens a Bayer image, converts to Truecolor, resamples, quantises and saves in ppm format

% clc
clear
close all

%1 - Getting the RGB image%
load('march.mat');
xb=x;
xrgb=bayer2rgb (xb);
figure('Name','Initial RGB')
imshow(xrgb)
%Got the RGB image

%2 - Undersampling the image%
N=150;
M=200;
method="linear";
xrgbres= myresize(xrgb , N, M, method);
figure('Name','Resampled RGB')
imshow(xrgbres)
%Finished with the undersampling

%3 - Quantising the image%
n=3;                                    %Num of bits for every word
K=2^n;
w=1/K;
q=imagequant(xrgbres,w,w,w);
figure('Name','Dequantised')
imshow(imagedequant(q,w,w,w))                   %Printing the dequantised image
%Finished quantising the image

%4 - Saving as PPM%
filename="dip_is_fun.ppm";
saveasppm(q, filename , K);
figure('Name','PPM Image')
imshow(filename)
%Finished demo 4.

