clc
clear

time_vec=0:1e-5:2;      %This vector has the time moments for the signal sampling.
error_flag=0;               %If error_flag==1 -> Outliers are added, else we do not add any outliers.

%Creating function handles for the inputs and getting the measurements, with the time_vector specified above.
u1=@(t)(2*sin(t));
u2=@(t)(1);         %Creating a function handle, in case the user wants to change the input
u1_meas=u1(time_vec)';
u2_meas=ones(1,length(time_vec))';
%finished with the function handles and the input measurements

%Now measuring the outputs. The measurement will be achieved with the v.p. file
Vr_meas=zeros(length(time_vec),1);
Vc_meas=zeros(length(time_vec),1);
for i=1:length(time_vec)                %For loop used to get all the values of output voltage values.
    y_meas=v(time_vec(i));
    Vr_meas(i)=y_meas(2);
    Vc_meas(i)=y_meas(1);
end
figure(1)
plot(time_vec, Vc_meas)
title('The measurements of Vc')
figure(2)
plot(time_vec, Vr_meas)
title('The measurements of Vr')
%Finished with the measurements
% a=dynamics2
%Adding outliers in the data (to check the robustness of this method).
%Only happens when error_flag==1
if(error_flag==1)
    fprintf('The value of the error_flag==1, so we add outliers\n')
    Vc_meas(ceil(length(Vc_meas)/4))=1e3;
    Vc_meas(ceil(2*length(Vc_meas)/4))=1e3;
    Vc_meas(ceil(3*length(Vc_meas)/4))=1e3;
end
%Finished adding the outliers

%Estimating the parameters. The following part is just the implementation of the theoretical analysis,
% as shown in the report

%    At first, I create the filters and then filter the measured data.
pole1=-100;           %Easily changing the poles of the filters.
pole2=-100;
lamda_coeffs=[1 -[pole1+pole2] pole1*pole2];        % The coefficients for the lamda polynomial
filt1=tf([1 0 0],lamda_coeffs);                                 %The filters, as desbrideb in the report.
filt2=tf([1 0], lamda_coeffs);
filt3=tf(1, lamda_coeffs);
z_meas=lsim(filt1, Vc_meas, time_vec);
phi1=-lsim(filt2, Vc_meas, time_vec);
phi2=-lsim(filt3, Vc_meas, time_vec);
phi3=lsim(filt2, u2_meas, time_vec);
phi4=lsim(filt3, u2_meas, time_vec);
phi5=lsim(filt2, u1_meas, time_vec);
PHI=[phi1 phi2 phi3 phi4 phi5];
%    Finished filtering and got the PHI array.

%Doing the rest of the calculations with the arrays.
PHI_TR=PHI';
Q=PHI_TR*PHI;
R=(z_meas')*PHI;
theta_star=R*inv(Q);

format shortEng
%The thera_star(1,3,5) all estimate the same parameter, so I just get the mean value 
% for the final estimation. The same goes for the thera_star(2,4)
first_parameter=mean([theta_star(1) theta_star(3) theta_star(5)]);         
second_parameter=mean([theta_star(2) theta_star(4)]);
fprintf('The estimations are:\n1/RC-> %f\n1/LC-> %f\n', first_parameter,second_parameter);
%Finished with the calculations and the estimations


%Now doing simulations, to compare the simulated results with the values that I measured.
x0=[0 0];
eq_handle=@(t,state)dynamics2(t, state, u1, u2, 1/first_parameter, 1/second_parameter);
%The simulation is done by solving the differential equations, with the proper parameters and initial state.
[t, state]=ode45(eq_handle, time_vec, x0);    

figure(3)
plot((Vc_meas- state(:,1))./Vc_meas)
title('The difference between measured and estimated')
statistic=mean((Vc_meas-state(:,1)).^2);
fprintf('The value of the comparison statistic is %f\n',statistic);
