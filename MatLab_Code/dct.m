clc;
clear all;
close all;
a=imread ('Image1.jpg');
[m n]=size (a);
count=0;
%Divide image into sub blocks
for s=1:32
    for q=1:32
        count=count+1;
        p(1:8,1:8,count)=a((s-1)*8+1:s*8,(q-1)*8+1:q*8);
    end
end
%Apply dct to every block
for k=1:1024
    f(:,:,k)=dct(p(:,:,k));
end
%Apply idct to each block
for k=1:1024
    v(:,:,k)=round(idct(f(:,:,k)));
end
%Recovery of image
count=0;
for h=1:32
    for q=1:32
        count=count+1;
        Ic((h-1)*8+1:h*8,(q-1)*8+1:q*8)=v(1:8,1:8,count);
    end
end
[m1,n1]=size(Ic);
%Display of subblocks of image
for q=1:1024
    display(p(:,:,q));
end
%Compression ratio
a=double(a);
sumI=0;
sumIc=0;
for i=1:m
    for j=1:n
        sumI=sumI+a(i,j);
        sumIc=sumIc+Ic(i,j);
    end
end
cr=(sumIc)/(sumI);
display('compression ratio is:');
disp(cr);
%relative data redundancy
red=(1)-(1/cr);
display('relative redundancy is:');
disp(red);
%PSNR Caliculation
squaredErrorImage = (double(a)-double(Ic)).^2;
mse = (sum(sum(squaredErrorImage)))/ (m*n);
PSNR = 10 * log10((255^2) / mse);

message = sprintf('The mean square error is %.2f.\nThe PSNR = %.2f', mse, PSNR);
(message);
figure(2)
subplot(2,1,1);
imshow(uint8(a));
title('original image');
subplot(2,1,2);
imshow(uint8(Ic));
title('Compressed image without quantiser');