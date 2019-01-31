%%Merging output of Segmentation into a single Stack

D = length(dir(['/Users/vadmalis/Desktop/DATA/Junior/MW/MW_WS_SEGM/*.dat']));



%% Creating the zero array for mergeing output from Segmentation
WS_S = zeros(256,256,D);
WS = zeros(256,256,D);

%%
for i=1:D/2
   
    
    %%% FAT Segmented
    fidr = sprintf('/Users/vadmalis/Desktop/DATA/Junior/MW/MW_WS_SEGM/M%.2d.dat',i);
    fid = fopen(fidr);
    X = fread(fid,'uint8','ieee-be');
    X = reshape(X,256,256);
    WS_S(:,:,i)=X(:,:);                                                                                                                                                                                                                                                                                                                                    ; 

    
    %%% Original Stack
    fidr2 = sprintf('/Users/vadmalis/Desktop/DATA/Junior/MW/MW_WS_SEGM/Orig%.2d.dat',i);
    fid2 = fopen(fidr2);
    Y = fread(fid2,'uint16','ieee-be');
    Y = reshape(Y,256,256);
    WS(:,:,i)=Y(:,:);     
    
    
end

fidr3=sprintf('/Users/vadmalis/Desktop/DATA/Junior/MW/MW_WS_SEGM/WS_S-SOL.img');  
fname3 = fopen(fidr3,'w+','l');
fwrite(fname3,WS_S,'uint8','ieee-be');


fidr4=sprintf('/Users/vadmalis/Desktop/DATA/Junior/MW/MW_WS_SEGM/WS-SOL.img');  
fname4 = fopen(fidr4,'w+','l');
fwrite(fname4,WS,'uint16','ieee-be');