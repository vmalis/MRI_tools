%% CT FAT Neighbour
cd ~/Desktop/DATA


t=1;
C=cell(11,2);

C{t,1}=sprintf('Subject');
C{t,2}=sprintf('Ratio');





%% Generating names of the folders to be processed
     for str = {'Seniors/KH/KH','Seniors/MD/MD','Seniors/AH/AH','Seniors/CW/CW','Seniors/YC/YC','Junior/AM/AM','Junior/HT/HT','Junior/MM/MM','Junior/MW/MW','Junior/YT/YT'}
        t=t+1;




%% Read mask

%%%     CT
fname=sprintf('%s_Results/CT.img',str{1});
fid = fopen(fname);
CT = fread(fid,'uint16','ieee-be');
fclose(fid);



%%%     FAT

fname=sprintf('%s_Results/FAT.img',str{1});
fid = fopen(fname);
FAT = fread(fid,'uint16','ieee-be');
fclose(fid);




%%% Number of slices in  stack
D = max(size(FAT))/256/256


CT = reshape(CT,256,256,D);
FAT = reshape(FAT,256,256,D);



%%  Filtering matrix

for k=1:3
        for j=1:3
            for i=1:3
            B(i,j,k)=1;
            end
        end
end

B(2,2,2)=0;



%% Convolving with the Filter

X=convn(CT, B, 'same');


%% Checking for the 0-value voxels in Fat

for k=1:D
    for i=1:256
        for j=1:256
            if FAT (i,j,k)<1
               X(i,j,k)=0;
            end
        end
    end
end

%% Result

P=nnz(X)/nnz(FAT);


C{t,1}=sprintf('%s', str{1});
C{t,2}=P;

    end
         