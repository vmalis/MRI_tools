%%%   This function creates two separate .img UTE stacks with the different TE
%%%   time from two sets of dicom placed in the same folder
%%%   (First set ? IM-0001-00xx.dcm)
%%%   (Second et ? IM-0002-00xx.dcm)
%%%   Output: UTE1.img & UTE2.img


cd ~/Desktop/DATA



    %%% Generating names of the folders to be processed
    for str = {'Seniors/KH/KH','Seniors/MD/MD','Seniors/AH/AH','Seniors/CW/CW','Seniors/YC/YC','Junior/AM/AM','Junior/HT/HT','Junior/MM/MM','Junior/MW/MW','Junior/YT/YT'}
    


    %%% Reads the number of slices

    fname1 = sprintf('%s_UTE/Original/*.dcm',str{1}); 
    NumberOfSlicesUTE = length(dir(fname1))/2;          
     
    %%% Empty arrays for the UTE Image stacks
    TE1=zeros(256,256,NumberOfSlicesUTE);
    TE2=zeros(256,256,NumberOfSlicesUTE);

     
     
     
%% Sorting

for k=1:2:(NumberOfSlicesUTE-1)

    %%% First stack
    
    fname=sprintf('%s_UTE/Original/IM-0001-00%.2d.dcm',str{1},k);
    X1=dicomread(fname);
    TE1(:,:,k) = X1;
    
    
    fname=sprintf('%s_UTE/Original/IM-0002-00%.2d.dcm',str{1},k);
    Y1=dicomread(fname);
    TE1(:,:,k+1) = Y1;
    

    %%% Second stack
    
    fname=sprintf('%s_UTE/Original/IM-0001-00%.2d.dcm',str{1},k+1);
    X2=dicomread(fname);
    TE2(:,:,k) = X2;
    
    
    fname=sprintf('%s_UTE/Original/IM-0002-00%.2d.dcm',str{1},k+1);
    Y2=dicomread(fname);
    TE2(:,:,k+1) = Y2;
    
end  
    
%%% Writing first stack into a file

TE1=permute(TE1,[2,1,3]);
fid1=sprintf('%s_UTE/UTE1.img',str{1});  
fname1 = fopen(fid1,'w+','l');
fwrite(fname1,TE1,'uint16','ieee-be');
fclose(fname1);


%%% Writing second stack into a file

TE2=permute(TE2,[2,1,3]);
fid2=sprintf('%s_UTE/UTE2.img',str{1});  
fname2 = fopen(fid2,'w+','l');
fwrite(fname2,TE2,'uint16','ieee-be');
fclose(fname2);




end
    








