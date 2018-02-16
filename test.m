clc;clear;close all;
% img = imread('Wafer04_Flake01_100x.jpg');
img = imread('testImg.jpg');
img = im2double(img);
r = img(:,:,1);
g = img(:,:,2);
b = img(:,:,3);

f=figure;
subplot(2,2,1)
imshow(img);
subplot(2,2,2)
imshow(r)
subplot(2,2,3)
imshow(g)
subplot(2,2,4)
imshow(b)

ax = findobj(f,'Type','Axes');
title(ax(4),'Colour')
title(ax(3),'Red')
title(ax(2),'Green')
title(ax(1),'Blue')

figure
histogram(g,256)

figure
gsub = median(g(:));
c = (gsub-g)/gsub;
s = size(g);
[X,Y] = meshgrid(1:s(2),1:s(1));
mesh(X,Y,c);

figure
plot(cumsum(ones(s(1),1)), c(:,530));