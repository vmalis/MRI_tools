%%%This code performes the process of masking for dicom files. The output
%%%files are dicom files

cd ~/Desktop/DATA



%% Generating names of the folders to be processed
    for str = {'Seniors/KH/KH','Seniors/MD/MD','Seniors/AH/AH','Seniors/CW/CW','Seniors/YC/YC','Junior/AM/AM','Junior/HT/HT','Junior/MM/MM','Junior/MW/MW','Junior/YT/YT'}
    



%% Read mask


fid = fopen('%s_MASK/OB.img',str{1});
M = fread(fid,'uint8','ieee-be');
fclose(fid);

%%% number of slices availiable in a mask
d = int64(max(size(M)/256/256))

%%% bringing the mask to Matlab format
M = reshape(M,256,256,d);
M = permute(M, [2,1,3]);



%% Masking

for k=1:d

    fname=sprintf('%s_UTE_C/IM-0001-00%.2d.dcm',str{1},k)

X=dicomread(fname);

info = dicominfo(fname);
Y = dicomread(info)



for i=1:256
    for j=1:256
        
      if M(i,j,k+1)==0
          X(i,j)=0;
      else
          X(i,j)=X(i,j);
      end
    end
end

    fname2=sprintf('/Users/vadmalis/Desktop/DATA/%s_WS_MASKED/ute00000%.2d.dcm',str{1},k);    
         
dicomwrite(X, fname2, info, 'CreateMode', 'copy');


end



    end

%%

clc
clear all

disp('The set is processed successfully')