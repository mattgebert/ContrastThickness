clc;clear;close all;

% opticalpath='/home/matt/Google Drive Mattheuu/Physics/Honours Project/03 Labwork/01 Microscopy/';
opticalpath='C:\Users\mgeb1\Google Drive\Physics\Honours Project\03 Labwork\01 Microscopy\';

% Known Graphene:
% img = imread('GraphenePicture/T2_Wafer08_Flake02_100x.jpg'); img = img(800:1500,2000:2700,:);
% GOOD BIG FLAKE:
img = imread([opticalpath 'Batch04 - Columbia/Wafer01/Wafer01_Flake01_100x.jpg']); %img = img(501:2500,1501:3500,:);
% img = imread([opticalpath 'Batch04 - Columbia/Wafer01/Wafer01_Flake02_100x.jpg']); img = img(:,:,:);
% img = imread([opticalpath 'Batch04 - Columbia/Wafer01/Wafer01_Flake03_100x.jpg']); img = img(50:3000,1001:3000,:);
% img = imread([opticalpath 'Batch04 - Columbia/Wafer01/Wafer01_Flake04_100x.jpg']); img = img(:,:,:);
% img = imread([opticalpath 'Batch04 - Columbia/Wafer06/Wafer06_Flake05_100x.jpg']); img = img(1401:2000,1201:2800,:);

img = im2double(img);
r = img(:,:,1);
g = img(:,:,2);
b = img(:,:,3);

%Fig 1 - RGB Parts
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



% Fig 2 - Plot of contrast vs substrate
figure
gsub = median(g(:));
c = (gsub-g)/gsub;
c = c(end:-1:2,1:end-1);
s = size(g);
sampling = 10;
[X,Y] = meshgrid(1:sampling:s(2)-1,1:sampling:s(1)-1);
c = c(1:sampling:end, 1:sampling:end);
mesh(X,Y,c);
colorbar

% Fig 3 - Histogram of contrast values.
figure
histogram(c,256)

% Fig 4 - 
% figure
% plot(cumsum(ones(s(1),1)), c(:,530));