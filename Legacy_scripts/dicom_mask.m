%%%This code performes the process of masking for dicom images. The output
%%%files are dicom files. (Set up for WaterSat but you can use for any dicoms)

cd ~/Desktop/DATA2



%% Generating names of the folders to be processed
    for str = {'Seniors/US/US','Junior/VM/VM','Junior/RC/RC'}
    



%% Read mask

fname2 = sprintf('%s_MASK/OB.img',str{1}); 



fid = fopen(fname2);
M = fread(fid,'uint8','ieee-be');
fclose(fid);

%%% number of slices availiable in a mask
d = int64(max(size(M)/256/256))

%%% bringing the mask to Matlab format
M = reshape(M,256,256,d);
M = permute(M, [2,1,3]);



%% Masking

for k=1:d

    fname=sprintf('%s_WS/IM-0001-00%.2d.dcm',str{1},k)

X=dicomread(fname);

info = dicominfo(fname);
Y = dicomread(info);



for i=1:256
    for j=1:256
        
      if M(i,j,k)==0
          X(i,j)=0;
      else
          X(i,j)=X(i,j);
      end
    end
end

    fname3=sprintf('%s_WS_MASKED/IM-0001-00%.2d.dcm',str{1},k);    
         
dicomwrite(X, fname3, info, 'CreateMode', 'copy');


end



    end

%%

clc
clear all

disp('The set is processed successfully')