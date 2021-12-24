%%% This script repeats the process done on ex3 and finds the mean NRMSE q=5 and for various SNR valious (for many repetitions)  %%%
%%% It also makes plots of the mean NRMSE vs the SNR values %%%
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
figure_num=1;
snr_vec=30:-5:-5;
h=[1, 0.93, 0.85, 0.72, 0.59, -0.1];
reps=50;                    %The number of repetitions
NRMSE_matrix_noise=zeros(length(snr_vec),reps);             %Each row corresponds to one q value, each column corresponds to one repetition of the process.
%FInished initialising

for j=1:reps
      %Constructing the signal. In each iteration, the input is changed, so the x is changed too.
       v=exprnd(1, [1,2048]);
       v=v-mean(v);                  %Getting rid of the mean
       x=conv(v, h); 
      %Finished with the construction
      
     %Creating the noisy signals
      y_matrix=zeros(length(snr_vec), length(x));                            %Each row corresponds to one signal
     for i=1:length(snr_vec)
         y=awgn(x, snr_vec(i), 'measured');
         y_matrix(i,:)=y;
     end
     %Finished creating the noisy signals

     %Now calculating the h estimates for every noisy signal
     h_matrix_noise=zeros(length(snr_vec), q+1);
     for i=1:length(snr_vec)
         c3=third_order_cum(y_matrix(i,:), L3, M, 0, 'unbiased', M, 1);
         c3_reduced=c3(21:end, 1:21);
         c3_reduced=c3_reduced';
         h_matrix_noise(i,:)=h_estimate(q, c3_reduced);
     end
     %Finished estimating the h coefficients
     
    % NRMSE calculation:
    for i=1:length(snr_vec)
          NRMSE_matrix_noise(i,j)= NRMSE_calc(y_matrix(i,:), h_matrix_noise(i,:),v);
    end
 
end

means=mean(NRMSE_matrix_noise,2);
figure(figure_num)
figure_num=figure_num+1;
plot(flip(snr_vec),flip(means))
title(" Mean NRMSE vs SNR")
xlabel("SNR")
ylabel("NRMSE")