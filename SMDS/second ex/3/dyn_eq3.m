function state_dot=dyn_eq3(t,state,u, gamma1, gamma2, A, B)
%The function I use in order to get the state derivates. Useful for the ode command and the simulations
%Inputs:
%           1)t->                The time moment
%           2)state->         The current AUGMENTED STATE
%           3)u->                The function handle of the input
%           4)gamma1->     The gamma1 coefficient (used to get the derivative of the A hat)
%           5)gamma2->     The gamma2 coefficient (used to get the derivative of the B hat)
%           6)A->                 The actual A parameter
%           7)B->                 The actual B parameter
%Returns the derivative of the state (state_dot). The way it was designed (and the values of the augmented state)
%is based on the theoretical analysis given on the report.

    %%Initialising Useful Variables
    A_hat=[state(1) state(2); state(3) state(4)];
    B_hat=[state(5); state(6)];
    x_hat=[state(7); state(8)];
    x=[state(9); state(10)];
    current_input=u(t);
    error=x-x_hat;
    %%Finished Initialising Useful Variables
    
    %%Solving the differential equations
    A_hat_dot=gamma1*error*(x_hat)';
    B_hat_dot=gamma2*current_input*error;
    x_hat_dot=A_hat*x_hat+ B_hat*current_input;
    x_dot=A*x+B*current_input;
    
    state_dot=[A_hat_dot(1,1);
                        A_hat_dot(1,2);
                        A_hat_dot(2,1);
                        A_hat_dot(2,2);
                        B_hat_dot(1);
                        B_hat_dot(2);
                        x_hat_dot(1);
                        x_hat_dot(2);
                        x_dot(1);
                        x_dot(2)];
    %%Finished solving the differential equations
end
    