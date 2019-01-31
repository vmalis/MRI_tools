%% osirix .csv to .mat mask converter
% needs folder with dicoms and osirix.rois.seris +
% subroutine interppolygon
%
% written by Vadim Malis
% 09/14 at UCSD RIL
%==========================================================================

%read csv------------------------------------------------------------------
csv=dir('*.csv');
filename=csv(1).name;
fid = fopen(filename);
FC = textscan(fid, '%s', 'delimiter', '\n');
fclose(fid);
FC = FC{1};
% separator ','
FC = strcat(',', FC);
% read all columns
data_temp = regexp(FC, ',([^,]*)', 'tokens');

    if str2double(data_temp{2,1}{1,1})==0;
    delta=1;
    else
    delta=0;
    end

%--------------------------------------------------------------------------
%create zeros volumes
folder=folder_list(pwd);
cd(folder(1).name)
list=dir('*.dcm');
GM = zeros(512,512,size(list,1));
GL = zeros(size(GM));
SOL= zeros(size(GM));

multiWaitbar('progress...', 0, 'Color', 'r');
%--------------------------------------------------------------------------
n=size(data_temp,1);
for i=2:n
    data=flattenCell(data_temp{i,1});    
    X=cat(1,str2double(data(19:5:end)),str2double(data(20:5:end)));
    X=cat(2,X,X(:,1));
    X(isnan(X))=[];
    if size(X,1)==1
    X=reshape(X,[2,size(X,2)/2]);
    end
    Y=interppolygon(X',100);
    MASK=poly2mask(Y(:,1),Y(:,2),512,512);   
    if strcmp(data{1,8},'"SOL"')||strcmp(data{1,8},'SOL')
    SOL(:,:,delta+str2double(data{1,1}))=MASK;   
    elseif strcmp(data{1,8},'"GM"')||strcmp(data{1,8},'GM')
    GM(:,:,delta+str2double(data{1,1}))=MASK;        
    elseif strcmp(data{1,8},'"GL"')||strcmp(data{1,8},'GL')
    GL(:,:,delta+str2double(data{1,1}))=MASK;
    end  
    
     multiWaitbar('progress...', (i-1)/(n-1));
end 
multiWaitbar('progress...', 'Close');
%--------------------------------------------------------------------------
%save mat
cd ..
if sum(GM(:))>0
save ('GM_mask.mat','GM')
end
if sum(GL(:))>0
save ('GL_mask.mat','GL')
end
if sum(SOL(:))>0
save ('SOL_mask.mat','SOL')
end
clear all
%end