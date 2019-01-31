fid = fopen('/Users/vadmalis/Desktop/MASK/Sub1/SOL.img');

m = fread(fid,'uint8','ieee-be'); fclose(fid);
m = reshape(m,256,256,44); 



fid = fopen('/Users/vadmalis/Desktop/EV#1.dat');
I = fread(fid,'float32');
fclose(fid);

I = reshape(I,3,256,256,44);
    

 
for k=1:44
        for i=1:256
            for j=1:256
    
    
                if m(i,j,45-k)==0
                I(:,i,j,k)=0;
                else
                I(:,i,j,k)=I(:,i,j,k);
                
                end
            end
        end
end

fname1=sprintf('/Users/vadmalis/Desktop/EV#1/SOL.dat');

fid1 = fopen(fname1,'w+','l');

fwrite(fid1,I,'float32');
fclose(fid1);
