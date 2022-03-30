import scipy as sp
import numpy as np
import time



#This function uses the incidence matrix (B) and applies the projection of eq (8)
def get_C(B):   

    t1=time.time()
    m=B.shape[1]                 #Num of edges of the A 

    C=sp.sparse.lil_matrix((m, m))          #Lil format so I can easily create the matrix

    reduced_B=B

    #In each a iteration I Fill up one row of the C matrix. 
    for a in range((m-1)):
        reduced_B=reduced_B[:,1:]           #These are the Bib columns for all the b values that should be used
        current_a_col=B.getcol(a)           #This is the column described by Bia for various i values
        current_a_col=current_a_col.T
        current_a_col=current_a_col.tocsr() 
        prod=current_a_col@reduced_B
        C[a,a+1:m]=prod[0,:]
    
    rows, cols = C.nonzero()
    C[cols, rows] = C[rows, cols]           #Filling the down triangular part
    t2=time.time()
    print("Time needed to project B onto C is ",t2-t1)
    return C

#This function uses the incidence matrix (B) and applies the projection of eq (11).
#The A matrix is used in order to help me easily get the degrees of each node
def get_D(B, A):
    
    t1=time.time()
    m=B.shape[1]      
    D=sp.sparse.lil_matrix((m, m))      #Lil format so I can easily create the matrix

    #Getting the degrees
    degrees=np.sum(A,axis=0)
    degrees=np.ravel(degrees)           #Converting to 1D array

    accepted_degree_indices=np.where(degrees>1)[0]              #the nodes (ids) that have a degree larger than one 
    accepted_degrees=degrees[accepted_degree_indices]

    transf_degrees=np.array([1/(accepted_degrees-1)]).T                    #This applies the 1/(ki-1) transform. I multiply the Bia with this (element wise) to implement eq (11) easily
    #Finished with the degrees

    reduced_B=B[accepted_degree_indices,:]
    for a in range((m-1)):

        reduced_B=reduced_B[:,1:]                                       #These are the Bib columns for all the b values that should be used
        current_a_col=B[accepted_degree_indices,a]
        current_a_col=current_a_col.multiply(transf_degrees)            #1/(ki-1) multiplication
        current_a_col=current_a_col.T
        current_a_col=current_a_col.tocsr() 
        prod=current_a_col@reduced_B

        D[a,a+1:m]=prod[0,:]

    rows, cols = D.nonzero()
    D[cols, rows] = D[rows, cols]           #Filling the down triangular part
    t2=time.time()
    print("Time needed to project B onto D is ",t2-t1)
    return D
    
#This function uses the incidence matrix (B) and applies the projection of eq (15).
#I get the E matrix from equation 14 and then apply the EE-E operation
def get_E1(B, A):
    
    t1=time.time()
    m=B.shape[1]      
    E=sp.sparse.lil_matrix((m, m))

    #Getting the degrees
    degrees=np.sum(A,axis=0)
    degrees=np.ravel(degrees)           #Converting to 1D array

    accepted_degree_indices=np.where(degrees>1)[0]              #the nodes (ids) that have a degree larger than one 
    accepted_degrees=degrees[accepted_degree_indices]

    transf_degrees=np.array([1/(accepted_degrees)]).T                    #This applies the 1/(ki) transform. I multiply the Bia with this (element wise) to implement eq (11) easily
    #Finished with the degrees

    reduced_B=B[accepted_degree_indices,:]
    for a in range((m-1)):

        current_a_col=B[accepted_degree_indices,a]                      
        current_a_col=current_a_col.multiply(transf_degrees)            #1/(ki) multiplication
        current_a_col=current_a_col.T
        current_a_col=current_a_col.tocsr() 
        prod=current_a_col@reduced_B
        reduced_B=reduced_B[:,1:]

        E[a,a:m]=prod[0,:]

    rows, cols = E.nonzero()
    E[cols, rows] = E[rows, cols]           #Filling the down triangular part
    E1=E@E-E
    t2=time.time()
    print("Time needed to project B onto E is ",t2-t1)
    return E1
    
    
