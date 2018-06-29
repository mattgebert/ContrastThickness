clc;clear; close all;
img_name = 'test00.png';
% img_name = 'test01.png';
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

% Direction Gradient?
mygradsdir = atan2((mygradsy-256/2), (mygradsx-256/2));
mygradsdiry = sin(mygradsdir);
mygradsdirx = cos(mygradsdir);

figure('pos',[500 500 1300 600])
subplot(2,4,1);
imshow(myimg);
title({'Original';['Size: ', num2str(size(myimg))]})

subplot(2,4,2);
imshow(myblur);
title({'Blurred';['Size: ', num2str(size(myblur))]})

subplot(2,4,5);
low = min(min(mygradsabs));
high = max(max(mygradsabs));
imshow(mygradsabs, [low high]);
title({'Gradient ABS';['Size: ', num2str(size(mygradsabs))]})

mygradsabs = double(mygradsabs);
%subplot(2,3,4);
%quiver(mygradsx, mygradsy)
%quiver(mygradsabs.* mygradsdirx, mygradsabs.*mygradsdiry)
%title(['Grad Dir Rnd - Size: ', num2str(size(mygradsdir))])

%Reading the question properly:
%1. Make closest to nearest 45 degree:
dirRnd = floor((mygradsdir*180/pi())/45 + 0.5); % +0.5 for rounding
dirRndRad = dirRnd * pi()/4;
subplot(2,4,6);
dirRndx = sin(dirRndRad);
dirRndy = cos(dirRndRad);
%flips both x and y to plot like other image plots:
quiver(flip(mygradsabs.* dirRndx), flip(mygradsabs.*dirRndy)) 
title({'Grad Dir Rnd';['Size: ', num2str(size(mygradsdir))]})

%Setup colour plot
subplot(2,4,[3,4,7,8])
%Setup image size
sizeDir = size(dirRnd);
colourImg = ones(sizeDir(1),sizeDir(2),3)*128;
dirRnd = dirRnd + (dirRnd < 0)*8; %Convert to absolute value, 0 - 7.

%CHecks that the values are non zero - important for direction of zero.
hasdir = ((abs(mygradsx-128) + abs(mygradsy-128))>0);
hasdiramp = hasdir*64;

%Give colour based on 3 bit number, plus non-zero component!
dr=(dirRnd > 3)*224 + hasdiramp;
dg=(mod(dirRnd,4) >= 2)*224 + hasdiramp;
db=(mod(dirRnd,2) >= 1)*224 + hasdiramp;

%plot it
colourImg(:,:,1) = (dr);
colourImg(:,:,2) = (dg);
colourImg(:,:,3) = (db);
colourImg = uint8(colourImg);
imshow(colourImg);

%Colour Bar Stuff
cmap = [255, 255, 255
    255, 255, 64
    255, 64, 255
    255, 64, 64
    64, 255, 255
    64, 255, 64
    64, 64, 255
    64, 64, 64
]/255.0;
colormap(cmap);
labels = {'NE','N','NW','W','SW','S','SE','E'};
colorbar('Ticks', linspace(0.05,0.95,8),...
         'TickLabels',labels);
     
title({['Colour Map Direction - Size: ', num2str(size(mygradsabs))];'(Direction of Positive Change)'})