clc;clear; close all;
% img_name = 'test00.png';
% img_name = 'test01.png';
% img_name = 'test02.png';
% img_name = 'test03.png';
% img_name = 'test04.jpg';
% img_name = 'amy_portrait.jpg';
img_name = 'test05.jpg';
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

%Call Blur FIlter
myblur = gaussianBlur(myimg);

%Plot it
figure
subplot(1,2,1);
imshow(myimg);
title(['Original - Size: ', num2str(size(myimg))])

subplot(1,2,2);
imshow(myblur);
title(['Blurred - Size: ', num2str(size(myblur))])

