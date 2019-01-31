
 
%% Read in stack
folder = uigetdir('/Users/vadmalis/Desktop/DATA/Seniors/YC/YC_WS_MASKED_BC','DICOM directory');
mri = dicom_read_volume(folder);
 



matSize = size(mri)
 
 
%% SOL
fid = fopen('/Users/vadmalis/Desktop/DATA/Seniors/YC/YC_MASK/SOL.img');
mSOL = fread(fid,'uint8','ieee-be'); fclose(fid);
mSOL = reshape(mSOL,matSize);
 

%% SOL
SOL = mri;
 
for i=1:matSize(1)
for j=1:matSize(2)
for k=1:matSize(3)
    if mSOL(i,j,k) == 0;
        SOL(i,j,k) = 0;
    end
end
end
end


x=256*256*matSize(3);


SOLh =(reshape(SOL(:,:,:),x,1));
X = SOLh > 0;

hist(double(SOLh(X)),1000)
