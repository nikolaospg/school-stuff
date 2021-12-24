z=hammingdistance;      %Array containing the hamming distance between any 2 symbols. Check the hammingdistance function
thetaDiv=15;        % the amount of divisions of theta
Ps5=zeros(thetaDiv+1,4);        
Ps13=zeros(thetaDiv+1,1);       

for countTh=0:thetaDiv
    [Const,AvE]=constellation((countTh*pi)/45+ (pi)/6);
    for snrDB=5:5:20 %Computing for SNR 5,10,15,20
        counter=0;          %counter for the symbol errors
        for i=1:3000000
            counter=counter+received(floor(15*rand)+1,Const,AvE,snrDB,z);
        end
      %  counter       %Uncomment, if you want to look at the progress of the process- NOT RECOMMENDED
        Ps5(countTh+1,snrDB/5)=counter;
    end
end
disp(Ps5);

for countTh=0:thetaDiv
    [Const,AvE]=constellation((countTh*pi)/45+ (pi)/6);
    for snrDB=16:19         %Computing for SNR 16,17,18,19
        counter=0; 
        for i=1:3000000
            counter=counter+received(floor(15*rand)+1,Const,AvE,snrDB,z);
        end
        %counter
        Ps5(countTh+1,snrDB-15)=counter;
    end
end
disp(Ps5);
for countTh=0:thetaDiv          %for SNR=13
    [Const,AvE]=constellation((countTh*pi)/45+ (pi)/6);
    counter=0; 
    for i=1:3000000
        counter=counter+received(floor(15*rand)+1,Const,AvE,13,z);
    end
        %counter
        Ps13(countTh+1,1)=counter;
end
disp(Ps13);


function [y]=hammingdistance() %Function returning the hamming distance between two symbols
    z=[1 1 0 1;1 0 0 1;0 0 0 1;0 1 0 1;1 1 0 0;1 0 0 0;0 0 0 0;0 1 0 0;1 1 1 0;1 0 1 0;0 0 1 0;0 1 1 0;1 1 1 1;1 0 1 1;0 0 1 1;0 1 1 1];
    for i=1:16
        for j=1:16
            counter=0;
            for k=1:4
                counter=counter + abs(z(i,k)-z(j,k));
            end
            y(i,j)=counter;
        end
    end
end


function [y,Eav]=constellation(theta)       %Function creating the 16 theta-QAM, for a specific theta value

R=[];
I=[];
m=1;
for i=1:4
    for j=1:4
        R(m)=2*(j-1) -3 + (2*mod(i,2) -1)*cos(theta);
        I(m)=(-2*(i-1)+3)*sin(theta);
        m=m+1;
    end
end
y=complex(R,I);
Eav=(48-8*cos(2*theta))/6;
end

%Function that returns the number of different bits
%between the sent and the detected signal, for a specific constellation.

function [y]=received(randomint,constarray,Eav,SNRdB,errorArray)
    s=constarray(randomint);
    SNR=10^(SNRdB/10);
    sigma=sqrt(Eav*0.5/SNR);
    
    n=complex(normrnd(0,sigma),normrnd(0,sigma));       %The noise 
    r=s+n;
    c=1;        %minimum distance counter 
    minimum=norm(r-constarray(1));
    for i=2:16
        d=norm(r-constarray(i));
        if d<minimum
            minimum=d;
            c=i;
        end
    end 
    if c==randomint
       y=0;
    else
        y=errorArray(c,randomint);          %Returns the bit difference between the sent and the detected
    end
end