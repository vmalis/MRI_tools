%%% The script will give the CT ratio for the segmented UTEs on the slice
%%% base

cd ~/Desktop/DATA

C=cell(50,5);
C{1,1}=sprintf('Slice #');

for j=1:50
C{j+1,1} = j;
end


i=1;

for str = {'Junior/AM/AM','Junior/HT/HT','Junior/MM/MM','Junior/MW/MW','Junior/YT/YT'}
    
i=i+1;

C{1,i} = sprintf('%s',str{1});

for str2 ={'GM'}
 
    
    
    
    
    

%% Number of Slices
fname1 = sprintf('%s_UTE/Original/*.dcm',str{1}); 
q = length(dir(fname1))/2;

     

%% Read original volume
fidr1 = sprintf('%s_UTE_SEG_%s/UTE-%s.img',str{1},str2{1},str2{1});
fid1 = fopen(fidr1);
UTE = fread(fid1,'uint16','ieee-be'); 
fclose(fid1);
UTE = reshape(UTE,256,256,q);
UTE = permute(UTE,[2,1,3]);


%% Read segmented volume
fidr2 = sprintf('%s_UTE_SEG_%s/UTE_S-%s.img',str{1},str2{1},str2{1});
fid2 = fopen(fidr2);
UTE_S = fread(fid2,'uint16','ieee-be'); 
fclose(fid2);
UTE_S = reshape(UTE_S,256,256,q);
UTE_S = permute(UTE_S,[2,1,3]);



%% Writing data to the table

for k=1:q


Original = nnz(UTE(:,:,k));
Segmented = nnz(UTE_S(:,:,k));

if Original == 0
    ratio = 0;
else
ratio = Segmented/Original;
end

C{k+1,i} = ratio;


end
end
end
