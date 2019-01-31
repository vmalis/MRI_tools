fidr1 = sprintf('/Users/vadmalis/Desktop/DATA/Seniors/AH/AH_WS_SEG_SOL/O20.dat');   
fid1 = fopen(fidr1);
f = fread(fid1,'uint16','ieee-be');
f = reshape(f,256,256);


w=[-1-1-1;-18-1;-1-1-1]; 
lap = abs(imfilter(f, w, 'replicate'));
lap = lap/max(lap(:));
imhist(lap);
Q = percentile2i(h, 0.995);
markerlmage = lap> Q;
fp = f.*markerlmage;
imtool(fp) % Fig. 11 .17(d).
hp = imhist(fp); 
hp(1) = 0;
bar(hp, 0) % Fig. 11.17(e). 
T = otsuthresh(hp);
g=im2bw(f,T);
imtool(g) % Fig. 11.17(f).