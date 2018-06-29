clc;clear; close all;
% img_name = 'test00.png';
% img_name = 'test01.png';
% img_name = 'test02.png';
% img_name = 'test03.png';
% img_name = 'test04.jpg';
img_name = 'amy_portrait.jpg';
% img_name = 'test05.jpg';
myimg = imread(img_name);
mysize = size(myimg);
if (length(mysize) == 3)
    myimg = myimg(:,:,1);
end
% Downsizeing
if(mysize(1) > 200)
    myimg = imresize(myimg, 200/mysize(1));
    mysize = size(myimg);
elseif (mysize(2) > 200)
    myimg = imresize(myimg, 200/mysize(2));
end
% 2. Blur the image using a 5x5 Gaussian filter 
myblur = gaussianBlur(myimg);
%3. Calculate the gradient of the blurred image in the x and y directions using a 3x3 Sobel filter 

[mygradsx, mygradsy] = sobelFilter(myblur);

%4. Check the x and y gradient values to make sure they are correct
% Heh... presuming... checked the visual....

%Plot the Results
figure('pos',[500 500 600 600])
subplot(2,2,1);
imshow(myimg);
title(['Original - Size: ', num2str(size(myimg))])

subplot(2,2,2);
imshow(myblur);
title(['Blurred - Size: ', num2str(size(myblur))])

subplot(2,2,3);
% imshow(mygradsx);
low = min(min(mygradsx));
high = max(max(mygradsx));
imshow(mygradsx, [low high]);
title(['Gradients X - Size: ', num2str(size(mygradsx))])

subplot(2,2,4);
low = min(min(mygradsy));
high = max(max(mygradsy));
imshow(mygradsy, [low high]);
title(['Gradients Y - Size: ', num2str(size(mygradsy))])