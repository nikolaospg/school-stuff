function nCutValue = calculateNcut ( anAffinityMat , clusterIdx )
%---------------------------------------------------------------------
%This is the function I use to calculate the nCut metric, given a specific
%affinity matrix and a vector with the label information (only 2 different
%labels). 
%Inputs:
%       1)anAffinityMat->   The affinity matrix describing the graph edges
%       2)clusterIdx->      Vector with the label information (1 or 2)
%Output:
%       1)nCutValue->       The value of the nCut metric
%--------------------------------------------------------------------

    %Finding the indices of the nodes belonging to A, B respectively.
    indices_one=find(clusterIdx==1);
    indices_two=find(clusterIdx==2);
    %Found the indices of the nodes.
    
    %Getting the A, B matrices. These matrices come from the Affinity matrix,
    %but by setting every row that comes from an index which does not
    %belong to the respective matrix as zero.
    A_matrix=anAffinityMat;
    A_matrix(indices_two,:)=0;
    
    B_matrix=anAffinityMat;
    B_matrix(indices_one,:)=0;
    %Finished getting A, B matrices
    
    %Finding the association factors. Adding every element of the columns
    %and then adding all of these factors (with the double sum command)
    assoc_AA=sum(sum(A_matrix(:, indices_one),1));  
    assoc_AV=sum(sum(anAffinityMat(:, indices_one),1));
    
    assoc_BB=sum(sum(B_matrix(:, indices_two),1));
    assoc_BV=sum(sum(anAffinityMat(:, indices_two),1));
    %Finished finding the association factors
    
    %Finding the normalised association and then the nCut value
    n_assoc=assoc_AA/assoc_AV + assoc_BB/assoc_BV;
    nCutValue=2-n_assoc;
    %Finished with the algorithm
    

end