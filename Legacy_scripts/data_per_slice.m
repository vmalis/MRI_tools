%CT and Fat per slice


STATS=zeros(100,1);


cd ('/Users/vadmalis/Desktop/Research/13 Segment&DTI')



%% Generating names of the folders to be processed
    for str = {'Seniors/AH/AH','Seniors/CW/CW','Seniors/KH/KH','Seniors/MD/MD','Seniors/YC/YC','Junior/AM/AM','Junior/HT/HT','Junior/MM/MM','Junior/MW/MW','Junior/YT/YT'; '1','-2','1','0','0','3','0','0','0','5'}
 

%%% Read Original Volume
fidr2 = sprintf('%s_RESULTS/Original-GM.img',str{1});
fid2 = fopen(fidr2);
Original = fread(fid2,'uint16','ieee-be');
fclose(fid2);
Original = reshape(Original,256,256,size(Original,1)/256/256);
Original = permute(Original,[2,1,3]);

        
% %%% Read Fat Segmented Volume
% fidr1 = sprintf('%s_RESULTS/FAT-GM.img',str{1});
% fid1 = fopen(fidr1);
% FAT = fread(fid1,'uint16','ieee-be');
% fclose(fid1);
% FAT = reshape(FAT,256,256,size(FAT,1)/256/256);
% FAT = permute(FAT,[2,1,3]);



%%% Read X Segmented Volume
fidr2 = sprintf('%s_RESULTS/X-GM.img',str{1});
fid2 = fopen(fidr2);
X = fread(fid2,'uint16','ieee-be');
fclose(fid2);
X = reshape(X,256,256,size(X,1)/256/256);
X = permute(X,[2,1,3]);


% %TRUE FAT
% F=FAT + X;


%%% Read CT Segmented Volume
fidr2 = sprintf('%s_RESULTS/CT-GM.img',str{1});
fid2 = fopen(fidr2);
CT = fread(fid2,'uint16','ieee-be');
fclose(fid2);
CT = reshape(CT,256,256,size(CT,1)/256/256);
CT = permute(CT,[2,1,3]);




%% UTEs segmented

CCC=CT+X;

temp=zeros(100,2);


for j=1:size(CCC,3)

original_temp=nnz(Original(:,:,j));

temp(j,1)=nnz(CCC(:,:,j));
temp(j,2)=temp(j,1)/original_temp*100;
% temp(j,3)=nnz(F(:,:,j));
% temp(j,4)=temp(j,3)/original_temp*100;

end




STATS=cat(2,STATS,temp);


    end
    








