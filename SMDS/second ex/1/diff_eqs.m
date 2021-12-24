function state_dot=diff_eqs(t, state, u, gamma, lambda, a, b)
%The function I use in order to get the state derivates. Useful for the ode command and the simulations
%Inputs:
%           1)t->                The time moment
%           2)state->         The current AUGMENTED STATE
%           3)u->                The function handle of the input
%           4)gamma->     The gamma coefficient (used to get the derivative of the theta hat)
%           5)lambda->      The filter coefficient (used to get the linear parametric form).
%           6)a->                 The actual a parameter
%           7)b->                 The actual b parameter
%Returns the derivative of the state (state_dot). The way it was designed is based on the theoretical analysis
%given on the report.


    %Initialising useful Variables
    theta_hat=state(1:2,:);
    zeta1=state(3);
    zeta2=state(4);
    zeta=[zeta1 zeta2]';
    y=state(5);
    y_hat=state(6);
    current_input=u(t);
    error=y-(theta_hat')*zeta;
    %Finished initialising Variables
    
    %Calculating the differential equations
    theta_hat_dot=gamma*error*zeta;
    zeta1_dot=-lambda*zeta1-y;
    zeta2_dot=-lambda*zeta2+current_input;
    y_dot=-a*y+b*current_input;
    y_hat_dot=-(theta_hat(1)+lambda)*y_hat+theta_hat(2)*current_input;
    state_dot=[theta_hat_dot' zeta1_dot zeta2_dot y_dot y_hat_dot]';
    %finished with the differential equations
    

end