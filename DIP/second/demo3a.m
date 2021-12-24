close all
clear 
clc

%Making initialisations, getting useful data.
rng(1)          %Specifying the seed, as told in the exercise.

data=load("dip_hw_2.mat");
imIna=data.d2a;             %Getting the first image
imInb=data.d2b;             %Getting the second image

k_vec=[2;3;4];      %Vector with the values of k for the clusters.
%Finished with the initialisations


%%%NOW APPLYING THE ALGORITHM%%%

%%For the first image (d2a):
dimensions_a=size(imIna);      %Getting the dimensions of the image
Wa=Image2Graph(imIna);        %Getting the affinity matrix

%Getting the columns with the labels
labels2a=myNCuts(Wa, k_vec(1));  %Clustering, k=2
labels3a=myNCuts(Wa, k_vec(2));  %Clustering, k=3
labels4a=myNCuts(Wa, k_vec(3));  %Clustering, k=4
%Finished getting the columns

%Converting the columns to matrices that are showable as images
labels2a=reshape(labels2a, dimensions_a(1), dimensions_a(2));
labels2a=labels2a';

labels3a=reshape(labels3a, dimensions_a(1), dimensions_a(2));
labels3a=labels3a';

labels4a=reshape(labels4a, dimensions_a(1), dimensions_a(2));
labels4a=labels4a';
%Finished the conversions, now the the matrices are printable as images
%%Finished with the first one

%%For the second image(d2b)
dimensions_b=size(imInb);      %Getting the dimensions of the image
Wb=Image2Graph(imInb);        %Getting the affinity matrix

%Getting the columns with the labels
labels2b=myNCuts(Wb, k_vec(1));  %Clustering, k=2
labels3b=myNCuts(Wb, k_vec(2));  %Clustering, k=3
labels4b=myNCuts(Wb, k_vec(3));  %Clustering, k=4
%Finished getting the columns

%Converting the columns to matrices that are showable as images
labels2b=reshape(labels2b, dimensions_b(1), dimensions_b(2));
labels2b=labels2b';

labels3b=reshape(labels3b, dimensions_b(1), dimensions_b(2));
labels3b=labels3b';

labels4b=reshape(labels4b, dimensions_b(1), dimensions_b(2));
labels4b=labels4b';
%%Finished with the second image

%%Now printing the images
figure("Name","Non Recursive Ncuts Results")
subplot(2,3,1)
imshow(labels2a,[1 2])
title(".d2a, k=2")

subplot(2,3,2)
imshow(labels3a,[1 3])
title(".d2a, k=3")

subplot(2,3,3)
imshow(labels4a, [1 4])
title(".d2a, k=4")

subplot(2,3,4)
imshow(labels2b, [1 2])
title(".d2b, k=2")

subplot(2,3,5)
imshow(labels3b, [1 3])
title(".d2b, k=3")

subplot(2,3,6)
imshow(labels4b, [1 4])
title(".d2b, k=4")
%%%FINISHED WITH THE DEMO%%%

