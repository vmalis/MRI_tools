%% Number of slices availiable for processing
D = length(dir(['/Users/vadmalis/Desktop/DATA/Seniors/KH/UTE_CC2/*.dcm']));


%% Masking

for k=1:D

    fname=sprintf('/Users/vadmalis/Desktop/DATA/Seniors/KH/UTE_CC2/IMG00%.2d.dcm',k);    %% For UTE ute00000%.2d.dcm   For WS IM-0001-00%.2d.dcm

X=dicomread(fname);

info = dicominfo(fname);
Y = dicomread(info)


for i=1:256
    for j=1:256
   
          Z(257-i,j)=X(i,j);
      
    end
end

    fname2=sprintf('/Users/vadmalis/Desktop/DATA/Seniors/KH/UTE_C/ute00000%.2d.dcm',2*k);    
         
dicomwrite(Z, fname2, info, 'CreateMode', 'copy');


end


%%

clc
clear all

disp('The set is processed successfully')