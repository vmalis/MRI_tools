%%% The script will create the table with the ratio of three types of
%%% tissues


cd ~/Desktop/DATA


i=1;
C=cell(4,6);

C{1,i}=sprintf('Subject');
C{2,i}=sprintf('Original voxels');
C{3,i}=sprintf('FAT Ratio');
C{4,i}=sprintf('IMCT Ratio');
C{5,i}=sprintf('Pure Fat Ratio');
C{6,i}=sprintf('Total Fat Ratio');
C{7,i}=sprintf('NonC Ratio');



%% Generating names of the folders to be processed
    for str = {'Seniors/KH/KH','Seniors/MD/MD','Seniors/AH/AH','Seniors/CW/CW','Seniors/YC/YC','Junior/AM/AM','Junior/HT/HT','Junior/MM/MM','Junior/MW/MW','Junior/YT/YT'}
    
    %%% Muscle names
    for str2 ={'SOL','GM','GL'}
     
        i=i+1;
        


    
        
        
        
%%%Read CT+FAT segmented volume          
        
fidr1 = sprintf('%s_RESULTS/X-%s.img',str{1},str2{1});
fid1 = fopen(fidr1);
X = fread(fid1,'uint16','ieee-be');
fclose(fid1);        
               
        
%%%Read CT segmented volume        
        
fidr1 = sprintf('%s_RESULTS/CT-%s.img',str{1},str2{1});
fid1 = fopen(fidr1);
CT = fread(fid1,'uint16','ieee-be');
fclose(fid1);        
                
        
%%%Read FAT segmented volume

fidr1 = sprintf('%s_RESULTS/FAT-%s.img',str{1},str2{1});
fid1 = fopen(fidr1);
FAT = fread(fid1,'uint16','ieee-be');
fclose(fid1);


%%% Read the original volume

fidr2 = sprintf('%s_RESULTS/Original-%s.img',str{1},str2{1});
fid2 = fopen(fidr2);
Original = fread(fid2,'uint16','ieee-be');
fclose(fid2);



C{1,i}=sprintf('%s-%s',str{1},str2{1});


C{2,i}=nnz(Original);
C{3,i}=(nnz(FAT)+nnz(X)/nnz(Original);
C{4,i}=nnz(CT)/nnz(Original);
C{5,i}=nnz(X)/nnz(Original);
C{6,i}=(nnz(X)+nnz(FAT))/nnz(Original);
C{7,i}=(nnz(X)+nnz(FAT)+nnz(CT))/nnz(Original);


    end
    end
    
    
    C=C'











