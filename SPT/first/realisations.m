clc
clear
close all

%Initialising the parameters of the computations. One can easily change them, in order to make conclusions on 
% the effects of them 
fprintf("The whole process takes some minutes\n")
N=8192;
L2=128;
L3=64;    
M=256;                          %Change this in order to have different number of samples per segment. 
cross_correlation_test_flag=1;                % If you want to make the correlation test between two timeseries, set =1 else 0.
figure_num=1;
realisation_num=50;
%Finished initialising

%Creating the 50 realisations
X_array=zeros(realisation_num,N);                    %Every row corresponds to one realisation

lamda_vec=[0.12 0.3 0.42 0.19 0.17 0.36];

cos_fun=@(lamda, phi, k)(cos(2*pi*lamda*k + phi));

for j=1:realisation_num
    phi_vec=rand(1,6)*2*pi;
    phi_vec(3)=phi_vec(1)+phi_vec(2);
    phi_vec(6)=phi_vec(4)+phi_vec(5);
    for i=1:6
        X_array(j,:)=X_array(j,:)+cos_fun(lamda_vec(i), phi_vec(i), 1:N);
    end
end
%Finished creating the realisations

%Below I calculate the cross correlation between 2 timeseries and 
% plot it. This is done to see if they are unrelated or not
if(cross_correlation_test_flag==1)
      cross_cor=cum2x(X_array(1,:), X_array(2,:), L2);
      std(X_array(:,1))*std(X_array(:,2));
      cross_cor=cross_cor./(std(X_array(:,1))*std(X_array(:,2)));
      figure(figure_num)
      figure_num=figure_num+1;
      plot(cross_cor)
      title('The cross correlation between the first two timeseries')
end


%Working with the power spectra. I will calculate the power spectrum for every realisation, take the sum and find the mean values
power_spectrum_final=zeros(1,L2+1);

for i=1:realisation_num
   
      autocor=cumest(X_array(i,:), 2, L2, N); 
      autocor=autocor(round(length(autocor)/2):end);
      power_spec=fft(autocor);  
      power_spectrum_final=power_spectrum_final+power_spec';
end
power_spectrum_final=power_spectrum_final./realisation_num;

%Ploting the Power spectrum, without the use of the window
figure(figure_num)
figure_num=figure_num+1;
plot(abs(power_spectrum_final))
title('Power Spectrum - 50 Realisations')
%Finished working with the power spectrum


%%%%%Now with the bispectrum:

%%%Indirect Method:I wrote the bispeci_changed, which is a variation of the bispeci function, with the difference that it
% does not plot the contour.

%Rectangular window
rectangular_final=zeros(M,M);
for i=1:realisation_num
      rectangular_indirect=bispeci_changed(X_array(i,:), L3, M, 0, 'unbiased', M, 1);                %I choose nfft=M
      rectangular_final=rectangular_final+rectangular_indirect;
end
rectangular_final=rectangular_final./realisation_num;

figure(figure_num)
figure_num=figure_num+1;
mesh(abs(rectangular_final))      %3D plot of the magnitude of the bispectrum
title("The bispectrum with the rectangular, 3D")


%Finished with the rectangular window

%Parzen window
parzen_final=zeros(M,M);
for i=1:realisation_num
      parzen_indirect=bispeci_changed(X_array(i,:), L3, M, 0, 'unbiased', M, 0);              %I choose nfft=M
      parzen_final=parzen_final+parzen_indirect;
end
parzen_final=parzen_final./realisation_num;

figure(figure_num)
figure_num=figure_num+1;
mesh(abs(parzen_final))      %3D plot of the magnitude of the bispectrum
title("The bispectrum with the parzen, 3D")

%Finished with the Parzen window

%%%Finished with the indirect method 

%Now Using the Direct Method:I wrote the bispecd_changed, which is a variation of the bispeci function, with the difference that it
% does not plot the contour.
direct_final=zeros(M,M);
for i=1:realisation_num
      direct=bispecd_changed(X_array(i,:),  M, 1,  M, 0);                %I choose nfft=M
      direct_final=direct_final+direct;
end
direct_final=direct_final./realisation_num;

figure(figure_num)
figure_num=figure_num+1;
mesh(abs(direct_final))      %3D plot of the magnitude of the bispectrum
title("The bispectrum with the direct method, 3D")




