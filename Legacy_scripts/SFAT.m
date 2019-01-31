%% subcutaneous fat stats

cd ~/Desktop/DATA



%% Generating names of the folders to be processed
    for str = {'Seniors/KH/KH','Seniors/MD/MD','Seniors/AH/AH','Seniors/CW/CW','Seniors/YC/YC','Junior/AM/AM','Junior/HT/HT','Junior/MM/MM','Junior/MW/MW','Junior/YT/YT'}
    



%% Read mask

fname=sprintf('%s_MASK/OB.img',str{1});
fid = fopen(fname);
M = fread(fid,'uint8','ieee-be');
fclose(fid);

%%% number of slices availiable in a mask
d = int64(max(size(M)/256/256))

%%% bringing the mask to Matlab format
M = reshape(M,256,256,d);
M = permute(M, [2,1,3]);

G=zeros(256,256,d);

%% Masking

for k=1:d

    fname2=sprintf('%s_WS/IM-0001-00%.2d.dcm',str{1},k);
    X=dicomread(fname2);


for i=1:256
    for j=1:256
        
      if M(i,j,k)>0
         X(i,j)=0;
      elseif X(i,j)>100
         X(i,j)=1;
      elseif X(i,j)<100  
         X(i,j)=0;
      end
    end
end



G(:,:,k)=X;



  
end

  fid=sprintf('%s_RESULTS/SFAT.img',str{1});    
  fname3 = fopen(fid,'w+','l');
  fwrite(fname3,G,'uint8','ieee-be');
  fclose(fname3);

  clear G;

    end