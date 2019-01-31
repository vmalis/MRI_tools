% The script merges Diffusion volume performing registration for two
% interleaved slices
%
% Input: DTI and IDEAL
% Outpt: Merged DTI and IDEAL in separate folders with transformations
% _____________________________________________________
% written by Vadim Malis
% 12/15 at UCSD RIL


%% IDEAL Merge
%-------------------read images--------------------------------------------
cd Proximal

temp_list=folder_list(cd);
cd(temp_list(end).name)
temp_list=dir('*.dcm');

h=waitbar(0,'reading proximal');
n=size(temp_list,1);

    for i=1:size(temp_list,1)
        info=dicominfo(temp_list(i).name);
        proximalIDEAL(i).Image=dicomread(temp_list(i).name);
        proximalIDEAL(i).info=info;
        proximalIDEAL(i).location=info.SliceLocation;
        waitbar(i/n)
    end
    
close(h)
cd ..
cd ..

cd Distal

temp_list=folder_list(cd);
cd(temp_list(end).name)
temp_list=dir('*.dcm');

h=waitbar(0,'reading distal');
n=size(temp_list,1);

    for i=1:n
        info=dicominfo(temp_list(i).name);
        distalIDEAL(i).Image=dicomread(temp_list(i).name);
        distalIDEAL(i).info=info;
        distalIDEAL(i).location=info.SliceLocation;
        waitbar(i/n)
    end
    
close(h)
cd ..
cd ..

%-------find closest-------------------------------------------------------

[~,ia,ib]=intersect([proximalIDEAL.location],[distalIDEAL.location]);

I_1=proximalIDEAL(ia).Image;
I_2=distalIDEAL(ib).Image;

clearvars -except I_1 I_2 distal proximal proximalIDEAL distalIDEAL

%----------registration----------------------------------------------------
[optimizer,metric] = imregconfig('monomodal');
tform = imregtform(I_2,I_1,'rigid',optimizer,metric);
Rfixed = imref2d(size(I_1));
I_3 = imwarp(I_2,tform,'OutputView',Rfixed);

figure, imshowpair(I_2, I_1)
title('Unregistered IDEAL')
saveas(gcf,'IDEAL_unregistered.png')

figure, imshowpair(I_3, I_1);
title('Registered IDEAL');
saveas(gcf,'IDEAL_registered.png')

%--------save transformation-----------------------------------------------
clearvars -except Rfixed tform proximalIDEAL distalIDEAL
save('transformation_ideal.mat','Rfixed','tform')

%---------writing dicoms---------------------------------------------------

mkdir Merged_IDEAL
cd Merged_IDEAL

info_0=proximalIDEAL(1).info;

k=size(proximalIDEAL,2);
l=size(distalIDEAL,2);
n=k+l-1;

h=waitbar(0,'merging IDEAL volume, writing header');
    for i=1:n
        
        if i<=k
            mergedIDEAL(i).image=proximalIDEAL(i).Image;
            info=proximalIDEAL(i).info;
            info.SeriesTime=info_0.SeriesTime;
            info.AcquisitionTime=info_0.AcquisitionTime;
            info.ContentTime=info_0.ContentTime;
            info.SeriesDescription=info_0.SeriesDescription;
            info.SeriesInstanceUID=info_0.SeriesInstanceUID;
            info.SeriesNumber=info_0.SeriesNumber;
            info.InstanceNumber=i;
            info.ImagesInAcquisition=n;
            info.InStackPositionNumber=i;
            info.PerformedProcedureStepID=info_0.PerformedProcedureStepID;
            mergedIDEAL(i).info=info;
        else
            mergedIDEAL(i).image = imwarp(distalIDEAL(i-k+1).Image,...
                tform,'OutputView',Rfixed);
            info=distalIDEAL(i-k+1).info;    
            info.SeriesTime=info_0.SeriesTime;
            info.AcquisitionTime=info_0.AcquisitionTime;
            info.ContentTime=info_0.ContentTime;
            info.SeriesDescription=info_0.SeriesDescription;
            info.SeriesInstanceUID=info_0.SeriesInstanceUID;
            info.SeriesNumber=info_0.SeriesNumber;
            info.InstanceNumber=i;
            info.ImagesInAcquisition=n;
            info.InStackPositionNumber=i;
            info.PerformedProcedureStepID=info_0.PerformedProcedureStepID;
            mergedIDEAL(i).info=info; 
        end
        waitbar(i/n)
    end
     
close(h)

h=waitbar(0,'writing merged IDEAL dicoms');
    for i=1:n
        filename=sprintf('IM-0001-%.4d.dcm',i);
        dicomwrite(mergedIDEAL(i).image, filename, mergedIDEAL(i).info,...
            'writeprivate', true);
        waitbar(i/n)
    end
close(h)

%--------------------------------------------------------------------------
cd ..
clear all



%% Diffusion Merge
gradient_directions=33;

%-------------------read images--------------------------------------------
cd Proximal
cd ConvertedNIFTI

temp_list=dir('*.dcm');
h=waitbar(0,'reading proximal diffusion set');
n=size(temp_list,1);
for i=1:size(temp_list,1)
    proximalDTI(i).info=dicominfo(temp_list(i).name);
    proximalDTI(i).Image=dicomread(temp_list(i).name);
    waitbar(i/n)
end
close(h)
cd ..
cd ..

info_proximal=proximalDTI(1).info;
number_images_proximal = info_proximal.ImagesInAcquisition;

cd Distal
cd ConvertedNIFTI
temp_list=dir('*.dcm');
h=waitbar(0,'reading distal diffusion set');
n=size(temp_list,1);
for i=1:size(temp_list,1)
    distalDTI(i).info=dicominfo(temp_list(i).name);
    distalDTI(i).Image=dicomread(temp_list(i).name);
    waitbar(i/n)
end
close(h)
cd ..
cd ..

%-------getin' number of slices for each acqusition------------------------

info_distal=distalDTI(1).info;
number_images_distal = info_distal.ImagesInAcquisition;

slices_proximal=number_images_proximal/gradient_directions;
slices_distal=number_images_distal/gradient_directions;
number_of_images=(slices_proximal+slices_distal-1)*gradient_directions;

%-------find closest-------------------------------------------------------

baseline_proximal_location=zeros(slices_proximal,1);
baseline_distal_location=zeros(slices_distal,1);

for i=1:slices_proximal
    info=proximalDTI(i).info;
    baseline_proximal_location(i,1)=info.SliceLocation;
end

for i=1:slices_distal
    info=distalDTI(i).info;
    baseline_distal_location(i,1)=info.SliceLocation;
end

[~,ia,ib]=intersect(baseline_proximal_location,baseline_distal_location);

I_1=proximalDTI(ia).Image;
I_2=distalDTI(ib).Image;

%----------registration----------------------------------------------------
[optimizer,metric] = imregconfig('monomodal');
tform = imregtform(I_2,I_1,'affine',optimizer,metric);
Rfixed = imref2d(size(I_1));
I_3 = imwarp(I_2,tform,'OutputView',Rfixed);

figure, imshowpair(I_2, I_1)
title('Unregistered Diffusion Baseline');
saveas(gcf,'DTI_unregistered.png')

figure, imshowpair(I_3, I_1);
title('Registered Diffusion Baseline');
saveas(gcf,'DTI_registered.png')

%--------save transformation-----------------------------------------------
clearvars -except Rfixed tform proximalDTI distalDTI gradient_directions...
    slices_proximal slices_distal number_of_images
save('transformation_dti.mat','Rfixed','tform')

%---------writing dicoms---------------------------------------------------

mkdir Merged_DTI
cd Merged_DTI

info_0=proximalDTI(1).info;

s=1;

h=waitbar(0,'merging volume, writing header');
for i=1:gradient_directions
    
	for j=1:slices_proximal
        MergedDTI(s).image=proximalDTI((i-1)*slices_proximal+j).Image;
        info=proximalDTI((i-1)*slices_proximal+j).info;
        info.SeriesTime=info_0.SeriesTime;
        info.AcquisitionTime=info_0.AcquisitionTime;
        info.ContentTime=info_0.ContentTime;
        info.SeriesDescription=info_0.SeriesDescription;
        info.SeriesInstanceUID=info_0.SeriesInstanceUID;
        info.SeriesNumber=info_0.SeriesNumber;
        info.InstanceNumber=s;
        info.ImagesInAcquisition=number_of_images;
        info.InStackPositionNumber=j;
        info.PerformedProcedureStepID=info_0.PerformedProcedureStepID;
        MergedDTI(s).info=info;
        s=s+1;
    end
    
    for k=2:slices_distal    
        MergedDTI(s).image = imwarp(distalDTI((i-1)*...
            slices_distal+k).Image,tform,'OutputView',Rfixed);
        info=distalDTI((i-1)*slices_distal+k).info;    
        info.SeriesTime=info_0.SeriesTime;
        info.AcquisitionTime=info_0.AcquisitionTime;
        info.ContentTime=info_0.ContentTime;
        info.SeriesDescription=info_0.SeriesDescription;
        info.SeriesInstanceUID=info_0.SeriesInstanceUID;
        info.SeriesNumber=info_0.SeriesNumber;
        info.InstanceNumber=s;
        info.ImagesInAcquisition=number_of_images;
        info.InStackPositionNumber=j+k-1;
        info.PerformedProcedureStepID=info_0.PerformedProcedureStepID;
        MergedDTI(s).info=info;
        s=s+1;   
    end
    
    waitbar(i/gradient_directions)
    
end
close(h)


h=waitbar(0,'writing merged dicoms');
n=size(MergedDTI,2);
for i=1:n
    filename=sprintf('IM-0001-%.4d.dcm',i);
    dicomwrite(MergedDTI(i).image, filename, MergedDTI(i).info, 'writeprivate', true);
    waitbar(i/n)
end
close(h)

clearvars -except slices_distal slices_proximal



%% Mask merge
load('transformation_ideal.mat')

%--------------load proximal-----------------------------------------------
cd Proximal

if exist('SOL_mask.mat','file')
load('SOL_mask.mat')
SOL_proximal=SOL;
end

if exist('GL_mask.mat','file')
load('GL_mask.mat')
GL_proximal=GL;
end

if exist('GM_mask.mat','file')
load('GM_mask.mat')
GM_proximal=GM;
end

clear GM GL SOL

cd ..

%------------load distal---------------------------------------------------
cd Distal

if exist('SOL_mask.mat','file')
    load('SOL_mask.mat')
    SOL_distal=SOL;
    SOL_distal(:,:,1)=[];
    n=size(SOL_distal,3);
    for i=1:n
        SOL_distal(:,:,i)=imwarp(SOL_distal(:,:,i),tform,...
        'OutputView',Rfixed);
    end
    SOL=cat(3,SOL_proximal,SOL_distal); 

else 
    SOL=cat(3,SOL_proximal,zeros(size(SOL_proximal,1),size(SOL_proximal,2),...
        slices_distal-1));   
end

if exist('GL_mask.mat','file')
    load('GL_mask.mat')
    GL_distal=GL;
    GL_distal(:,:,1)=[];
    n=size(GL_distal,3);
    for i=1:n
        GL_distal(:,:,i)=imwarp(GL_distal(:,:,i),tform,...
        'OutputView',Rfixed);
    end
    GL=cat(3,GL_proximal,GL_distal); 

else 
    GL=cat(3,GL_proximal,zeros(size(GL_proximal,1),size(GL_proximal,2),...
        slices_distal-1));   
end

if exist('GM_mask.mat','file')
    load('GM_mask.mat')
    GM_distal=GM;
    GM_distal(:,:,1)=[];
    n=size(GM_distal,3);
    for i=1:n
        GM_distal(:,:,i)=imwarp(GM_distal(:,:,i),tform,...
        'OutputView',Rfixed);
    end
    GM=cat(3,GM_proximal,GM_distal); 

else 
    GM=cat(3,GM_proximal,zeros(size(GM_proximal,1),size(GM_proximal,2),...
        slices_distal-1));   
end
clearvars -except SOL GM GL

cd ..

%--------------------------------------------------------------------------
save('MASK.mat','SOL','GM','GL')
