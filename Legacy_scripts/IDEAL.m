%% IDEAL Segmentation

%%% UTE Mask

cd ~/Desktop/DATA2


%% Generating names of the folders to be processed
    
    %%% Two-dimm array: 1st path to the folder with data, 2nd is number of
    %%% mask's slice which corresponds to the first UTE's slice
    
    
   
   C{1,5}=sprintf('Ideal Ratio');


   
    p=1
    
   % for str = {'Seniors/AH/AH','Seniors/CW/CW','Junior/HT/HT','Junior/MW/MW','Junior/AM/AM'; '0','0','4','2','2'}
   
for str = {'Junior/VM/VM','Junior/RC/RC','Seniors/US/US';'0','0','0'}
       
   
   
    for str2 ={'SOL','GM','GL'}
     p=p+1;   
   
        
       %% Number of slices (Basicaly gives the number of dicom files in the WaterSat images folder)
       fname0 = sprintf('%s_WS/*.dcm',str{1}); 
       NumberOfSlices = length(dir(fname0));   
     
        
        
       %% Reading the mask
       fidr0 = sprintf('%s_MASK/%s.img',str{1},str2{1});
       fid0 = fopen(fidr0);
       MASK = fread(fid0,'uint8','ieee-be'); 
       fclose(fid0);
       MASK = reshape(MASK,256,256,NumberOfSlices);
       MASK = permute(MASK,[2,1,3]);
        
    
  
       %% Number of slices (Basicaly gives the number of dicom files in the UTE images folder)
       fname1 = sprintf('%s_IDEAL/WS/*.dcm',str{1}); 
       NumberOfSlicesIDEAL = length(dir(fname1)); 
       
       
   
        
    deltaz =  str2num(str{2});
    
    X=zeros(256,256,NumberOfSlicesIDEAL);
    
    for k=6:NumberOfSlicesIDEAL-6

    fname2=sprintf('%s_IDEAL/WS/IM-0001-00%.2d.dcm',str{1},k);
    fname3=sprintf('%s_IDEAL/FS/IM-0001-00%.2d.dcm',str{1},k);
    
    
    
    W=double(dicomread(fname2));
    F=double(dicomread(fname3));
   
   
    
            for i=1:256
                for j=1:256
                    if MASK(i,j,k)==0
                    Y(i,j,k)=0;
                    elseif F(i,j)==0
                    X(i,j,k)=0;
                    else
                    X(i,j,k)=F(i,j)/(W(i,j)+F(i,j));
                    end
                    end
                end
    end
    
    A{p,1}=sprintf('%s-%s', str{1}, str2{1});
    A{p,5}=sum(X(:))/nnz(MASK);
  
    
         XXX=permute(X,[2,1,3]);
fid2=sprintf('XXX.img');  
fname2 = fopen(fid2,'w+','l');
fwrite(fname2,X,'uint16','ieee-be');
fclose(fname2);
    
    
    
    
    
    end
   end
 