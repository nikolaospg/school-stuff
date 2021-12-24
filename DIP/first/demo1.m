%In this script I use the data from an RGB format and convert it to RGB, using the bayer2rgb function


clc
clear
close all

%Getting the data
load('march.mat');
xb=x;
%Finished getting the data from the .mat

%Calling my function and printing the image
xrgb=bayer2rgb (xb);
figure('Name','RGB Image')
imshow(xrgb)
%Demo1 finished.
