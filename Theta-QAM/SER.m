thetaDiv=15;% the amount of divisions of theta
Ps=zeros(thetaDiv+1,1);  %Array holding the diagramm elements

% Below we are sending 3 million symbols and get the 
%total number of symbol errors. For many theta values, and for 5 SNR values
for countTh=0:thetaDiv
    [Const,AvE]=constellation((countTh*pi)/45+ (pi)/6);
        counter=0;          %counter for the symbol errors
        for i=1:10000000
            counter=counter+received(floor(15*rand)+1,Const,AvE,20);
        end
        counter
        Ps(countTh+1,1)=counter;
end
disp(Ps);


%Function with parameter the theta angle. It returns the constellation points
%for the 16 theta-QAM and the average constellation energy
function [y,Eav]=constellation(theta)

R=[];       %Real part array
I=[];       %Imaginary part array
m=1;        %counter to get the array elements

%Computing the coordinates
for i=1:4
    for j=1:4
        R(m)=2*(j-1) -3 + (2*mod(i,2) -1)*cos(theta);
        I(m)=(-2*(i-1)+3)*sin(theta);
        m=m+1;
    end
end
y=complex(R,I); 
Eav=(48-8*cos(2*theta))/6;  %Computing the Eav, equation from the (2) paper.
end

%Function which finds if a random symbol sent, on a specific constellation and
% with a specific SNR, is received wrong.
function [y]=received(randomint,constarray,Eav,SNRdB)
    s=constarray(randomint);
    SNR=10^(SNRdB/10);
     %Getting the std for the specific SNR
    sigma=sqrt(Eav*0.5/SNR); 
    
    n=complex(normrnd(0,sigma),normrnd(0,sigma));  %The additive noise
    r=s+n;
    c=1;
    
    %By comparing the euclidian distances, we apply the ML criterion
    %and judge whether the receptor find the symbol wrong
    minimum=norm(r-constarray(1));
    for i=2:16
        d=norm(r-constarray(i));
        if d<minimum
            minimum=d;
            c=i;
        end
    end
    
    %If there is an error, the returned value is 1
    if c==randomint
       y=0;
    else
        y=1;
    end
end