
    
fidr = sprintf('/Users/vadmalis/Desktop/DATA/Junior/YT/YT_UTE_SEG_SOL/O29.dat');
fid = fopen(fidr);
Y = fread(fid,'uint16','ieee-be');
Y = reshape(Y,256,256);

    imtool(Y);
     %% create laplacian filter. 
    H = fspecial('laplacian');
     %% apply laplacian filter. 
    blurred = imfilter(Y,H);
    imtool(blurred);