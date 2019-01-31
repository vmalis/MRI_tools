


%% Number of slices availiable for processing
D = length(dir(['/Users/vadmalis/Desktop/DATA/Seniors/MD/MD_UTE/*.dcm']));


%% Masking

for k=1:D

    fname=sprintf('/Users/vadmalis/Desktop/DATA/Seniors/MD/MD_UTE/ute00000%.2d.dcm',k);    %% For UTE ute00000%.2d.dcm   For WS IM-0001-00%.2d.dcm

X=dicomread(fname);

info = dicominfo(fname);
Y = dicomread(info)


for i=1:256
    for j=1:256
        
        if i<241, 
       M(i,j)= X(i+15,j);
       
        else if j<248
                
       M(i,j)= X(i,j+8);
       
        else
       M(i,j)= 0;
      
         
      end
    end
end
end





    fname2=sprintf('/Users/vadmalis/Desktop/DATA/Seniors/MD/MD_UTEC/ute00000%.2d.dcm',k);    
         
dicomwrite(M, fname2, info, 'CreateMode', 'copy');


end


%%

clc
clear all

disp('The set is processed successfully')