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
coordsL = xl(:,1:2);
% Markers on Left
imgL3 = repmat(imgL,[1,1,3]);

% Apply Known Homography to Points: (How do I calculate this??)
H = [1.6010 -0.0300 -317.9341
    0.1279 1.5325 -22.5847
    0.0007 0 1.2865];
xr = (H * xl')';
% Scale points with z component
coordsR = xr(:,1:2)./xr(:,3);
% Markers on Right
imgR3 = repmat(imgR,[1,1,3]);
%Calculate Intensities
intensitiesL = imgL(sub2ind(imsizeL, coordsL(:,2), coordsL(:,1))); % sub2ind works with x, y.
%Bilinearly Interpolate accurate intensities of pixels:
intensitiesR = bilinearInterpolate(imgR, coordsR);

%Create new image
newimg = zeros(imsizeL(1),2*imsizeL(2)); %height, width
%Fill LHS with left image
newimg(:,1:imsizeL(2))=imgL;

%Fill in RHS with transformed coodinates:
newxlindexes = imsizeL(1)*imsizeL(2)+1:imsizeL(1)*imsizeL(2)*2; %generate indexes
[newxl1, newxl2] = ind2sub([imsizeL(1), imsizeL(2)*2], newxlindexes); %generate coordinates
newcoordsL = [newxl2' newxl1' ones(length(newxl1),1)]; %Adds ones for homography
newxr = (H * newcoordsL')'; %Calcualte homography
newCoordsR = newxr(:,1:2)./newxr(:,3); %scale xy with z homography
[newintensitiesR, invalidIndiciesR] = bilinearInterpolate(imgR, newCoordsR); %interpolate vals
newimg(newxlindexes)= newintensitiesR;  %set image values
newimgint8 = uint8(round(newimg)); %convert into uint8 for imshow.
imshow(newimgint8) %show image.
