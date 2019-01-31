cd ~/Desktop/DATA/Junior/YT



%% Subjects to b e processed
for str = {'YT'}


%% Reading the file   
fname2=sprintf('%s_EIGENVECTORS/%s_Eigenvectors.dat',str{1},str{1})
fid = fopen(fname2)
I = fread(fid,'float32');
fclose(fid);

%% Number of slices
d=int64(max(size(I)))/256/256/3

%% converting to 3d
I = reshape(I,3,256,256,d);


for k=1:d

for q=1:256
    for p=1:256
        
R(p,q)=(I(1,q,p,k));
G(p,q)=(I(2,q,p,k));
B(p,q)=(I(3,q,p,k));   
    
    
    end
end


%% Saving slice-channel separated files
fname1=sprintf('%s_EIGENVECTORS/%s_EigenVec_R%.2d.dat',str{1},str{1},k);
fname2=sprintf('%s_EIGENVECTORS/%s_EigenVec_G%.2d.dat',str{1},str{1},k);
fname3=sprintf('%s_EIGENVECTORS/%s_EigenVec_B%.2d.dat',str{1},str{1},k);

fid1 = fopen(fname1,'w+','l');
fid2 = fopen(fname2,'w+','l');
fid3 = fopen(fname3,'w+','l');

fwrite(fid1,R,'real*4','ieee-be');
fclose(fid1);
fwrite(fid2,G,'real*4','ieee-be');
fclose(fid2);
fwrite(fid3,B,'real*4','ieee-be');
fclose(fid3);



end
end
