% % %The script containing the main implementations

pkg load statistics
pkg load communications
clc
clear
close all

%Initialising the variables
N=2048;
M=64;
L3=20;
figure_num=1;

%%% PART 0 %%%
%Creating the processes of the system. 
q=5;
q_vec=[q-2, q, q+3];
h=[1, 0.93, 0.85, 0.72, 0.59, -0.1];
v=exprnd(1, [1,2048]);
v=v-mean(v);                  %Getting rid of the mean
x=conv(v, h);                 % The x is the output of an LTI system, with impulse response h and input v
figure(figure_num)            %Plotting my timeseries to have a nice visual undestanding
figure_num=figure_num+1;
plot(x)
title('The  timeseries')
%finished creating the processes

%%% PART 1 %%%
% Studying the skewness 
% Calculating the skewness with the way defined in the exercise
input_skew=sum( (v-mean(v)) .^3);
input_skew=input_skew/(( N-1) *(std(v)^3));
fprintf("Let us suppose that the input timeseries is gaussian. This means that the estimated skewness should be around zero.\n")
fprintf("But, as we see, the estimated skewness=%f >>0, so we are quite sure that the input timeseries is not gaussian.\n\n",input_skew)
% With the skewness value, we can easily make a statistical test. 
% If the input timeseries was gaussian, then the skewness estimate should have been near zero. 
%Finished part 1

%%% PART 2 %%%
% Estimating the third order cumulants.
c3=third_order_cum(x', L3, M, 0, 'unbiased', M, 1);              % Estimating
%Below I will be making some plots , to have a visual understanding of my results
%Making a mesh
figure(figure_num)
figure_num=figure_num+1;
mesh(-20:20, -20:20, c3)
title("3D plot of the c_3")

%Making a contour
figure(figure_num)
figure_num=figure_num+1;
contour(-20:20, -20:20,c3) 
title("Contour of the c_3")

%I decided to get the upper right quarter of the c3 estimation. This will later help me get the row I will have to use for the implementation of Giannakis' Formula.
% I make plots for these as well
c3_reduced=c3(21:end, 1:21);
c3_reduced=c3_reduced';
reduced_length=length(c3_reduced(:,1));             %The length of one column of the reduced vector
figure(figure_num)
figure_num=figure_num+1;
mesh(0:20, 20:-1:0, c3_reduced)
title("3D plot of the reduced c_3")

%For this contour, I also make a scatter plot with the useful column (the elements I need for Giannakis' formula)
figure(figure_num)
figure_num=figure_num+1;
contour(0:20, 20:-1:0,c3_reduced) 
title("Contour of the reduced c_3")
hold on
scatter(q*ones(q+1,1), 0:q, 'r', 'x')               
second_label = sprintf('The useful column, q=%d',q);
legend('The contour (upper-right)', second_label)
%Finished estimating the third order cumulants and made the plots
%Finished part 2


%%% PART 3 , 4 %%%
%% Estimating the parameters. I do this for all three values of the q estimation
h_matrix=h_estimate(q_vec, c3_reduced);                     %This is the function that I wrote specifically for the h estimation

%Displaying the results
fprintf("The h estimates are:\n")
fprintf("q=%d      ",q_vec(1))
disp(h_matrix(1,:))
fprintf("\nq=%d       ",q_vec(2))
disp(h_matrix(2,:))
fprintf("\nq=%d       ",q_vec(3))
disp(h_matrix(3,:))
fprintf("\n\n")
%Finished displaying the results

%Finished parts 3 and 4


%%% PART 5 , 6 %%%
%% Finding the NRMSE and judging on the best model
% The calculation is done for all three different q values (the true one and the sub/sup estimated.
NRMSE_matrix=zeros(length(q_vec),1);
for i=1:length(q_vec)
      NRMSE_matrix(i)= NRMSE_calc(x, h_matrix(i,:),v);
end

%Displaying the results
fprintf("The NRMSE calculations are:\n")
fprintf("q=%d      ",q_vec(1))
disp(NRMSE_matrix(1,:))
fprintf("\nq=%d       ",q_vec(2))
disp(NRMSE_matrix(2,:))
fprintf("\nq=%d       ",q_vec(3))
disp(NRMSE_matrix(3,:))
fprintf("\n")
%Finished displaying the results
%%Finished parts 5,6 

%%% PART 7 %%%
%First creating the noise infected signals (y)
snr_vec=30:-5:-5;
y_matrix=zeros(length(snr_vec), length(x));                            %Each row corresponds to one signal
for i=1:length(snr_vec)
    y=awgn(x, snr_vec(i), 'measured');
    y_matrix(i,:)=y;
end
%Finished with the noised signal creation

%Now finding the h coefficients estimated by the noised signals. The process followed is similar to the I followed before
%for parts 3,4.
h_matrix_noise=zeros(length(snr_vec), q+1);
for i=1:length(snr_vec)
    c3=third_order_cum(y_matrix(i,:), L3, M, 0, 'unbiased', M, 1);
    c3_reduced=c3(21:end, 1:21);
    c3_reduced=c3_reduced';
    h_matrix_noise(i,:)=h_estimate(q, c3_reduced);
end
%Finished estimating the h coefficients

%Now calculating and ploting the NRMSE
NRMSE_matrix_noise=zeros(1,length(snr_vec));
for i=1:length(snr_vec)
      NRMSE_matrix_noise(i)= NRMSE_calc(y_matrix(i,:), h_matrix_noise(i,:),v);
end

figure(figure_num)
figure_num=figure_num+1;
plot(flip(snr_vec),flip(NRMSE_matrix_noise))
title("NRMSE vs SNR")
xlabel("SNR")
ylabel("NRMSE")
%Finished with the calculations and the plots.
%Finished part 7

