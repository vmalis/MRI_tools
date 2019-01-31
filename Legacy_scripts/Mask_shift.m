%% MASK MOVING

cd ~/Desktop/DATA2



%% Number of slices (Basicaly gives the number of dicom files in the folder with masked, bias corrected WaterSat images)
        fname0 = sprintf('Junior/VM/VM_WS_MASKED_BC/*.dcm'); 
        NumberOfSlices = length(dir([fname0]));
    
        
        
        for str2 ={'SOL','GM','GL'}
        
        
        
%% Reading the mask
        fidr0 = sprintf('Junior/VM/VM_MASK/%s.img',str2{1})
        fid0 = fopen(fidr0);
        MASK = fread(fid0,'uint8','ieee-be'); 
        fclose(fid0);
        MASK = reshape(MASK,256,256,NumberOfSlices);
        MASK = permute(MASK,[2,1,3]);
        M=zeros(256,256,NumberOfSlices);
        
        for k=1:NumberOfSlices
            for i=1:256
                for j=1:246
                   M(i,j,k)=MASK(i,j+10,k);
                    
                    
                end
            end
        end
        
        
        
        
              XXX=permute(M,[2,1,3]);
fid2=sprintf('%s-mod.img',str2{1});  
fname2 = fopen(fid2,'w+','l');
fwrite(fname2,XXX,'uint16','ieee-be');
fclose(fname2);

clear M;

clear XXX;
        end
        