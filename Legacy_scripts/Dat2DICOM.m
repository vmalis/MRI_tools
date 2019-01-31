%% This script performes the conversion from DTI studio Eddy-Corrected DWI to DICOM DWI

%% .dat DTI Studio file location

fid = fopen('/Users/vadmalis/Desktop/DATA/Junior/AM/AM_DTI/Eddy-corrected.dat');
X = fread(fid,'uint16');
X = reshape(X,256,256,1419);




%% Waitbar
h = waitbar(0,'message','CreateCancelBtn') 



%% Sorting voxels

for k=1:1419              %Slice number
    
    fid2 = sprintf('/Users/vadmalis/Desktop/DATA/Junior/AM/AM_DTI/IM-0001-%.4d.dcm',k);
    Z=dicomread(fid2);
    
    
    
    for i = 1:256
        for j = 1:256
          
            
            
     Z(i,j) = X (i,j,k);
    
        end
    end
    
%Reading original DTI header

info = dicominfo(fid2);

Z = permute(Z,[2,1]);

waitbar(k/1419)

%Writing DICOM
fid3 = sprintf('/Users/vadmalis/Desktop/DATA/Junior/AM/AM_DTI_EC/IM-0001-%.4d.dcm',k);    
dicomwrite(Z, fid3, info, 'CreateMode', 'copy');

clear Z;

end

delete h
clear all
clc

disp('DWI set is processed successfully')
