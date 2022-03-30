import matplotlib.pyplot as plt
import networkx as nx
from networkx.algorithms import community
import time
from louvain import louvain_communities
from functions import get_C,get_D,get_E1


#Using the algorithm to find communities on the Karate Club Graph
#It is done mainly to check for correctness

#Opening the Karate Club Graph
G = nx.karate_club_graph()

#Creating Up useful matrices
A=nx.adjacency_matrix(G)
B=nx.incidence_matrix(G)        #Getting the B (incidence matrix)
C=get_C(B)                      
D=get_D(B,A)        
E1=get_E1(B,A)         


#Optimising the Q(A)
t1=time.time()
communities=louvain_communities(G, seed=42)
t2=time.time()
print("\nTime needed for Q(A) optimisation",t2-t1)
print("# Communities detected:",len(communities))
print("Q(A) final modularity",community.modularity(G, communities),"\n")



#Optimising the Q(C)
GC=nx.from_scipy_sparse_matrix(C)
t1=time.time()
communities_C=louvain_communities(GC, seed=42)
t2=time.time()
print("Time needed for Q(C) optimisation",t2-t1)
print("# Communities detected:",len(communities_C))
print("Q(C) final modularity",community.modularity(GC, communities_C),"\n")

#Optimising the Q(D)
GD=nx.from_scipy_sparse_matrix(D)
t1=time.time()
communities_D=louvain_communities(GD, seed=42)
t2=time.time()
print("Time needed for Q(D) optimisation",t2-t1)
print("# Communities detected:",len(communities_D))
print("Q(D) final modularity",community.modularity(GD, communities_D),"\n")

#Optimising the Q(E1)
GE1=nx.from_scipy_sparse_matrix(E1)
t1=time.time()
communities_E1=louvain_communities(GE1, seed=42)
t2=time.time()
print("Time needed for Q(E1) optimisation",t2-t1)
print("# Communities detected:",len(communities_E1))
print("Q(E1) final modularity",community.modularity(GE1, communities_E1))

