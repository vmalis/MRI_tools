%%% DTI Surface from WS mask
cd ~/Desktop/DATA



%% Names of subject + starting position for the mask

for str = {'Seniors/YC/YC';
        1; 'YC'}
    
    for str2 ={'SOL','GM','GL','OB'}
 
        
        
 %%% Number of Slices of DTI
fname1 = sprintf('%s_DTI/*.dcm',str{1}); 
q = length(dir(fname1))/33;  

%%% Number of Slices of MASK
fname2 = sprintf('%s_FS/*.dcm',str{1}); 
p = length(dir(fname2));      
       
x = int8(str{2}); 
        
        
        
        
fname3 = sprintf('%s_MASK/%s.img',str{1},str2{1}); 
fid2 = fopen(fname3);

m = fread(fid2,'uint8','ieee-be'); fclose(fid2);
m = reshape(m,256,256,p); 




for i=1:q
    M(:,:,i)=m(:,:,i+x);
end




fname=sprintf('%s_MASK/%s-%s-DTI.img',str{1},str{3},str2{1})
size(M)

fid1 = fopen(fname,'w+','l');
fwrite(fid1,M,'uint8','ieee-be');
fclose(fid1);

clear M

    end
end
