close all
clear 
clc

%Making initialisations, getting useful data.
rng(1)          %Specifying the seed, as told in the exercise.
data=load("dip_hw_2.mat");
W=data.d1a;             %Getting the affinity matrix
k_vec=[2;3;4];      %Vector with the values of k for the clusters.
%Finished with the initialisations

%Now applying the algorithm and printing the results
labels2=mySpectralClustering(W, k_vec(1));  %Clustering, k=2
labels3=mySpectralClustering(W, k_vec(2));  %Clustering, k=3
labels4=mySpectralClustering(W, k_vec(3));  %Clustering, k=4

fprintf("The labels for d1a, with k=2 are :\n")
disp(labels2')
fprintf("The labels for d1a, with k=3 are :\n")
disp(labels3')
fprintf("The labels for d1a, with k=4 are :\n")
disp(labels4')