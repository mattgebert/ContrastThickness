clear; close all; clc;
left = 'left.jpg';right = 'right.jpg';
imgL = imread(left);imgR = imread(right);
imsizeL = size(imgL);imsizeR = size(imgR);
xl = [
    338 197 1
    468 290 1
    253 170 1
    263 256 1
    242 136 1
    ];
coordsL = xl(:,1:2)
% Markers on Left
imgL = repmat(imgL,[1,1,3]);
imgLx = insertMarker(imgL, coordsL,'x','color',[255,0,0]);
% Plot Left
subplot(1,2,1)
imshow(imgLx);

% Apply Homography to Points:
H = [1.6010 -0.0300 -317.9341
    0.1279 1.5325 -22.5847
    0.0007 0 1.2865];
xr = (H * xl')';
% Scale points with z component
coordsR = xr(:,1:2)./xr(:,3)
% Markers on Right
imgR = repmat(imgR,[1,1,3]);
imgRx = insertMarker(imgR, coordsR,'x','color',[255,0,0]);
%Plot Right
subplot(1,2,2);
imshow(imgRx)

% % To access coordinates instead:
% ind = sub2ind(imsize, coords(:,2), coords(:,1));