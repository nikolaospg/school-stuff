%This function takes as an input the A matrix, and applies the operation
%   A+increase_step*I
%   Several times, until the matrix becomes positive definite.
%I check the positive definiteness by demanding that all of the eigenvalues are positive

function ret=force_pos_def(A, increase_step)
    n=length(A);
    while(true)
        current_eigs=eigs(A);
        
        if(length( find( current_eigs>0))==length(current_eigs))
            break
        end
        A=A+increase_step*eye(n);
    end
    ret=A;
end