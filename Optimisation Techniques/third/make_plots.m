%Function I use to make plots.
%The grid_values parameters is a vector which specifies which values the orthogonal grid is made of
%The results_flag is a flag which tells us on whether to plot the f alone, or with the results we get from the algorithms
%if ==1 -> print with results, else no results
%x_values and f_values are the results
%x1_limits, x2_limits are the limits describing th area we search the minimum at
function make_plots(f, grid_values, results_flag, x_values, f_values, x1_limits, x2_limits)
    
    [X,Y]=meshgrid(grid_values, grid_values);
    for i=1:length(grid_values)
        for j=1:length(grid_values)
            Z(i,j)=f([X(i,j); Y(i,j)]);
        end
    end

    %%The plot of the function (surface)
    figure("Name", "3D Plot of the Function")
    surf(X,Y,Z)
    xlim( [grid_values(1) grid_values(end)]);
    ylim( [grid_values(1) grid_values(end)]);
    colormap gray
    if(results_flag==1)
        hold on
        scatter3(x_values(1,:), x_values(2,:), f_values(:), 70, 'r', '+')
        plot3(x_values(1,:), x_values(2,:), f_values(:), 'y')
    end
    
    %For the 3D plot I also print the points (borders) that define the search area
    %For the left line:
    f1=f( [x1_limits(1); x2_limits(1)]);
    f2=f( [x1_limits(1); x2_limits(2)]);
    plot3( [x1_limits(1), x1_limits(1)], [ x2_limits(1), x2_limits(2)], [f1, f2], 'r');     
    %For the right line
    f1=f( [x1_limits(2); x2_limits(1)]);
    f2=f( [x1_limits(2); x2_limits(2)]);
    plot3( [x1_limits(2), x1_limits(2)], [ x2_limits(1), x2_limits(2)], [f1, f2], 'r');     
    %For the down line
    f1=f( [x1_limits(1); x2_limits(1)]);
    f2=f( [x1_limits(2); x2_limits(1)]);
    plot3( [x1_limits(1), x1_limits(2)], [ x2_limits(1), x2_limits(1)], [f1, f2], 'r');    
    %For the upper line
    f1=f( [x1_limits(1); x2_limits(2)]);
    f2=f( [x1_limits(2); x2_limits(2)]);
    plot3( [x1_limits(1), x1_limits(2)], [ x2_limits(2), x2_limits(2)], [f1, f2], 'r');   
    
    %Contour plot
    figure("Name", "Contour Plot of the Function")
    contour(X,Y,Z)
    xlim([grid_values(1) grid_values(end)]);
    ylim([grid_values(1) grid_values(end)]);
    if(results_flag==1)
        hold on
        scatter(x_values(1,:), x_values(2,:), 70, 'r', '+')
        plot(x_values(1,:), x_values(2,:), 'k')
    end
    plot( [x1_limits(1), x1_limits(1)], [ x2_limits(1), x2_limits(2)], 'r');     %The left line of the area
    plot( [x1_limits(2), x1_limits(2)], [ x2_limits(1), x2_limits(2)], 'r');     %The right line of the area
    plot( [x1_limits(1), x1_limits(2)], [ x2_limits(1), x2_limits(1)], 'r');     %The down line of the area
    plot( [x1_limits(1), x1_limits(2)], [ x2_limits(2), x2_limits(2)], 'r');     %The up line of the area

end
