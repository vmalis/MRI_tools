%%% UTE Mask

cd ~/Desktop/DATA


%% Generating names of the folders to be processed
    
    %%% Two-dimm array: 1st path to the folder with data, 2nd is number of
    %%% mask's slice which corresponds to the first UTE's slice
    
   for str = {'Seniors/KH/KH','Seniors/MD/MD','Seniors/YC/YC','Seniors/AH/AH','Seniors/CW/CW','Junior/HT/HT','Junior/MW/MW','Junior/YT/YT','Junior/AM/AM','Junior/MM/MM'; '1','-2','1','0','0','3','0','0','0','5'}
    
    %%% Muscle names
    for str2 ={'SOL','GM','GL'}

        
        
        
        
%% Number of slices (Basicaly gives the number of dicom files in the WaterSat images folder)
        fname0 = sprintf('%s_WS_MASKED_BC/*.dcm',str{1}); 
        NumberOfSlices = length(dir(fname0));
    

%% Number of slices (Basicaly gives the number of dicom files in the UTE images folder)
        fname1 = sprintf('%s_UTE/Original/*.dcm',str{1}); 
        NumberOfSlicesUTE = length(dir(fname1))/2;       
        
        
        
        
%% Reading the mask
        fidr0 = sprintf('%s_MASK/%s.img',str{1},str2{1});
        fid0 = fopen(fidr0);
        MASK = fread(fid0,'uint8','ieee-be'); 
        fclose(fid0);
        MASK = reshape(MASK,256,256,NumberOfSlices);
        MASK = permute(MASK,[2,1,3]);
        
        
        
        
%% Reading UTE1
        fidr1 = sprintf('%s_UTE/UTE1.img',str{1});
        fid1 = fopen(fidr1);
        UTE1 = fread(fid1,'uint16','ieee-be'); 
        fclose(fid1);
        UTE1 = reshape(UTE1,256,256,NumberOfSlicesUTE);
        UTE1 = permute(UTE1,[2,1,3]);        
%% Reading UTE2
        fidr2 = sprintf('%s_UTE/UTE2.img',str{1});
        fid2 = fopen(fidr2);
        UTE2 = fread(fid2,'uint16','ieee-be'); 
        fclose(fid2);
        UTE2 = reshape(UTE2,256,256,NumberOfSlicesUTE);
        UTE2 = permute(UTE2,[2,1,3]);         
%% Reading UTE_T2
        fidr3 = sprintf('%s_UTE/UTE_T2.img',str{1});
        fid3 = fopen(fidr3);
        UTE_T2 = fread(fid3,'uint16','ieee-be'); 
        fclose(fid3);
        UTE_T2 = reshape(UTE_T2,256,256,NumberOfSlicesUTE);
        UTE_T2 = permute(UTE_T2,[2,1,3]);
        
        
%% UTE Original
        UTE=UTE1-UTE2;
        
%% Normalizing segmented volume UTE_T2
        UTE_S=(UTE_T2~=0)*1;


%% Negative UTE WS gap
        
      delta = str2num(str{2}); %UTEs shift with respect to WaterSat


        if delta<0
            b=abs(delta);
            UTE_S(:,:,1:a)=0;
            UTE(:,:,1:a)=0;
            a=b+1;
        else
           a=1; 
        end
        
        
        
%% Processing
        for k=a:NumberOfSlicesUTE
    
        %%% Masking
        
                for i=1:256
                    for j=1:256   
                        
                     if MASK(i,j,k+delta)==0
                        
                        UTE(i,j,k) = 0;
                        UTE_S(i,j,k) = 0;
                      
                        end
                    end   
                end      
        end
        
        %% Saving results
        
        %%% Original
        UTE = permute(UTE,[2,1,3]);
        
        fidw=sprintf('%s_UTE_SEG_%s/UTE-%s.img',str{1},str2{1},str2{1});  
        fname = fopen(fidw,'w+','l');
        fwrite(fname,UTE,'uint16','ieee-be');
        fclose(fname);
        
        
        %%% Segmented
        UTE_S = permute(UTE_S,[2,1,3]);
        
        fidw=sprintf('%s_UTE_SEG_%s/UTE_S-%s.img',str{1},str2{1},str2{1});  
        fname = fopen(fidw,'w+','l');
        fwrite(fname,UTE_S,'uint16','ieee-be');
        fclose(fname);
   
        
    end
    
    end