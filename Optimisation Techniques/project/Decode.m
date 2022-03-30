%The function takes as input one bit string which supposedly encodes one variable
%and decodes it

function out_value=Decode(bit_string, x_min, x_max, R)

    N=2^R;                               %Number of levels
    W=x_max-x_min;                       %Width
    delta=W/(N-1) ;                      %Step
    
    %Converting bit string to symbol
    bit_string=bit_string(:);
    bit_string=bit_string';
    pows=length(bit_string)-1:-1:0;
    pows=2.^pows;
    symbol=sum(pows.*bit_string);
    
    %getting the decoded value:
    out_value=x_min+symbol*delta;
    


end