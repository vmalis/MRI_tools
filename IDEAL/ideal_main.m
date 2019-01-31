%=========================================================================
%  IDEAL ULLS Analysis
%=========================================================================
%
% This script
%     a) 
%
% INput:  1)
%
% OUTput: 1) 
%__________________________________________________________________________
% required subroutines:
%
%   1)
%
%__________________________________________________________________________
% written by Vadim Malis
% 04/16 at UCSD RIL
%==========================================================================

%% data directories
    window_info=sprintf('pick root data folder');
    PathName = uigetdir('~/Desktop',window_info);
    cd(PathName)
    [~,fat_list] = system('find . -type d | grep FAT');
    [~,water_list] = system('find . -type d | grep WATER');
    k = strfind(fat_list,'.');
    l = strfind(water_list,'.');
    
    for i=1:size(k,2)-1
        fat(i).dir=fat_list(k(i)+1:k(i+1)-2);
        water(i).dir=water_list(l(i)+1:l(i+1)-2);
    end

    fat(size(k,2)).dir=fat_list(k(i+1)+1:end-1);
    water(size(l,2)).dir=water_list(l(i+1)+1:end-1);

%% Stats structure

IDEAL.name='';
IDEAL.when='';
IDEAL.fat=0;
    
    
%% Create structure

for j=1:size(k,2)/2

    j
    
    %1st set
    
    %read 1st fat set
    path=[pwd,fat(j*2-1).dir];
	FAT_1=dicom2struct(path,'fat');
    %------------------------------------------------------------  
        cd(PathName)
	%------------------------------------------------------------  
	%read 1st water set
    path=[pwd,water(j*2-1).dir];
	WATER_1=dicom2struct(path,'water');
    
    % calculate fat content in percent
    X_1=double(FAT_1)./double(FAT_1+WATER_1);
    
    %load masks if exist
    if exist('SOL_mask.mat','file')
    temp=load('SOL_mask.mat');
    SOL_1=temp.SOL;
    X_SOL_1=double(SOL_1).*double(X_1);
    sol_1=nansum(SOL_1(:));
    x_sol_1=nansum(X_SOL_1(:));
    else
    sol_1=0;
    x_sol_1=0;
    end
    
    if exist('GL_mask.mat','file')
    temp=load('GL_mask.mat');
    GL_1=temp.GL;
    X_GL_1=double(GL_1).*double(X_1);
    gl_1=nansum(GL_1(:));
    x_gl_1=nansum(X_GL_1(:));
    else
    gl_1=0;
    x_gl_1=0;
    end
    
    if exist('GM_mask.mat','file')
    temp=load('GM_mask.mat');
    GM_1=temp.GM;
    X_GM_1=double(GM_1).*double(X_1);
    gm_1=nansum(GM_1(:));
    x_gm_1=nansum(X_GM_1(:));
    else
    gm_1=0;
    x_gm_1=0;
    end
    
    %------------------------------------------------------------  
        cd(PathName)
	%------------------------------------------------------------ 
    
    %2nd set
    
    %read 2nd fat set
    path=[pwd,fat(j*2).dir];
	FAT_2=dicom2struct(path,'fat');
    %------------------------------------------------------------  
        cd(PathName)
	%------------------------------------------------------------  
	%read 1st water set
    path=[pwd,water(j*2).dir];
	WATER_2=dicom2struct(path,'water');

    % calculate fat content in percent
    X_2=double(FAT_2)./double(FAT_2+WATER_2);
    
    %load masks if exist
    if exist('SOL_mask.mat','file')
    temp=load('SOL_mask.mat');
    SOL_2=temp.SOL;
    X_SOL_2=double(SOL_2).*double(X_2);
    sol_2=sum(SOL_2(:));
    x_sol_2=nansum(X_SOL_2(:));
    else
    sol_2=0;
    x_sol_2=0;
    end
    
    if exist('GL_mask.mat','file')
    temp=load('GL_mask.mat');
    GL_2=temp.GL;
    X_GL_2=double(GL_2).*double(X_2);
    gl_2=sum(GL_2(:));
    x_gl_2=nansum(X_GL_2(:));
    else
    gl_2=0;
    x_gl_2=0;
    end
    
    if exist('GM_mask.mat','file')
    temp=load('GM_mask.mat');
    GM_2=temp.GM;
    X_GM_2=double(GM_2).*double(X_2);
    gm_2=sum(GM_2(:));
    x_gm_2=nansum(X_GM_2(:));
    else
    gm_2=0;
    x_gm_2=0;
    end
    
    sol=sol_1+sol_2;
    gm=gm_1+gm_2;
    gl=gl_1+gl_2;
    x_sol=x_sol_1+x_sol_2;
    x_gm=x_gm_1+x_gm_2;
    x_gl=x_gl_1+x_gl_2;
    
    index = strfind(fat(j*2-1).dir,'/');
    
    STAT(j).id   = fat(j*2-1).dir(index(2)+1:index(3)-1);
    STAT(j).when = fat(j*2-1).dir(index(1)+1:index(2)-1);
    STAT(j).sol  = x_sol/sol;
    STAT(j).gl   = x_gl/gl;
    STAT(j).gm   = x_gm/gm;
    
    
    cd(PathName)
    
end  

 clearvars -except STAT
 
 nestedSortStruct(STAT,'id')