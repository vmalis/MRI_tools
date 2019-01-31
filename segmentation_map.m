UTE_post_te1=dicomread('IM-0002-0024.dcm');
UTE_post_te2=dicomread('IM-0002-0026.dcm');
UTE_post_te3=dicomread('IM-0002-0026.dcm');
UTE_post_te4=dicomread('IM-0002-0026.dcm');


FAT_post=dicomread('IM-0003-0025.dcm');
WATER_post=dicomread('IM-0001-0025.dcm');  


IMAT_post=(double(FAT_post)./double(WATER_post+FAT_post));    
IMAT_post(WATER_post<200)=0; 
IMAT_post(IMAT_post<.2)=0;
IMAT_post(IMAT_post>=.2)=1;



[optimizer,metric] = imregconfig('monomodal');
I_1=mat2gray(UTE_post_te2);
I_2=mat2gray(imresize(WATER_post,.5));
tform = imregtform(I_2,I_1,'translation',optimizer,metric);
Rfixed = imref2d(size(I_1));
I_3 = imwarp(I_2,tform,'OutputView',Rfixed);
figure, imshowpair(I_2, I_1)
figure, imshowpair(I_3, I_1);


T2_post=ute_4echo_fit(UTE_post_te1,UTE_post_te2,UTE_post_te3,UTE_post_te4);
T2_post=imwarp(T2_post,tform,'OutputView',Rfixed);

IMCT_post=zeros(size(UTE_post_te1));
IMCT_post(T2_post<0.023)=1;




slice=25;

load('GL_mask') 
load('GM_mask') 
load('SOL_mask')

GL_post=squeeze(GL(:,:,slice));
GM_post=squeeze(GM(:,:,slice));
SOL_post=squeeze(SOL(:,:,slice));

clear GM GL SOL


GL_post=circshift(GL_post,2,2);
GM_post=circshift(GM_post,2,2);
SOL_post=circshift(SOL_post,2,2);

GL_post=circshift(GL_post,2,1);
GM_post=circshift(GM_post,2,1);
SOL_post=circshift(SOL_post,2,1);



se = strel('disk',5);

GL_post = imerode(GL_post,se);
GM_post = imerode(GM_post,se);
SOL_post = imerode(SOL_post,se);
    
    
B_SOL_post   =   uint8(bwperim(GL_post,8));
B_GM_post    =   uint8(bwperim(GM_post,8));
B_GL_post    =   uint8(bwperim(SOL_post,8));

I_post=mat2gray(WATER_post);


IMCT_post=imresize(IMCT_post,2).*(GL_post+GM_post+SOL_post);
IMCT_post(IMCT_post<.75)=0;
IMCT_post(IMCT_post>=.75)=1;
IMAT_post=IMAT_post.*(GL_post+GM_post+SOL_post);



X=IMCT_post+IMAT_post;

IMAT_post(X==2)=0;
IMCT_post(X==2)=0;
X(X<2)=0;


I_post=imoverlay(I_post,IMCT_post,[0,1,0]);
I_post=imoverlay(I_post,IMAT_post,[1,0,0]);
I_post=imoverlay(I_post,X,[1,1,0]);


I_post=imoverlay(I_post,B_SOL_post,[1,1,1]);
I_post=imoverlay(I_post,B_GM_post,[1,1,1]);
I_post=imoverlay(I_post,B_GL_post ,[1,1,1]);

imshow(I_post)

