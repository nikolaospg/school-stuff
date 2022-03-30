%xin is the input value to be quantised
%x_min is the minimum x value I have allowed
%x_max is the maximum x value I have allowed
%R is the number of bits each word has (standard=10)
%The function takes a floating point input and encodes it to a bit string, by
%the process I specified on the report
function bit_string=encode(x_in, x_min, x_max, R)
    
    N=2^R;                               %Number of levels
    W=x_max-x_min;                       %Width
    delta=W/(N-1);                       %Step
    
    %First quantising (getting the symbol 1:1:N-1)
    if(x_in<=x_min)
        symbol=0;
    elseif(x_in>=x_max)
        symbol=N-1;
    else
        symbol=round( (x_in-x_min)/delta);
    end
   
    %Now encoding (from the symbol we get a bit string)
    bit_string=zeros(R,1);
    
    string=dec2base(symbol,2);
    
    for i=1:length(string)
        current_string_bit=string(end-i+1);
        if(current_string_bit=='1')
            bit_string(end-i+1)=1;
        end
    end
    





end