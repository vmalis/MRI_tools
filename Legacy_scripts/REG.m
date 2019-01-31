
for k=14:14

g=k+2
fnameF=sprintf('/Users/vadmalis/Desktop/MD/FS_M/ute00000%.2d.dcm', k)
fnameM=sprintf('/Users/vadmalis/Desktop/MD/MD_UTEC/ute00000%.2d.dcm', g)    
    
fixed = dicomread(fnameF);
moving = dicomread(fnameM);



[optimizer,metric] = imregconfig('multimodal');



optimizer.MaximumIterations = 1200;

tic
movingRegistered500 = imregister(moving, fixed, 'affine', optimizer, metric);
time800 = toc

figure, imshowpair(movingRegistered500, fixed)
title('B: MaximumIterations = 500')



fnameC=sprintf('/Users/vadmalis/Desktop/DATA/Seniors/MD/MD_UTEC/IMG00%.2d.dcm', k);


dicomwrite (movingRegistered, fnameC)

end