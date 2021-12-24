%Function used to dequantise an image

function x = imagedequant(q, w1, w2, w3)
 
    %Getting the 3 components of the q input
    q_red=q(:,:,1);
    q_green=q(:,:,2);
    q_blue=q(:,:,3);
     %Finished getting the 3 components of the q input

    %Dequantising and creating my final image.
    x_red= mydequant (q_red, w1);
    x_green=mydequant (q_green, w2);
    x_blue=mydequant (q_blue, w3);
    x=cat(3,x_red,x_green,x_blue);
    %Finished with imagedequant
    
 end