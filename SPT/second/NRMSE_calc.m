%The function below makes the x estimation and calculates the NRMSE for a specific h_vec estimation

function [NRMSE, x_est2] =  NRMSE_calc(x, h_vec,v)
 
      %Estimating the x values. Special care has to be taken, because due to the fact the h_vec has a different length than the true one, 
      % the result from the convolution (x_est) has a different length than x. 
      x_est2=zeros(1, length(x));
      x_est=conv(v,h_vec);
      x_est2=x_est(1:length(x));                           %Doing this change because the 2 signals are of different length, therefore the extra ones get chopped of.
      %Finished with the x estimated values
      
      %Calculating the NRMSE
      error_vec=x_est2-x;
      MSE=mean(error_vec.^2);
      RMSE=sqrt(MSE);
      NRMSE=RMSE/(max(x)-min(x));
      %Finished with the NRMSE 
 end