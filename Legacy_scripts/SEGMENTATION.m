global I fidw Iterations

% I             -   image of one slice
% fidw          -   path for the output to be written in file
% Iterations    -   number of non-zero elements for the slice of the used mask


%% Read in stack
fidr = uigetdir('/Users/vadmalis/Desktop/DATA/Junior/MW/MW_WS_MASKED_BC','DICOM directory');
mri = dicom_read_volume(fidr);
matSize = size(mri)
 
 
%% Read mask
fid = fopen('/Users/vadmalis/Desktop/DATA/Junior/MW/MW_MASK/SOL.img');
MASK = fread(fid,'uint8','ieee-be'); fclose(fid);
MASK = reshape(MASK,matSize);
MASK = permute(MASK,[2,1,3]);

%% Masking the image stack
IMAGE = mri;
 
for i=1:matSize(1)
    for j=1:matSize(2)
        for k=1:matSize(3)
             if MASK(i,j,k) == 0;
                IMAGE(i,j,k) = 0;
             end
        end
    end
end 
       
       

%% Variational Image Thresholding

for j=29

fidw=sprintf('/Users/vadmalis/Desktop/DATA/Junior/MW/MW_WS_SEGM/M%.2d.dat',j);        

if nnz(MASK(:,:,j))>0

    Iterations=10000
    else
    Iterations=0
end

I=double(IMAGE(:,:,j));
MinimaxAT(I);
end