clc
clear
close all

%Making initialisations, getting useful data.
rng(1)

data=load("dip_hw_2.mat");
imIna=data.d2a;        %Getting the images 
imInb=data.d2b;
k=2;
%Finished making initialisations


%%%NOW APPLYING THE ALGORITHM%%%
%Getting the affinity matrices and the dimensions
Wa=Image2Graph(imIna);          
Wb=Image2Graph(imInb);

dimensions_a=size(imIna);
dimensions_b=size(imInb);
%Finished getting the affinity matrices

%Getting the columns with the labels 
labelsa= myNCuts ( Wa ,k);
labelsa_column=labelsa;         %I get the column to pass to the ncut metric calculation (the labelsa will be reshaped to a matrix)
labelsb= myNCuts ( Wb ,k);
labelsb_column=labelsb;     %I get the column to pass to the ncut metric calculation (the labelsb will be reshaped to a matrix)
%Got the labels

%Converting the columns to matrices that are showable as images
labelsa=reshape(labelsa, dimensions_a(1), dimensions_a(2));
labelsa=labelsa';

labelsb=reshape(labelsb, dimensions_b(1), dimensions_b(2));
labelsb=labelsb';
%Finished getting the matrices 

%Printing the 2 images
figure("Name","d2a, k=2, Ncuts")
imshow(labelsa,[1 2])
figure("Name","d2b, k=2, Ncuts")
imshow(labelsb, [1 2])
%Finished printing the images

%Calculating the Ncut metric
ncut_metrica=calculateNcut(Wa, labelsa_column);
ncut_metricb=calculateNcut(Wb, labelsb_column);

fprintf("The Ncut metric for the first image is :\n")
disp(ncut_metrica)
fprintf("The Ncut metric for the second image is :\n")
disp(ncut_metricb)
%%%FINISHED WITH THE DEMO%%%