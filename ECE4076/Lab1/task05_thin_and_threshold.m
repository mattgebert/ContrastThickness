clc;clear; close all;
% img_name = 'test00.png';
img_name = 'test01.png';
% img_name = 'test02.png';
% img_name = 'test03.png';
% img_name = 'test04.jpg';
% img_name = 'amy_portrait.jpg';
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

figure('pos',[500 500 1300 600])
subplot(1,4,1);
imshow(myimg);
title({'Original';['Size: ', num2str(size(myimg))]})

% 2. Blur the image using a 5x5 Gaussian filter 
myblur = gaussianBlur(myimg);
subplot(1,4,2);
imshow(myblur);
title({'Blurred';['Size: ', num2str(size(myblur))]})

%3. Calculate the gradient of the blurred image in the x and y directions using a 3x3 Sobel filter 
[mygradsx, mygradsy] = sobelFilter(myblur);

%Convert to double form:
mygradsx = double(mygradsx);
mygradsy = double(mygradsy);

% Abs gradient?
magsq = (mygradsx-256/2).^2 + (mygradsy-256/2).^2;
mygradsabs = uint8(floor(sqrt(magsq)));
subplot(1,4,3);
low = min(min(mygradsabs));
high = max(max(mygradsabs));
imshow(mygradsabs, [low high]);
title({'Gradient ABS';['Size: ', num2str(size(mygradsabs))]})

%Thinned Edges?
thinned = edgeThin(mygradsx, mygradsy);
thresh=40;
thresholded = threshold(thinned, thresh);
subplot(1,4,4);
imshow(thresholded);
title({'Thinned Edges ABS';['Thresholded at ', num2str(thresh), '/255'];['Size: ', num2str(size(thresholded))]})