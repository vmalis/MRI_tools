clear all; close all; clc
cd ~/Desktop;
! rm -r UTE_Proc
 
%% Read in UTE images
 
% Series 5/1
%info51 = dicom_read_header('S5_1/IM-0001-0001.dcm');
%s51 = dicom_read_volume(info51);
 
% Series 5/2
info52 = dicom_read_header('S5_2/IM-0001-0002.dcm');
s52 = dicom_read_volume(info52);
 
% Series 6/1
%info61 = dicom_read_header('S6_1/IM-0002-0001.dcm');
%s61 = dicom_read_volume(info61);
 
% Series 6/2
info62 = dicom_read_header('S6_2/IM-0002-0002.dcm');
s62 = dicom_read_volume(info62);
 
%% Subtract echoes and merge series
s5Sub = s52;
s6Sub = s62;
 
ute = [];
for i = 1:size(s5Sub,3)
    ute = cat(3,ute,s5Sub(:,:,i),s6Sub(:,:,i));
end
 
%% Create new header for new series
 
% zStart = info51.ImagePositionPatient(3);
% zEnd = zStart - info51.SliceThickness.*size(s5Sub,3).*2 + ...
%     info51.SliceThickness;
% z = [zStart:-info51.SliceThickness:zEnd];
 
% info = info51;
% info.SliceLocation = z;
info.SeriesNumber = 55;
info.SeriesDescription = 'UTE_Processed';
 
%% Write results
 
% Get DICOM folder info for Scales
infoFold = dicom_folder_info('~/Desktop/S5_2');
scales = infoFold.Scales;
 
mkdir ~/Desktop/UTE_Proc
dicom_write_volume(ute,'~/Desktop/UTE_Proc/ute');
 
%% Move back home
cd ~/Documents/MATLAB/;
clc
