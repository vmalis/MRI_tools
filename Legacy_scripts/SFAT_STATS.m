%% SFAT Stats


t=1;
C=cell(11,2);

C{t,1}=sprintf('Subject');
C{t,2}=sprintf('Ratio');






%% Generating names of the folders to be processed
 for str = {'Seniors/KH/KH','Seniors/MD/MD','Seniors/AH/AH','Seniors/CW/CW','Seniors/YC/YC','Junior/AM/AM','Junior/HT/HT','Junior/MM/MM','Junior/MW/MW','Junior/YT/YT'}    
   t=t+1;
        
%% Read mask

fname=sprintf('%s_MASK/OB.img',str{1});
fid = fopen(fname);
OB = fread(fid,'uint8','ieee-be');
fclose(fid);

%% Read mask

fname=sprintf('%s_RESULTS/SFAT.img',str{1});
fid = fopen(fname);
SFAT = fread(fid,'uint8','ieee-be');
fclose(fid);


%%%% Percent

P=nnz(SFAT)/(nnz(SFAT)+nnz(OB));


C{t,1}=sprintf('%s', str{1});
C{t,2}=P;




    end
   