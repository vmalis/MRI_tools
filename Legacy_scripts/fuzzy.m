%%%%% This code performs the gradient thresholding, saves output image
%%%%% stacks and gives the ratio of nonzero voxels for original and output
%%%%% images




%% Generating names of the folders to be processed
    for str = {'Seniors/KH/KH'}
    
    %%% Muscle names
    for str2 ={'SOL'}

        
        
        
        
%% Number of slices (Basicaly gives the number of dicom files in the folder with masked, bias corrected WaterSat images)
        fname0 = sprintf('/Users/vadmalis/Desktop/DATA/%s_WS_MASKED_BC/*.dcm',str{1}); 
        NumberOfSlices = length(dir([fname0]));
    
        
        
        
        
%% Reading the mask
        fidr0 = sprintf('/Users/vadmalis/Desktop/DATA/%s_MASK/%s.img',str{1},str2{1})
        fid0 = fopen(fidr0);
        MASK = fread(fid0,'uint8','ieee-be'); 
        fclose(fid0);
        MASK = reshape(MASK,256,256,NumberOfSlices);
        MASK = permute(MASK,[2,1,3]);
        
        
        
        
        
        
        
%% Processing
        for k=1:NumberOfSlices
    
        
        %%% Masking Dicom images
            fnamed=sprintf('/Users/vadmalis/Desktop/DATA/%s_WS_MASKED_BC/IMG00%.2d.dcm',str{1},k);
            I = dicomread(fnamed);
            
   
                for i=1:256
                    for j=1:256
    
                        if MASK(i,j,k)==0
                        I(i,j)=0;
                
                        end
                    end   
                end
                
                
                
                
                
        %%% Gradient thresholding            
        
                    %%% A condition to perform a thresholding only when there're nonzero voxels
                    if nnz(I)>0
        
        
                    %%% Creating the matrix that includes only nonzero elements (get rid of the background)    
        
                   fim=mat2gray(I);
                   [bwfim1,level1]=fcmthresh(fim,1);
                   W=bwfim1
            
                    else
                    W=zeros(256,256);
                    end

                    
            %%% Writing segmented slices to a file
            fidw1 = sprintf('/Users/vadmalis/Desktop/DATA/%s_WS_SEG_%s/M%.2d.dat',str{1},str2{1},k);    
            fname1 = fopen(fidw1,'w+','l');
            W = permute(W,[2,1]);
            fwrite(fname1,W,'uint8','ieee-be');
            fclose(fname1);
  

            %%% Writing masked images of the muscles
            fidw2=sprintf('/Users/vadmalis/Desktop/DATA/%s_WS_SEG_%s/O%.2d.dat',str{1},str2{1},k);  
            fname2 = fopen(fidw2,'w+','l');
            I = permute(I,[2,1]);
            fwrite(fname2,I,'uint16','ieee-be');
            fclose(fname2);   

        end


%% Merging output of Segmentation into a single Stack
WS_S = zeros(256,256,NumberOfSlices);
WS = zeros(256,256,NumberOfSlices);

        for i=1:NumberOfSlices
   
    
             %%% FAT Segmented
             fidr1 = sprintf('/Users/vadmalis/Desktop/DATA/%s_WS_SEG_%s/M%.2d.dat',str{1},str2{1},i);   
             fid1 = fopen(fidr1);
             X = fread(fid1,'uint8','ieee-be');
             X = reshape(X,256,256);
             WS_S(:,:,i)=X(:,:);                                                                                                                                                                                                                                                                                                                                    ; 
             fclose(fid1);
    
             %%% Original Stack
             fidr2 = sprintf('/Users/vadmalis/Desktop/DATA/%s_WS_SEG_%s/O%.2d.dat',str{1},str2{1},i);
             fid2 = fopen(fidr2);
             Y = fread(fid2,'uint16','ieee-be');
             Y = reshape(Y,256,256);
             WS(:,:,i)=Y(:,:);
             fclose(fid2);
    
    
        end

fidw3=sprintf('/Users/vadmalis/Desktop/DATA/%s_WS_SEG_%s/WS_S-%s.img',str{1},str2{1},str2{1});  
fname3 = fopen(fidw3,'w+','l');
fwrite(fname3,WS_S,'uint8','ieee-be');
fclose(fname3);


fidr4=sprintf('/Users/vadmalis/Desktop/DATA/%s_WS_SEG_%s/WS-%s.img',str{1},str2{1},str2{1});  
fname4 = fopen(fidr4,'w+','l');
fwrite(fname4,WS,'uint16','ieee-be');
fclose(fname4);


    end
end
    