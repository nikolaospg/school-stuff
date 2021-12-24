%%This is a short script that does the stuff specified on the b,c parts of
%%scenario a. 

clc
clear
close all
my_FIS=readfis('my_FIS.fis');   %Getting the FIS I created previously


%% Doing the surface that is needed for scenario 1c
surfview(my_FIS)
%% Finished with scenario 1c


%% Using the ruleview command for the scenario 1b
ruleview(my_FIS)