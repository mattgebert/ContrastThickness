clear; close all; clc;

imname = 'left.jpg';
img = imread(imname);
imsize = size(img);

coords = [
    338 197
    468 290
    253 170
    263 256
    242 136
    ];
% Swap coords back, so coords = [y x]
% coords = coords(:,2:-1:1);

crossedImg = repmat(img,[1,1,3]);
crossedImg = insertMarker(crossedImg, coords,'x','color',[255,0,0]);

% % To access coordinates instead:
% ind = sub2ind(imsize, coords(:,2), coords(:,1));
imshow(crossedImg);