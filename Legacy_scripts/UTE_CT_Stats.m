
cd ~/Desktop/DATA


i=1;
C=cell(4,4);

C{1,i}=sprintf('Subject');
C{2,i}=sprintf('Original voxels');
C{3,i}=sprintf('Segmented IMCT');
C{4,i}=sprintf('Ratio');

%% Generating names of the folders to be processed
    for str = {'Seniors/KH/KH','Seniors/MD/MD','Seniors/AH/AH','Seniors/CW/CW','Seniors/YC/YC','Junior/AM/AM','Junior/HT/HT','Junior/MM/MM','Junior/MW/MW','Junior/YT/YT'}
    
    %%% Muscle names
    for str2 ={'SOL','GM','GL'}
     
        i=i+1;
        

        
%% Read the segmented volume

fidr1 = sprintf('%s_UTE_SEG_%s/UTE_S-%s.img',str{1},str2{1},str2{1});
fid1 = fopen(fidr1);
Segmented = fread(fid1,'uint16','ieee-be');
fclose(fid1);



%% Read the original volume

fidr2 = sprintf('%s_UTE_SEG_%s/UTE-%s.img',str{1},str2{1},str2{1});
fid2 = fopen(fidr2);
Original = fread(fid2,'uint16','ieee-be');
fclose(fid2);


%%
SegmentedN=nnz(Segmented);
OriginalN=nnz(Original);
x=SegmentedN/OriginalN;

        label = sprintf('%s-%s', str{1}, str2{1});
        C{1,i}=label;
        C{2,i}=OriginalN;
        C{3,i}=SegmentedN;
        C{4,i}=x;
    

    end
end

C=C';