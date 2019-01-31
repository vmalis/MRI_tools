  cd ~/Desktop/DATA


%%% The function will create a T2 image stack from two UTE stacks with the
%%% different TE and will also perform segmentation based on conditions for
%%% T2 of the specific tissue

%%% Background threshold
threshold=80;


for str = {'Seniors/KH/KH','Seniors/MD/MD','Seniors/AH/AH','Seniors/CW/CW','Seniors/YC/YC','Junior/AM/AM','Junior/HT/HT','Junior/MM/MM','Junior/MW/MW','Junior/YT/YT'}
    




%%% Number of Slices
     fname1 = sprintf('%s_UTE/Original/*.dcm',str{1}); 
     q = length(dir(fname1))/2;  
%%%


te=2.9; %   te = TE2-TE1


% To read in the  image file at TE1 1
fidr1 = sprintf('%s_UTE/UTE1.img',str{1})
fid = fopen(fidr1,'r+','l'); % filename
teone = fread(fid,'uint16=>uint16','ieee-be');
teone = reshape(teone,256,256,q); % X, Y and Z dimension of the image file
teone = permute(teone,[2 1 3]);
fclose(fid);



% To read in the image file at TE 2
fidr2 = sprintf('%s_UTE/UTE2.img',str{1})
fid = fopen(fidr2,'r+','l'); % filename
tetwo = fread(fid,'uint16=>uint16','ieee-be');
tetwo = reshape(tetwo,256,256,q); % X, Y and Z dimension of the image file
tetwo = permute(tetwo,[2 1 3]);
fclose(fid);



[width, height, depth] = size(teone);
T2image = zeros(width,height,depth); %initializing T2



% Loop through all voxel coordinates
for z=1:size(teone,3),
 for x=1:size(teone,1),
   for y=1:size(teone,2),
    
            
            % Only process a pixel if it isn't background
           if(teone(x,y,z))> threshold
               y_e=[double(tetwo(x,y,z))/double(teone(x,y,z))];
               y_loge=-(log(y_e));
                r = y_loge/te;
                %if ((r<0.0)||(1/r>8)) 
                %    T2image(x,y)=0.0;
                %else
                T2image(x,y,z)=1/r;
                %end;
           else
               T2image(x,y,z)=0.0;
           end;
        end;
    end;
end;

T2image=permute(T2image,[2,1,3]);

fidw=sprintf('%s_UTE/UTE_T2_MAP.img',str{1});  
fname = fopen(fidw,'w+','l');
fwrite(fname,T2image,'uint16','ieee-be');
fclose(fname);

end



