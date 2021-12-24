function state_dot=dyn_eq2(t,state, structure, u, gamma1, gamma2, a, b, thetaM, n, n0, f)
%The function I use in order to get the state derivates. Useful for the ode command and the simulations
%Inputs;
%           1)t->                The time moment
%           2)state->         The current AUGMENTED STATE
%           3)structure->    Flag telling me what kind of structure to use. If ==1 then I use S-R structure, if ==0 I use the parallel.
%           4)u->                 The function handle of the input
%           5)gamma1->     The gamma1 coefficient (used to get the derivative of the a_hat)
%           6)gamma2->     The gamma2 coefficient (used to get the derivative of the b_hat)
%           7)a->                 The actual a parameter
%           8)b->                 The actual b parameter
%           9)thetaM->        The thetaM variable (used as the gain to the error on the SR structure)
%           10)n->                Function handle of the noise
%           11)n0->             The amplitude of the noise
%           12)f->                 The frequency of the noise
%Returns the derivative of the state (state_dot). The way it was designed is based on the theoretical analysis
%given on the report.


    %%Initialising useful variables
    a_hat=state(1);
    b_hat=state(2);
    x_hat=state(3);
    x_n=state(4) + n(t,n0,f);             %The x value THAT WE MEASURE (noise added)
    error=x_n-x_hat;
    %%Finished initialising useful variables
    
   
    %%Calculating the dot factors (derivatives)
    %For parallel structure
    if(structure==0)
        a_hat_dot=-gamma1*error*x_hat;
        b_hat_dot=gamma2*error*u(t);
        x_hat_dot=-a_hat*x_hat+b_hat*u(t);
        x_dot=-a*state(4)+b*u(t);                   
    end
    %Finished with the parallel structure.
    
    %For Series-Parallel structure.
    if(structure==1)
        a_hat_dot=-gamma1*error*x_n;
        b_hat_dot=gamma2*error*u(t);
        x_hat_dot=-a_hat*x_hat+b_hat*u(t)+ thetaM*(x_n-x_hat);
        x_dot=-a*state(4)+b*u(t);
    end
     %Finished for the Series-Parallel structure.
     
     state_dot=[a_hat_dot; b_hat_dot; x_hat_dot; x_dot];
     %%Finished calculating the dot factors
    
    
end
