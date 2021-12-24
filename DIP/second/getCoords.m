function coord = getCoords(index, M, N, type_flag)
%---------------------------------------------------------------------
%This function receives the M (number of rows) and N (number of columns) of
%an image, and also a specific index signifying the pixel of interest.
%It returns the coordinates of the pixel.
%Inputs:
%       1)index->       The index of the pixel, whose coordinates we need.
%       2)M->           The M number (specifying dimension)
%       3)N->           The N number (specifying dimension)
%       4)type_flag->   Flag to specify on whether to get the pixel in a
%       row major manner or not. More specifically:
%If type_flag==0, then the indexing is done in a column major way, and the
%image indexing will be like the following: (example for M=4)
%           |1   5   ...|
%           |2   6   ...|
%           |3   7   ...|
%           }4   8   ...|
%If type_flag!=0, then the indexing is done in a row major way, and the
%image indexing will be like the following: (example for N=4)
%           |1   2   3   4|
%           |5   6   7   8|
%           |... ... ... ...|
%In the whole project, the indexing is done in the row major way.
%Output:
%       1)coord->      The coordinates of the pixel
%--------------------------------------------------------------------

    %Column Major way:
    if type_flag==0         
        row=mod(index-1, M )+1;
        col=ceil(index/M);
        coord=[row;col];
    %Row Major way:
    else                    
        row=ceil(index/N);
        col=mod(index-1, N )+1;
        coord=[row;col];
    end

end