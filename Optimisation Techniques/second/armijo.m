%Function that implements the armijo rule for the gk choice
%Arguments
%   f->         The function handle for f
%   gradf->     The function for the gradient
%   xk,dk->     What the name implies
%   a,b,s->     The armijo parameters(param1, param2, param3)
%   Returns the armijo gamma.
function gamma=armijo(f, gradf, xk, dk, a, b, s)
    
    xk=xk(:);       %Making sure I have column vectors:
    dk=dk(:);
    fxk=f(xk);      %Getting f(xk) and the gradient_f(xk)

    grad_fxk=gradf(xk);
    
    %Estimating the mk : (Armijo Rule)
    mk=0;
    n=1;
    while(true)
        gk=s*b^mk;  
        fxk1=f(xk+gk*dk);           %Getting the f(x_(k+1)) for this specific gk
        right_hand_side=-a*gk*(dk')*grad_fxk;        %Right hand side of the 5.2.39 equation  
        if(fxk-fxk1 >=right_hand_side)          %Condition for Armijo rule
            break
        end
        mk=mk+1;
    end
    gamma=gk;



end