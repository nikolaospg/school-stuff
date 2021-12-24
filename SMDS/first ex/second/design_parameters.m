%In this script, I present the method that I followed in order to choose the various parameters 
% that helped me create the algorithms in the simulate2.m file

%%% CHANGE THE FOLLOWING VARIABLE TO MAKE THE PROPER TEST%%%
%% The check_flag=1 makes the test on the sampling time limit.
%% The check_flag=2 makes the test on the sampling period
%% The check_flag=3 makes the test on the pole position
%% The check_flag=4 makes the test on the ode solver
clear
check_flag=1;
clc



%%% 1 %%%
%In the following lines, I show in plots what the results of the measurements where, for both
% the Vr and Vc outputs. These helped choose when to stop the process of sampling
% I took a sampling period of 1e-6 and stopped at 10 seconds.
if(check_flag==1)
    fprintf('Testing for the time limit of sampling. The process takes a couple of minutes.\n\n')
    time_vec=0:1e-6:10;
    u1=@(t)(2*sin(t));
    u2=@(t)(1);         %Creating a function handle, in case the user wants to change the input
    u1_meas=u1(time_vec)';
    u2_meas=ones(1,length(time_vec))';
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
    ylabel('Volt')
    xlabel('sec')
    figure(2)
    plot(time_vec, Vr_meas)
    title('The measurements of Vr')
    ylabel('Volt')
    xlabel('sec')
    fprintf('As we see, the Vc settles to 1, after 1 second and the Vr clearly oscillates, from t=2sec onwards.\n')
    fprintf('Therefore, I thought that a proper time to stop sampling is t=2sec, as the measurements (and especially Vc)\n')
    fprintf('have already reached their steady state for some time, and therefore I would have enough info on how\n')
    fprintf('the system behaves by choosing this upper limit.\n')
end
%Finished with deciding when to stop the sampling process

%%% 2 %%%
% In the following lines, I test how the sampling period affects the results that I have. I repeat the
% process done in simulate2.m 11 times, and each time I use a different sampling period. The 
% poles are constant (at -100) and the limit of the sampling time is 2 seconds. The sampling periods
% are from the span of 1e-6 up to 1e-4.
if (check_flag==2)
    fprintf('Testing for the sampling period. The process takes a couple of minutes.\n\n')
    time_periods=[1e-6, 3e-6, 5e-6, 7e-6, 9e-6, 1e-5, 3e-5, 5e-5, 7e-5, 9e-5, 1e-4]; 
    for j=1:length(time_periods)
        time_vec=0:time_periods(j):2;
        u1=@(t)(2*sin(t));
        u2=@(t)(1);         %Creating a function handle, in case the user wants to change the input
        u1_meas=u1(time_vec)';
        u2_meas=ones(1,length(time_vec))';

        Vr_meas=zeros(length(time_vec),1);
        Vc_meas=zeros(length(time_vec),1);
        for i=1:length(time_vec)                %For loop used to get all the values of output voltage values.
            y_meas=v(time_vec(i));
            Vr_meas(i)=y_meas(2);
            Vc_meas(i)=y_meas(1);
        end

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
        PHI_TR=PHI';
        Q=PHI_TR*PHI;
        R=(z_meas')*PHI;
        theta_star=R*inv(Q);

        first_parameter=mean([theta_star(1) theta_star(3) theta_star(5)]);         
        second_parameter=mean([theta_star(2) theta_star(4)]);

        x0=[0 0];
        eq_handle=@(t,state)dynamics2(t, state, u1, u2, 1/first_parameter, 1/second_parameter);
        [t, state]=ode45(eq_handle, time_vec, x0);    
        statistics_vector(j)=mean((Vc_meas-state(:,1)).^2);
    end
    plot(time_periods,statistics_vector)
    title('The statistic for various sampling periods')
    fprintf('As we see from the plot and the results, the minimun value of the statistic is achieved\n')
    fprintf('at a period of 1e-5. This is our criterion in choosing the 1e-5 for our samping period.\n')
end
%Finished with the sampling period choice



%%% 3 %%%
% Testing for the position of the poles. By using the sampling period I chose before, 
% I change the values of the poles from -10 to -210 and each time the poles are equal.
% The main goal of this test is to check whether the double pole on -100 gives of a good result or not.
% If the result is not appropriate, then I would have to pick some other value and repeat the second test.
if(check_flag==3)
     fprintf('Testing for the pole positions. The process takes a couple of minutes.\n\n')
     time_vec=0:1e-5:2;
     u1=@(t)(2*sin(t));
     u2=@(t)(1);         %Creating a function handle, in case the user wants to change the input
     u1_meas=u1(time_vec)';
     u2_meas=ones(1,length(time_vec))';
     
     Vr_meas=zeros(length(time_vec),1);
     Vc_meas=zeros(length(time_vec),1);
     for i=1:length(time_vec)                %For loop used to get all the values of output voltage values.
         y_meas=v(time_vec(i));
         Vr_meas(i)=y_meas(2);
         Vc_meas(i)=y_meas(1);
     end
     
    for j=1:21
        pole1=-10*j;
        pole2=pole1;
        
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
        PHI_TR=PHI';
        Q=PHI_TR*PHI;
        R=(z_meas')*PHI;
        theta_star=R*inv(Q);

        first_parameter=mean([theta_star(1) theta_star(3) theta_star(5)]);         
        second_parameter=mean([theta_star(2) theta_star(4)]);

        x0=[0 0];
        eq_handle=@(t,state)dynamics2(t, state, u1, u2, 1/first_parameter, 1/second_parameter);
        %The simulation is done by solving the differential equations, with the proper parameters and initial state.
        [t, state]=ode45(eq_handle, time_vec, x0);    
        statistics_vector(j)=mean((Vc_meas-state(:,1)).^2);
        
    end
    
    plot(10:10:210,statistics_vector)
    title('The statistic for various pole positions')
    xlabel('abs(poles)')
    fprintf('We see that for j=10 => poles=-100 onward, the statistic does not seem to clearly show a decreasing trend\n')
    fprintf('We see that the choice of -100 is an appropriate one, as there are no choices that are considerably better than it\n')
    fprintf('Therefore this will be our last choice')
end
%Finished with the pole choice


%%% 4 %%% 
% The last test is to see whether the ode15s would be a better choice than ode45.
% I run the process of simulate2 two times, once with each ode function and compare my results
if(check_flag==4)
    fprintf('Testing the ode functions. The process takes less than a minute\n')
    time_vec=0:1e-5:2;
    
    u1=@(t)(2*sin(t));
    u2=@(t)(1);         %Creating a function handle, in case the user wants to change the input
    u1_meas=u1(time_vec)';
    u2_meas=ones(1,length(time_vec))';
    
    Vr_meas=zeros(length(time_vec),1);
    Vc_meas=zeros(length(time_vec),1);
    for i=1:length(time_vec)                %For loop used to get all the values of output voltage values.
        y_meas=v(time_vec(i));
        Vr_meas(i)=y_meas(2);
        Vc_meas(i)=y_meas(1);
    end
    
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
    
    PHI_TR=PHI';
    Q=PHI_TR*PHI;
    R=(z_meas')*PHI;
    theta_star=R*inv(Q);
    
    first_parameter=mean([theta_star(1) theta_star(3) theta_star(5)]);         
    second_parameter=mean([theta_star(2) theta_star(4)]);
    x0=[0 0];
    eq_handle=@(t,state)dynamics2(t, state, u1, u2, 1/first_parameter, 1/second_parameter);
    
    %For ode45:
    [t, state]=ode45(eq_handle, time_vec, x0);    
    ode45_stat=mean((Vc_meas-state(:,1)).^2)
    
    %For ode15s
     [t, state]=ode15s(eq_handle, time_vec, x0);    
    ode15s_stat=mean((Vc_meas-state(:,1)).^2)
    fprintf('The result of ode45 is better, therefore this is the ode solver I choose\n')
end


    
    

