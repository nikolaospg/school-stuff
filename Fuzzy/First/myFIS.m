%%This is the script I used to create the Mamdani fuzzy inference system, which is the central part of 
%%the fuzzy controller.

clc
clear
close all


%% First creating the initial FIS (with the specifications stated on the exercise)
my_FIS=newfis('fis_controller','FISType','mamdani', 'AndMethod','min', 'ImplicationMethod','prod', 'AggregationMethod', 'max');
%% Finished creating the Mamdani FIS


%% Now adding the error input variable with its MFs. For the MFs there is 
%% adequate description on the report
my_FIS=addvar(my_FIS,'input','error',[-1 1]);
my_FIS=addmf(my_FIS,'input',1,'NV','trimf',[-1.375, -1, -0.625]);
my_FIS=addmf(my_FIS,'input',1,'NL','trimf',[-1.125, -0.75, -0.375]);
my_FIS=addmf(my_FIS,'input',1,'NM','trimf',[-0.875, -0.5, -0.125]);
my_FIS=addmf(my_FIS,'input',1,'NS','trimf',[-0.625, -0.25, 0.125]);
my_FIS=addmf(my_FIS,'input',1,'ZR','trimf',[-0.375, 0, 0.375]);
my_FIS=addmf(my_FIS,'input',1,'PS','trimf',[-0.125, 0.25, 0.625]);
my_FIS=addmf(my_FIS,'input',1,'PM','trimf',[0.125, 0.5, 0.875]);
my_FIS=addmf(my_FIS,'input',1,'PL','trimf',[0.375, 0.75, 1.125]);
my_FIS=addmf(my_FIS,'input',1,'PV','trimf',[0.625, 1, 1.375]);
%% Finished with the error input variable


%% Now adding the error_diff input variable with its MFs
my_FIS=addvar(my_FIS,'input','error_diff',[-1 1]);
my_FIS=addmf(my_FIS,'input',2,'NV','trimf',[-1.375, -1, -0.625]);
my_FIS=addmf(my_FIS,'input',2,'NL','trimf',[-1.125, -0.75, -0.375]);
my_FIS=addmf(my_FIS,'input',2,'NM','trimf',[-0.875, -0.5, -0.125]);
my_FIS=addmf(my_FIS,'input',2,'NS','trimf',[-0.625, -0.25, 0.125]);
my_FIS=addmf(my_FIS,'input',2,'ZR','trimf',[-0.375, 0, 0.375]);
my_FIS=addmf(my_FIS,'input',2,'PS','trimf',[-0.125, 0.25, 0.625]);
my_FIS=addmf(my_FIS,'input',2,'PM','trimf',[0.125, 0.5, 0.875]);
my_FIS=addmf(my_FIS,'input',2,'PL','trimf',[0.375, 0.75, 1.125]);
my_FIS=addmf(my_FIS,'input',2,'PV','trimf',[0.625, 1, 1.375]);
%Finished with the error_diff input variable

%% Now adding the control_diff output variable with its MFs
my_FIS=addvar(my_FIS,'output','control_diff',[-1 1]);
my_FIS=addmf(my_FIS,'output',1,'NV','trimf',[-1.375, -1, -0.625]);
my_FIS=addmf(my_FIS,'output',1,'NL','trimf',[-1.125, -0.75, -0.375]);
my_FIS=addmf(my_FIS,'output',1,'NM','trimf',[-0.875, -0.5, -0.125]);
my_FIS=addmf(my_FIS,'output',1,'NS','trimf',[-0.625, -0.25, 0.125]);
my_FIS=addmf(my_FIS,'output',1,'ZR','trimf',[-0.375, 0, 0.375]);
my_FIS=addmf(my_FIS,'output',1,'PS','trimf',[-0.125, 0.25, 0.625]);
my_FIS=addmf(my_FIS,'output',1,'PM','trimf',[0.125, 0.5, 0.875]);
my_FIS=addmf(my_FIS,'output',1,'PL','trimf',[0.375, 0.75, 1.125]);
my_FIS=addmf(my_FIS,'output',1,'PV','trimf',[0.625, 1, 1.375]);
%% Finished with the control_diff output variable

%% Passing in the Rule base 
rules=[1, 9, 5, 1, 1;
       1, 8, 4, 1, 1;
       1, 7, 3, 1, 1;
       1, 6, 2, 1, 1;
       1, 5, 1, 1, 1;
       1, 4, 1, 1, 1;
       1, 3, 1, 1, 1;
       1, 2, 1, 1, 1;
       1, 1, 1, 1, 1;
       
       2, 9, 6, 1, 1;
       2, 8, 5, 1, 1;
       2, 7, 4, 1, 1;
       2, 6, 3, 1, 1;
       2, 5, 2, 1, 1;
       2, 4, 1, 1, 1;
       2, 3, 1, 1, 1;
       2, 2, 1, 1, 1;
       2, 1, 1, 1, 1;
       
       3, 9, 7, 1, 1;
       3, 8, 6, 1, 1;
       3, 7, 5, 1, 1;
       3, 6, 4, 1, 1;
       3, 5, 3, 1, 1;
       3, 4, 2, 1, 1;
       3, 3, 1, 1, 1;
       3, 2, 1, 1, 1;
       3, 1, 1, 1, 1;
       
       4, 9, 8, 1, 1;
       4, 8, 7, 1, 1;
       4, 7, 6, 1, 1;
       4, 6, 5, 1, 1;
       4, 5, 4, 1, 1;
       4, 4, 3, 1, 1;
       4, 3, 2, 1, 1;
       4, 2, 1, 1, 1;
       4, 1, 1, 1, 1;
       
       5, 9, 9, 1, 1;
       5, 8, 8, 1, 1;
       5, 7, 7, 1, 1;
       5, 6, 6, 1, 1;
       5, 5, 5, 1, 1;
       5, 4, 4, 1, 1;
       5, 3, 3, 1, 1;
       5, 2, 2, 1, 1;
       5, 1, 1, 1, 1;
       
       6, 9, 9, 1, 1;
       6, 8, 9, 1, 1;
       6, 7, 8, 1, 1;
       6, 6, 7, 1, 1;
       6, 5, 6, 1, 1;
       6, 4, 5, 1, 1;
       6, 3, 4, 1, 1;
       6, 2, 3, 1, 1;
       6, 1, 2, 1, 1;
       
       7, 9, 9, 1, 1;
       7, 8, 9, 1, 1;
       7, 7, 9, 1, 1;
       7, 6, 8, 1, 1;
       7, 5, 7, 1, 1;
       7, 4, 6, 1, 1;
       7, 3, 5, 1, 1;
       7, 2, 4, 1, 1;
       7, 1, 3, 1, 1;
       
       8, 9, 9, 1, 1;
       8, 8, 9, 1, 1;
       8, 7, 9, 1, 1;
       8, 6, 9, 1, 1;
       8, 5, 8, 1, 1;
       8, 4, 7, 1, 1;
       8, 3, 6, 1, 1;
       8, 2, 5, 1, 1;
       8, 1, 4, 1, 1;
       
       9, 9, 9, 1, 1;
       9, 8, 9, 1, 1;
       9, 7, 9, 1, 1;
       9, 6, 9, 1, 1;
       9, 5, 9, 1, 1;
       9, 4, 8, 1, 1;
       9, 3, 7, 1, 1;
       9, 2, 6, 1, 1;
       9, 1, 5, 1, 1];
my_FIS=addrule(my_FIS, rules);
%% Finished with the rule base
   
%% Displaying the characteristics of the FIS
my_FIS
figure('Name','The MFs for the error')
plotmf(my_FIS, 'input', 1);     %The MFs for the error variable
figure('Name','The MFs for the error differences')
plotmf(my_FIS, 'input', 2);     %The MFs for the error_diff variable
figure('Name','The MFs for the control output differences')
plotmf(my_FIS, 'output', 1);    %The MFs for the control_diff variable