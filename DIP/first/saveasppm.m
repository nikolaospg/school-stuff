 function saveasppm(x, filename , K)
 
    %Initialising the useful parameters
    dim=size(x);
    N=dim(1);                                   %Number of rows
    M=dim(2);                                   %Number of cols
    fileID=fopen(filename,'w');
    %Finished with the initialisations 
                
 
    fprintf(fileID,"P6 %d %d %d\n",M,N,K-1);                 %Writing the header
    
    
    %In each iteration of the following double for loops I write one color component of each pixel.
    %If the k<257, then we know that we can describe each component using only 1 byte.
    %This is why I use fwrite with the uint8 format (unsigned integer with 8 bits).
    if(K<257)
        for i=1:N
            for j=1:M
                fwrite(fileID,uint8(x(i,j,1)),'uint8');
                fwrite(fileID,uint8(x(i,j,2)),'uint8');
                fwrite(fileID,uint8(x(i,j,3)),'uint8');
            end
        end
    %However, when k>=257 then we know that for the PPM format we have to use 2 
    %bytes, and in a big endian fashion.
    else
        for i=1:N
            for j=1:M
                fwrite(fileID,uint16(x(i,j,1)),'uint16','b');
                fwrite(fileID,uint16(x(i,j,2)),'uint16','b');
                fwrite(fileID,uint16(x(i,j,3)),'uint16','b');
            end
         end
    end
    
    fclose(fileID);
 end
 