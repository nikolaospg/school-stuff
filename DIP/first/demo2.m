%This script demonstrates the process of image resampling, as done by the myresize function

clc
clear
close all

%Loading the file, and using me bayer2rgb function to get the truecolor image
load('march.mat')
xb=x;
xrgb=bayer2rgb (xb);
%Finished getting the rbg image.

%Initialising the proper arguments and calling myresize.m function
%For the nearest neighbour case
method="nearest";
N=240;
M=320;
xrgbres_nearest= myresize(xrgb , N, M, method);

%For the bilinear interpolation case
method="linear";
N=200;
M=300;
xrgbres_linear = myresize(xrgb , N, M, method);
%Finished with the function calls

%Printing my results
figure('Name','Nearest Neighbours')
imshow(xrgbres_nearest)
figure('Name','Bilinear Interpolation')
imshow(xrgbres_linear)
%Finished with demo2

