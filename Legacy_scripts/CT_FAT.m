%%% This script will determine which voxels have both fat and connective


cd ~/Desktop/DATA


%% Generating names of the folders to be processed
    for str = {'Seniors/KH/KH','Seniors/MD/MD','Seniors/YC/YC','Seniors/AH/AH','Seniors/CW/CW','Junior/HT/HT','Junior/MW/MW','Junior/YT/YT','Junior/AM/AM','Junior/MM/MM'; '1','-2','1','0','0','3','0','0','0','5'}
    %%% Muscle names
    for str2 ={'SOL','GM','GL'}
 
        
%%% Number of WS slices
fname0 = sprintf('%s_WS_MASKED_BC/*.dcm',str{1}); 
NumberOfSlices = length(dir(fname0));

        
%%% Number of UTE slices    
fname1 = sprintf('%s_UTE/Original/*.dcm',str{1}); 
NumberOfSlicesUTE = length(dir(fname1))/2;       
               




%%% Read Original Volume
fidr2 = sprintf('%s_UTE_SEG_%s/UTE-%s.img',str{1},str2{1},str2{1});
fid2 = fopen(fidr2);
Original = fread(fid2,'uint16','ieee-be');
fclose(fid2);
Original = reshape(Original,256,256,NumberOfSlicesUTE);
Original = permute(Original,[2,1,3]);



        
%%% Read Fat Segmented Volume

fidr1 = sprintf('%s_WS_SEG_%s/WS_S-%s.img',str{1},str2{1},str2{1});
fid1 = fopen(fidr1);
FAT = fread(fid1,'uint8','ieee-be');
fclose(fid1);
FAT = reshape(FAT,256,256,NumberOfSlices);
FAT = permute(FAT,[2,1,3]);



%%% Read CT Segmented Volume

fidr2 = sprintf('%s_UTE_SEG_%s/UTE_S-%s.img',str{1},str2{1},str2{1});
fid2 = fopen(fidr2);
CT = fread(fid2,'uint16','ieee-be');
fclose(fid2);
CT = reshape(CT,256,256,NumberOfSlicesUTE);
CT = permute(CT,[2,1,3]);





%%% Create new Volume which will include fat and ct
FAT_New = zeros (256,256,NumberOfSlicesUTE);
X = zeros (256,256,NumberOfSlicesUTE);
y = str2num(str{2});


if y<0
a = abs(y)+1;
else a=1;
end


for k=a:NumberOfSlicesUTE
    
    for i = 1:256
        for j = 1:256
            FAT_New (i,j,k)= FAT (i,j,k+y);

        end
    end
end   




%% Comparing volumes

for k=1:NumberOfSlicesUTE
    
    
    for i=1:256
        for j=1:256
    
    if FAT_New(i,j,k)>0
            if CT (i,j,k) == FAT_New(i,j,k)
            CT (i,j,k) = 0;
            FAT_New(i,j,k)=0;
            X (i,j,k) = 3;
            end
    end
        end
    end
end











    
CT=CT*2;



%% Aligning FatSat volume










%% Writing volumes

%%% CT

        CT = permute(CT,[2,1,3]);
        fidw=sprintf('%s_RESULTS/CT-%s.img',str{1},str2{1});  
        fname = fopen(fidw,'w+','l');
        fwrite(fname,CT,'uint16','ieee-be');
        fclose(fname);


%%% X
        X = permute(X,[2,1,3]);
        fidw=sprintf('%s_RESULTS/X-%s.img',str{1},str2{1});  
        fname = fopen(fidw,'w+','l');
        fwrite(fname,X,'uint16','ieee-be');
        fclose(fname);
%%% FAT
        FAT_New = permute(FAT_New,[2,1,3]);
        fidw=sprintf('%s_RESULTS/FAT-%s.img',str{1},str2{1});  
        fname = fopen(fidw,'w+','l');
        fwrite(fname,FAT_New,'uint16','ieee-be');
        fclose(fname);

%%% Original volume   

        Original = permute(Original,[2,1,3]);
        fidw=sprintf('%s_RESULTS/Original-%s.img',str{1},str2{1});  
        fname = fopen(fidw,'w+','l');
        fwrite(fname,Original,'uint16','ieee-be');
        fclose(fname);


    
    
   
    
    
    end
    end
    