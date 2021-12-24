%%% This script repeats the process done on ex3 and finds the mean NRMSE for q=3, q=5, q=8 for many repetitions  %%%
%%% This file does not make any plots. For the various SNR values, look at the next file %%%
% pkg load statistics
% pkg load communications
clc
clear
close all
fprintf("The process takes less than a couple of minutes\n")

%Initialising useful variables
N=2048;
M=64;
L3=20;
q=5;
q_vec=[q-2, q, q+3];
h=[1, 0.93, 0.85, 0.72, 0.59, -0.1];
reps=100;                    %The number of repetitions
NRMSE_matrix=zeros(length(q_vec),reps);             %Each row corresponds to one q value, each column corresponds to one repetition of the process.
%FInished initialising

for j=1:reps
    %Constructing the signal. In each iteration, the input is changed, so the x is changed too.
    v=exprnd(1, [1,2048]);
    v=v-mean(v);                  %Getting rid of the mean
    x=conv(v, h); 
    %Finished with the construction
    
    %Estimating the cumulants
    c3=third_order_cum(x', L3, M, 0, 'unbiased', M, 1);   
    c3_reduced=c3(21:end, 1:21);
    c3_reduced=c3_reduced';
    reduced_length=length(c3_reduced(:,1));             
    %Finished with the cumulant estimation
    
    %Estimating the h values and calculating the NRMSE
      h_matrix=h_estimate(q_vec, c3_reduced); 
      for i=1:length(q_vec)
          NRMSE_matrix(i,j)= NRMSE_calc(x, h_matrix(i,:),v);
      end
      %Finished with the NRMSE
end

means=mean(NRMSE_matrix,2)
num1gr2=length(find(NRMSE_matrix(1,:)>NRMSE_matrix(2,:)));
num3gr2=length(find(NRMSE_matrix(3,:)>NRMSE_matrix(2,:)));

%Console prints
fprintf("The mean values for the NRMSE are:\n")
fprintf("q=%d    %d  \n",q_vec(1),means(1))
fprintf("q=%d    %d  \n",q_vec(2),means(2))
fprintf("q=%d    %d  \n",q_vec(3),means(3))
fprintf("\n") 
fprintf("In %d out of %d iterations the q=3 had a higher NRMSE than q=5\n",num1gr2, reps)
fprintf("In %d out of %d iterations the q=8 had a higher NRMSE than q=5\n",num3gr2, reps)

