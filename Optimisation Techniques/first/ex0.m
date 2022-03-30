clc
clear
close all

%Using function handles to initialise the objective functions
f1=@(x)( (x-3).^2 +(sin(x+3)).^2 );
f2=@(x)( (x-1).*cos(x/2) + x.^2);
f3=@(x)( (x+2).^2 + exp(x-2) .* (sin(x+3)));
%Finished initialising the functions to be minimised

%The search interval:
a=-4;
b=4;

%Making the plots of the functions on the search interval, so that I can
%have a vague idea on their form. Comments about the quasi-convexity are also made (report).
make_plots(f1,f2,f3,a,b);
%Finished making the plots



%I use the following function so that I can make the plots of the functions to be minimised
%I do this to have a visual understanding of what is going on.
%One can easily understand what the input arguments do.
function make_plots(f1, f2, f3, a, b)
    x_values=(a:0.01:b)';  %The x values where I evaluate the functions on

    f1_values=f1(x_values);
    f2_values=f2(x_values);
    f3_values=f3(x_values);

    figure("Name", "f1 plot")
    plot(x_values, f1_values)
    xlabel("x")
    ylabel("f1(x)")

    figure("Name", "f2 plot")
    plot(x_values, f2_values)
    xlabel("x")
    ylabel("f2(x)")
    
    figure("Name", "f3 plot")
    plot(x_values, f3_values)
    xlabel("x")
    ylabel("f3(x)")


end
