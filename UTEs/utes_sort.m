%% UTEs sort
%
% !!!Works only in case when no new landmark was issued durring the scan!!!
%
% The script sorts UTEs MR Images acoording to location and echo
%
% Input: path to folders with UTES exported from OsiriX and RX coordinates
% from the IDEAL Stack. It also takes care of unwanted RX movments
%
% Outpt: Sorted UTE struct with location, TE (also saved as .mat in cd)
%
%   USAGE: 
%   path = uigetdir('~/Desktop');
%   [UTE,row,col,IM_num]=utes_sort(path,x,y);
%
%       to access images from struct use the folowing:
%       IMAGES=reshape([UTE.image],row,col,IM_num);
%
%       to view stack:
%       implay(mat2gray(reshape([UTE.image],row,col,IM_num)));
%
% _____________________________________________________
% written by Vadim Malis
% 10/14 at UCSD RIL


function [UTE,row,col,IM_num]=utes_sort(path)

cd(path)

    path2=dir;
    
% valid for mac not to include system files and folders
%__________________________________________________________________________
for k = length(path2):-1:1
    % remove non-folders
    if ~path2(k).isdir
        path2(k) = [ ];
        continue
    end

    % remove folders starting with .
    fname = path2(k).name;
    if fname(1) == '.'
        path2(k) = [ ];
    end
end
%__________________________________________________________________________
    
size(path2,1);
for j=1:size(path2,1)
    
        cd(path2(j).name)
        dicom_path=dir('*dcm');
        
        % create zero volumes of appropriate size after reading dimensional
        % info of 1st image in each slice (number of phases, rows, etc)

        info           =  dicominfo(dicom_path(1).name);
        num_im         =  info.ImagesInAcquisition;
        row            =  info.Rows;
        col            =  info.Columns;    
        INFO           =  info.PatientName.FamilyName;

        im      =zeros(row, col, num_im);
        location=zeros(num_im,1);
        echotime=zeros(num_im,1);
        echonum=zeros(num_im,1);

        for k=1:num_im
            info_temp   = dicominfo(dicom_path(k).name);
            im(:,:,k)   = double(dicomread(dicom_path(k).name));
            location(k) = int16(info_temp.SliceLocation);
            x_pos(k)    = double(info_temp.ImagePositionPatient(1));
            y_pos(k)    = double(info_temp.ImagePositionPatient(2));
            x_res(k)       = double(info_temp.PixelSpacing(1));
            y_res(k)       = double(info_temp.PixelSpacing(2));
            echotime(k) = info_temp.EchoTime;
            echonum(k)  = info_temp.EchoNumber;
        end
        
        STACKtemp(j).image =im;
        STACKtemp(j).loc   =location;
        STACKtemp(j).te    =echotime;
        STACKtemp(j).tenum =echonum;
        STACKtemp(j).x_pos =x_pos;
        STACKtemp(j).y_pos =y_pos;
        STACKtemp(j).x_res =x_res;
        STACKtemp(j).y_res =y_res;
 
       
        
cd ..

end




%total number of images
IM_num=0;
for i=1:size([STACKtemp],2)
IM_num=IM_num+size([STACKtemp(i).loc],1);
end  

IMAGE=zeros(row,col);
LOC=0;
TE=0;
TEN=0;
X=0;
Y=0;
X_res=0;
Y_res=0;
    
for i=1:size(path2,1)     
    IMAGE= cat(3,IMAGE,[STACKtemp(i).image]);
    LOC  = cat(1,LOC,[STACKtemp(i).loc]);
    TE   = cat(1,TE,[STACKtemp(i).te]);
    TEN  = cat(1,TEN,[STACKtemp(i).tenum]);
    X    = cat(1,X,[STACKtemp(i).x_pos]');
    Y    = cat(1,Y,[STACKtemp(i).y_pos]');
    X_res= cat(1,X_res,[STACKtemp(i).x_res]');
    Y_res= cat(1,Y_res,[STACKtemp(i).y_res]');
    
    
end
    
IMAGE(:,:,1)=[];
LOC(1)=[];
TE(1) =[];
TEN(1)=[];
X(1)=[];
Y(1)=[];
X_res(1)=[];
Y_res(1)=[];
   
clearvars -except IMAGE LOC TE TEN IM_num row col INFO X Y X_res Y_res x y

  
for i=1:IM_num
    UTE(i).image    = IMAGE(:,:,i);
    UTE(i).location = LOC(i);
    UTE(i).te       = TE(i);
    UTE(i).tenum    = TEN(i);
    UTE(i).x_pos    = X(i);
    UTE(i).y_pos    = Y(i);
    UTE(i).x_res    = X_res(i);
    UTE(i).y_res    = Y_res(i);
    
end    


clearvars -except UTE row col IM_num INFO x y


UTE=nestedSortStruct(UTE,'location',1);


unique_id=([UTE.location]+[UTE.te]/3)';

[~, ind] = unique(unique_id, 'rows');
% duplicate slices
duplicate_ind = setdiff(1:size(unique_id, 1), ind);

UTE(duplicate_ind)=[];


IM_num=IM_num-size(duplicate_ind,2);




cd ..

save (['UTE_' INFO '.mat'],'UTE');
save (['UTE_' INFO '.mat'],'row','-append');
save (['UTE_' INFO '.mat'],'col','-append');
save (['UTE_' INFO '.mat'],'IM_num','-append');

end