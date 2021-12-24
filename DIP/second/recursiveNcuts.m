function recursiveNcuts(current_indices, T1, T2)
%---------------------------------------------------------------------
%This function implements the Ncuts algorithm, recursively. Inside the body
%of this function, there are calls to the function itself and this is the
%way I implement the recursion. 
%Inputs:
%        1)current_indices:   I use this variable (vector) to know which
%       elements of the initial affinity matrix are on the subgraph
%       of this current call of the recursiveNcuts.
%        2)T1:                The T1 threshold
%        3)T2:                The T2 threshold
%   The function does not give any output. It works by changing a global
%variable that holds the information of the labels. This Global variable is
%called "final_labels". 
%   The global variable "label_index" is essentially a counter - everytime 
%time we reach a subgraph which cannot be cut any further, we store the
%value of the "label_index" as the label to the corresponding indices and
%then increase this counter.
%   The global variable "affinity_matrix" holds the original affinity.
%I don't pass this one as an argument, as it is a quite large matrix and
%with the recursive calls it would have to be copied many times, which I
%found unnecessary.
%--------------------------------------------------------------------

    %%Getting the global variables
    global label_index; 
    global final_labels; 
    global affinity_matrix;
    %%Finished getting the global variables
    
    
    %Finding the current affinity matrix, using the current_indices and the
    %%original affinity_matrix
    current_affinity=affinity_matrix(current_indices, current_indices);
    %%Finished getting the current affinity matrix
    
    
    %%Applying the standard ncuts(k=2)
    Ncuts_results=myNCuts(current_affinity ,2);
    %%Applied the Ncuts (k=2)
    
    
    %%Finding the indices of the left/right children
    %The elements with a label==1 go to the left child
    %The elements with a label==2 go to the right child
    left_indices=current_indices(find(Ncuts_results==1));
    right_indices=current_indices(find(Ncuts_results==2));
    %%Got the indices of the left/right children
    
    %%Getting the ncut metric value, and checking on whether to apply the
    %%ncuts algorithm to the children or not
    ncut_metric=calculateNcut(current_affinity,Ncuts_results);
    
    %Checking on whether to continue segmenting the children.
    if(length(left_indices)>=T1 && length(right_indices)>=T1 && ncut_metric<=T2)
        recursiveNcuts(left_indices, T1, T2);
        recursiveNcuts(right_indices, T1, T2);
    
        
    %If we do not continue with the children, we store the labels of the
    %current_indices to the final_labels array
    else 
        final_labels(left_indices)=label_index;
        label_index=label_index+1;
        final_labels(right_indices)=label_index;
        label_index=label_index+1;
    end
    %%Finished with the recursive version of Ncuts.


end