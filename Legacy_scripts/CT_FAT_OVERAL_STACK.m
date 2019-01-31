%%%  CT- FAT- Segmented overal image stacks



cd ~/Desktop/DATA



%% Generating names of the folders to be processed
    for str = {'Seniors/KH/KH','Seniors/MD/MD','Seniors/AH/AH','Seniors/CW/CW','Seniors/YC/YC','Junior/AM/AM','Junior/HT/HT','Junior/MM/MM','Junior/MW/MW','Junior/YT/YT'}
    


%% Read mask

%%%%CT



fname=sprintf('%s_Results/CT-GL.img',str{1});
fid = fopen(fname);
CT_GL = fread(fid,'uint16','ieee-be');
fclose(fid);




fname=sprintf('%s_Results/CT-GM.img',str{1});
fid = fopen(fname);
CT_GM = fread(fid,'uint16','ieee-be');
fclose(fid);




fname=sprintf('%s_Results/CT-SOL.img',str{1});
fid = fopen(fname);
CT_SOL = fread(fid,'uint16','ieee-be');
fclose(fid);




CT = CT_GL+CT_GM+CT_SOL;
CT=CT/2;



fidw=sprintf('%s_Results/CT.img',str{1});  
fname = fopen(fidw,'w+','l');
fwrite(fname,CT,'uint16','ieee-be');
fclose(fname);





%%% FAT


fname=sprintf('%s_Results/FAT-GL.img',str{1});
fid = fopen(fname);
FAT_GL = fread(fid,'uint16','ieee-be');
fclose(fid);



fname=sprintf('%s_Results/FAT-GM.img',str{1});
fid = fopen(fname);
FAT_GM = fread(fid,'uint16','ieee-be');
fclose(fid);



fname=sprintf('%s_Results/FAT-SOL.img',str{1});
fid = fopen(fname);
FAT_SOL = fread(fid,'uint16','ieee-be');
fclose(fid);



fname=sprintf('%s_Results/X-GL.img',str{1});
fid = fopen(fname);
X_GL = fread(fid,'uint16','ieee-be');
fclose(fid);



fname=sprintf('%s_Results/X-GM.img',str{1});
fid = fopen(fname);
X_GM = fread(fid,'uint16','ieee-be');
fclose(fid);



fname=sprintf('%s_Results/X-SOL.img',str{1});
fid = fopen(fname);
X_SOL = fread(fid,'uint16','ieee-be');
fclose(fid);




X=X_GL+X_GM+X_SOL;
X=X/3;



FAT = FAT_GL+FAT_GM+FAT_SOL+X;



fidw=sprintf('%s_Results/FAT.img',str{1});  
fname = fopen(fidw,'w+','l');
fwrite(fname,FAT,'uint16','ieee-be');
fclose(fname);


    end


