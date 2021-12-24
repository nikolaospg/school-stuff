clc
clear
close all

%Initialising the parameters of the computations. One can easily change them, in order to make conclusions on 
% the effects of them 
N=8192;
L2=128;
L3=64;    
M=256;                          %Change this in order to have different number of samples per segment. 
figure_num=1;
%Finished initialising

%%% PART 1 %%%
%First, we will be constructing our signal

lamda_vec=[0.12 0.3 0.42 0.19 0.17 0.36];
phi_vec=rand(1,6)*2*pi;
phi_vec(3)=phi_vec(1)+phi_vec(2);
phi_vec(6)=phi_vec(4)+phi_vec(5);

cos_fun=@(lamda, phi, k)(cos(2*pi*lamda*k + phi));          %Function handle to easily generate the cosinge values

X=zeros(1,N);
for i=1:6
    X=X+cos_fun(lamda_vec(i), phi_vec(i), 1:N);
end

figure(figure_num)
figure_num=figure_num+1;
plot(X)
title('Plot of our timeseries')
%Finished constructing the X signal


%%% PART 2 %%%
% Estimating the Power spectrum. I decided to do this, by estimating the autocorrelation function and then
% applying the fourier transform - an indirect method.
% The signal is created from a process that I know has a mean=0, this is why I don't think it is necessary
% to make the X=X-mean(X) transform. Also, I do not create time segments and take the timeseries as a whole

autocor=cumest(X, 2, L2, N);                              %%Estimating the autocorrelation, using the second order cumulant (mean(X)~0)
autocor=autocor(round(length(autocor)/2):end);

%For the power spectrum, I Decided to make the estimation both with and without a Parzen window
##power_spec=fft((autocor));                        %%Applying the FFT on the autocorrelation to get the power spectrum

%Ploting the Power spectrum, without the use of the window
figure(figure_num)
figure_num=figure_num+1;
plot(abs(fft((autocor))))
title('Power Spectrum, Without window')
xlabel('sample num, u')

%Now applying the window as well.
parzen_win=lagwind(L2,'pa')';
power_spec_window=fft(autocor(2:end).*parzen_win);
figure(figure_num)
figure_num=figure_num+1;
plot(abs(power_spec_window))
title('Power Spectrum, Parzen window')
xlabel('sample num, u')
%Finished with the powerspectrum


%%% PART 3,4 %%%
%Now with the bispectrum

%Indirect Method: I will be using the bispeci function from the HOSA toolbox, to help me estimate the bispectra with the two windows.
%Rectangular window 
figure(figure_num)
figure_num=figure_num+1;
[rectangular_indirect, rectangular_freqs]=bispeci(X', L3, M, 0, 'unbiased', M, 1);                %I choose nfft=M
title("The bispectrum with the rectangular")
figure(figure_num)
figure_num=figure_num+1;
mesh(abs(rectangular_indirect))      %3D plot of the magnitude of the bispectrum
title("The bispectrum with the rectangular, 3D")


%Parzen window
figure(figure_num)
figure_num=figure_num+1;
[parzen_indirect, parzen_freqs]=bispeci(X', L3, M, 0, 'unbiased', M, 0);              %I choose nfft=M
title("The bispectrum with the Parzem")
figure(figure_num)
figure_num=figure_num+1;
mesh(abs(parzen_indirect))         %3D plot of the magnitude of the bispectrum
title("The bispectrum with the Parzen, 3D")

 %Finished with the Parzen window
%Finished with the indirect method 

%Now Using the direct method. bispecd is the command I use.
figure(figure_num)
figure_num=figure_num+1;
[bispectrum_direct, direct_freqs]=bispecd(X',  M, 1,  M, 0);                                %I choose nfft=M
title("The bispectrum with the direct")
figure(figure_num)
figure_num=figure_num+1;
mesh(abs(bispectrum_direct))         %3D plot of the magnitude of the bispectrum
title("The bispectrum with the direct, 3D")


figure(figure_num)
figure_num=figure_num+1;
mesh(angle(bispectrum_direct)) 
title('The phase of the bispectrum, direct method')

%Finished with the direct method too.
%Finished estimating the bispectrum

