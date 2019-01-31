fid = fopen('/Users/vadmalis/Desktop/DATA/Junior/YT/YT_EIGENVECTORS/YT_EigenVec_G25.dat');
I = fread(fid,'float32','ieee-be');
fclose(fid);

size(I)

I = reshape(I,256,256)


for p=1:256
    for q=1:256

B(p,q)=I(p,q);


    end 
end

imtool(B)