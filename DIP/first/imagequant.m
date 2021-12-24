%Function used to quantise my image

function q = imagequant(x, w1, w2, w3)
 
    x=changeones(x,w1,w2,w3);           %Changing the pixels when the value=1
    %Getting the R,G,B components of the input image
    x_red=x(:,:,1);
    x_green=x(:,:,2);
    x_blue=x(:,:,3);
    %Finished getting the RGB components
    
    
    %Quantising each component and creating the q output
    q_red= myquant (x_red, w1);
    q_green=myquant (x_green, w2);
    q_blue=myquant (x_blue, w3);
    q=cat(3,q_red,q_green,q_blue);
    %Finished with imagequant.
 
 end