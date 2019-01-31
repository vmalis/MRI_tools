%%% This script performe the analysis of the segmented WaterSat
%%% The output is array C which is a table with all the stats



cd ~/Desktop/DATA2

i=1;
C=cell(4,10);

C{1,i}=sprintf('Subject');
C{2,i}=sprintf('Original voxels');
C{3,i}=sprintf('Segmented fat');
C{4,i}=sprintf('Ratio');

for str = {'Junior/VM/VM','Junior/RC/RC','Seniors/US/US'}
    
    for str2 ={'SOL','GM','GL'}
     
        i=i+1;
        

        
%% Read the segmented volume

fidr1 = sprintf('%s_WS_SEG_%s/WS_S-%s.img',str{1},str2{1},str2{1});
fid1 = fopen(fidr1);
Segmented = fread(fid1,'uint8','ieee-be');
fclose(fid1);



%% Read the original volume

fidr2 = sprintf('%s_WS_SEG_%s/WS-%s.img',str{1},str2{1},str2{1});
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

    