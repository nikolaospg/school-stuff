function clusterIdx = myNCuts ( anAffinityMat ,k)
%---------------------------------------------------------------------
%This function implements the basic-universal part of the Normalised cuts
%algorithm, that is used both on the recursive and the non recursive
%version.
%Inputs:
%       1)anAffinityMat->   The affinity matrix describing the graph edges
%       2)k->               The number of clusters that we want to have.
%Output:
%       1)clusterIdx->      The Ids of the cluster (labels).
%--------------------------------------------------------------------



%First computing the laplacian matrix
D=sum(anAffinityMat,2);         %Making the reduction, via summing, to a column
D=diag(D);          %Making the D column a diagonal matrix
L=D-anAffinityMat;
%Finished computing the laplacian matrix


%Solving the generalised eigenvalue problem on the (L,D) pair, 
%i.e. A*V=B*V*lambda
[V, lambda]=eigs(L,D, k, 'sr');
%Found the eigenvectors of the gen. problem, and got the V matrix (every
%column is an eigenvector)

%Applying the kmeans 
clusterIdx=kmeans(V,k);
%Got the Ids of the clusters - Finished the function

end