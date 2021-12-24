%The function I use to get the handle for the ode command, in order to simulate the system
% Arguments:
%           RC-> the R*C product
%           LC-> the L*C product
%           u2->  the u2 input
%           x->     the current state
%           t->     the current moment


function dx= dynamics2(t, x, u1, u2, RC, LC)
    t
    a1=1/RC;
    a2=1/LC;
    b1=a2;
    c0=a1;
    
    dx1=x(2)+c0*u1(t);
    dx2=-a2*x(1) - a1*x(2) + b1*u2(t) +(-a1*c0)*u1(t);
    dx=[dx1 dx2]';

end