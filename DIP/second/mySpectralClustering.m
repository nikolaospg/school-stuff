function clusterIdx = mySpectralClustering ( anAffinityMat , k)
%---------------------------------------------------------------------
%This function implements the Spectral Clustering algorithm, as specified
%in the exercise.
%Inputs:
%       %1)anAffinityMat:   The affinity matrix describing the edges of a graph.
%   In our exercise, this graph is used to implement algorithms for the image
%   segmentation
%
%2)k: The number of clusters that will be formed.
%Output:
%       1)clusterIdx->      The Ids of the cluster (labels).
%--------------------------------------------------------------------


%First computing the laplacian matrix
D=sum(anAffinityMat,2);         %Making the reduction, via summing, to a column
D=diag(D);          %Making the D column a diagonal matrix
L=D-anAffinityMat;
%Finished computing the laplacian matrix

%Now computing the eigenvalues of the laplacian and forming the eigenvector
%matrix
[V,lambda]=eigs(L,k, 'sr');   %V is the matrix where every column is an eigenvector. 
%Finished with the eigenvector matrix (V)

%Applying the kmeans clustering:
clusterIdx=kmeans(V,k);
%Finished with kmeans and got my labels




end