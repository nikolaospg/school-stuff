%This is a function I specifically wrote to implement the 
%bilinear interpolation for ONE point

%Inputs:         xrgb-> The rgb image
%                   x_value-> The x coordinate of the point
%                   y_value->  The y coordinate of the point

%It returns the interpolated value.

function interpol_val=bilinearinterp(xrgb, x_value, y_value)

    %Getting the coefficients of the pixels on the initial image that are around the point of interest.
    x1=floor(x_value);
    x2=ceil(x_value);
    y1=floor(y_value);
    y2=ceil(y_value);
    %Finished getting the coefficients

    %Getting the initial image values (all three color components)
    f11=xrgb(x1,y1,:);
    f12=xrgb(x1,y2,:);
    f21=xrgb(x2,y1,:);
    f22=xrgb(x2,y2,:);
    %Finished getting the initial image values.
    
    %Applying the algorithm and calculating the b vector.
    %It holds the coefficients I use to get the interpolated value
    A=[1 x1 y1 x1*y1; 1 x1 y2 x1*y2; 1 x2 y1 x2*y1; 1 x2 y2 x2*y2];
    z=[1;x_value; y_value; x_value*y_value];
    A=inv(A)';
    b=A*z;
    %Finished calculating the b vector.
    
    %Now getting the interpolated values
    f_red=[f11(1) f12(1) f21(1) f22(1)];
    interpol_val(1,1,1)=f_red*b;
    
    f_green=[f11(2) f12(2) f21(2) f22(2)];
    interpol_val(1,1,2)=f_green*b;
    
    f_blue=[f11(3) f12(3) f21(3) f22(3)];
    interpol_val(1,1,3)=f_blue*b;
    %Finished with the bilinear_interpolation
end