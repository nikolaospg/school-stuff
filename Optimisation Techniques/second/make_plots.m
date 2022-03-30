function make_plots(f, grid_values, results_flag, x_values, f_values)
    
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
    zlim( [0 1]);
    colormap gray
    if(results_flag==1)
        hold on
        scatter3(x_values(1,:), x_values(2,:), f_values(:), 70, 'r', '+')
        plot3(x_values(1,:), x_values(2,:), f_values(:), 'y')
    end
    
    
    %Contour plot
    figure("Name", "Contour Plot of the Function")
    contour(X,Y,Z)
    xlim( [grid_values(1) grid_values(end)])
    ylim( [grid_values(1) grid_values(end)])
    if(results_flag==1)
        hold on
        scatter(x_values(1,:), x_values(2,:), 70, 'r', '+')
        plot(x_values(1,:), x_values(2,:), 'k')
    end



end