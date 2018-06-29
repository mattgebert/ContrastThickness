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

%Convert to double form:
mygradsx = double(mygradsx);
mygradsy = double(mygradsy);

% Abs gradient?
magsq = (mygradsx-256/2).^2 + (mygradsy-256/2).^2;
mygradsabs = uint8(floor(sqrt(magsq)));

figure('pos',[500 500 900 300])
subplot(1,3,1);
imshow(myimg);
title(['Original - Size: ', num2str(size(myimg))])

subplot(1,3,2);
imshow(myblur);
title(['Blurred - Size: ', num2str(size(myblur))])

subplot(1,3,3);
low = min(min(mygradsabs));
high = max(max(mygradsabs));
imshow(mygradsabs, [low high]);
title(['Gradient ABS - Size: ', num2str(size(mygradsabs))])