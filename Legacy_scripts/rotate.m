
for k = 2:2:46

fname=sprintf('/Users/vadmalis/Desktop/DATA/Seniors/KH/KH_UTE/ute00000%.2d.dcm',k);
X=dicomread(fname);

info = dicominfo(fname);
Y = dicomread(info)

B = imrotate(X,-2.6,'bicubic','crop')

fname2=sprintf('/Users/vadmalis/Desktop/DATA/Seniors/KH/KH_UTE_C/ute00000%.2d.dcm',k);    
         
dicomwrite(B, fname2, info, 'CreateMode', 'copy');

end
