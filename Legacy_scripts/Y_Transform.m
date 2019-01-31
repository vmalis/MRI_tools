cd ~/Desktop/DATA

%% Reading UTE1
        fidr1 = sprintf('Seniors/MD/MD_UTE/UTE1.img');
        fid1 = fopen(fidr1);
        UTE1 = fread(fid1,'uint16','ieee-be'); 
        fclose(fid1);
        UTE1 = reshape(UTE1,256,256,46);
        UTE1 = permute(UTE1,[2,1,3]);        
%% Reading UTE2
        fidr2 = sprintf('Seniors/MD/MD_UTE/UTE2.img');
        fid2 = fopen(fidr2);
        UTE2 = fread(fid2,'uint16','ieee-be'); 
        fclose(fid2);
        UTE2 = reshape(UTE2,256,256,46);
        UTE2 = permute(UTE2,[2,1,3]);         
%% Reading UTE_T2
        fidr3 = sprintf('Seniors/MD/MD_UTE/UTE_T2.img');
        fid3 = fopen(fidr3);
        UTE_T2 = fread(fid3,'uint16','ieee-be'); 
        fclose(fid3);
        UTE_T2 = reshape(UTE_T2,256,256,46);
        UTE_T2 = permute(UTE_T2,[2,1,3]);
        
        UTE1_C = zeros(256,256,46);
        UTE2_C = zeros(256,256,46);
        UTE_T2_C = zeros(256,256,46);
        
        
        
       for k=1:46
           
           for i = 1:240
               for j = 1:256
                   
           UTE1_C(i,j,k) = UTE1 (i+16,j,k);
           UTE2_C(i,j,k) = UTE2 (i+16,j,k);
           UTE_T2_C(i,j,k) = UTE_T2 (i+16,j,k);
           
               end
           end
       end
       
%%%        
        
UTE1_C=permute(UTE1_C,[2,1,3]);
fid1=sprintf('Seniors/MD/MD_UTE/UTE1.img');  
fname1 = fopen(fid1,'w+','l');
fwrite(fname1,UTE1_C,'uint16','ieee-be');
fclose(fname1);

%%%

UTE2_C=permute(UTE2_C,[2,1,3]);
fid2=sprintf('Seniors/MD/MD_UTE/UTE2.img');  
fname2 = fopen(fid2,'w+','l');
fwrite(fname2,UTE2_C,'uint16','ieee-be');
fclose(fname2);

%%%

UTE_T2_C=permute(UTE_T2_C,[2,1,3]);
fid3=sprintf('Seniors/MD/MD_UTE/UTE_T2.img');  
fname3 = fopen(fid3,'w+','l');
fwrite(fname3,UTE_T2_C,'uint16','ieee-be');
fclose(fname3);



