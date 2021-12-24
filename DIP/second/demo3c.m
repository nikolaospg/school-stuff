clc
clear
close all

%%Making initialisations, getting useful data.
rng(1)

data=load("dip_hw_2.mat");
imIna=data.d2a;        %Getting the images 
imInb=data.d2b;
k=2;                    %I will be performing the recursive Ncuts, therefore k=2 (in every step)

%In the following four commands I initialise the T values. Change these
%values to implement the algorithm with different thresholds:
d2a_T1=5;
d2b_T1=5;

d2a_T2=0.51;
d2b_T2=0.79;
%%Finished making initialisations

%%Getting the affinity matrices
Wa=Image2Graph(imIna);          
Wb=Image2Graph(imInb);

dimensions_a=size(imIna);
dimensions_b=size(imInb);
%%Finished with the affinity matrices


%%Working with the .d2a%%
%First initialising the global variables
global label_index;     %This index helps us know how many labels we have formed up until a specific moment
label_index=1;

global final_labels;    %An array with the final labels
final_labels=zeros(size(Wa,1),1);

global affinity_matrix;        %The affinity matrix corresponding to .d2a. I will later change this variable to have the .d2b affinity
affinity_matrix=Wa;
%Finished with the global variables

%Calling the recursiveNcuts for the d2a image
initial_indices=1:length(final_labels);     %The initial indices are [1,2,3...length(final_labels)], i.e. the initial graph is not segmented yet.          
recursiveNcuts(initial_indices, d2a_T1, d2a_T2);
labelsa=final_labels;
max_labela=max(labelsa);
%Finished with the d2a image ncuts algorithm

%Getting a matrix which can be represented as an image to show the
%segmentation. Also printing the result
labelsa=reshape(labelsa, dimensions_a(1), dimensions_a(2));
labelsa=labelsa';
figure_title=sprintf("Recursive NCuts, .d2a, T1=%d, T2=%d, Clusters=%d",d2a_T1, d2a_T2, max_labela);
figure("Name",figure_title)
imshow(labelsa, [1 max_labela]);
%Showed the result
%%Finished with the .d2a image%%



%%Now working with the .d2b image%%   
%First resetting the global variables to the values they are supposed to
%have on the beginning
label_index=1;

final_labels=zeros(size(Wb,1),1);

affinity_matrix=Wb;
%Finished with the global variables

%Calling the recursiveNcuts for the d2b image
initial_indices=1:length(final_labels);     %The initial indices are [1,2,3...length(final_labels)]
recursiveNcuts(initial_indices, d2b_T1, d2b_T2);
labelsb=final_labels;
max_labelb=max(labelsb);
%Finished with the d2b image ncuts algorithm

%Getting a matrix which can be represented as an image to show the
%segmentation. Also, showing the result
labelsb=reshape(labelsb, dimensions_b(1), dimensions_b(2));
labelsb=labelsb';
figure_title=sprintf("Recursive NCuts, .d2b, T1=%d, T2=%d, Clusters=%d",d2b_T1, d2b_T2, max_labelb);
figure("Name",figure_title)
imshow(labelsb, [1 max_labelb]);
%Showed the result
%%Finished with the .d2b image too%%

