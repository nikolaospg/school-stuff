%This is a function I wrote to help me with the imagequant function.
%To be specific, there was a problem with quantising the image when a pixel
%had a value equal to 1, because with the way I implemented the myquant function
%this value (1) demanded one more symbol. Therefore, when the value =1 I just 
%map it to the last symbol (more about these on the report).

%This function takes an RGB image x, and finds every value that is equal to 1.
%It changes the value to 1-w/2, so that when the pixel has a value=1, then it gets 
%the proper symbol without demanding one more symbol. 

%Special care was taken, because in every color component the w value is different

function x = changeones(x, w1, w2, w3)
 
    
    dims=size(x);
    N=dims(1);
    M=dims(2);
    x(find(x(:,:,1)==1))=1-w1/2;
    x(find(x(:,:,2)==1) +N*M)=1-w2/2;           %Adding N*M, so that the indexing is correct
    x(find(x(:,:,3)==1) +2*N*M)=1-w3/2;
    
 
 end