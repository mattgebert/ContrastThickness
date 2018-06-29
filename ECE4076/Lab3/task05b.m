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
newxlindicies = imsizeL(1)*imsizeL(2)+1:imsizeL(1)*imsizeL(2)*2; %generate indexes
[newxl1, newxl2] = ind2sub([imsizeL(1), imsizeL(2)*2], newxlindicies); %generate coordinates
newcoordsL = [newxl2' newxl1' ones(length(newxl1),1)]; %Adds ones for homography
newxr = (H * newcoordsL')'; %Calcualte homography
newCoordsR = newxr(:,1:2)./newxr(:,3); %scale xy with z homography
[newIntensitiesR, invalidIndiciesR] = bilinearInterpolate(imgR, newCoordsR); %interpolate vals
newxlindicies = newxlindicies(invalidIndiciesR == 0); % remove invalid indicies from generated set
newIntensitiesR = newIntensitiesR(invalidIndiciesR==0); % remove invalid pixels from generated set
newimg(newxlindicies)= newIntensitiesR;  %set image values
newimgint8 = uint8(round(newimg)); %convert into uint8 for imshow.
imshow(newimgint8)

% 1) Adjust the width of the output image automatically so that less black pixels are visible 
%Check newxr coordinates for pixel most right:
validIndiciesR = (invalidIndiciesR == 0);
validCoords = [newxl1(validIndiciesR)', newxl2(validIndiciesR)'];
mostRightValid = find(max(validCoords(:,2))==validCoords(:,2),1,'last');
truncatedImg = newimg(:,1:validCoords(mostRightValid,2)+3);
truncatedImgUint8 = uint8(round(truncatedImg));
imshow(truncatedImgUint8) %show image.
% 
% % 2) Adjust the brightness (by a scaling factor) of each image so that the seam is less visible 
eW = 2; %Width of comparison
contrast = truncatedImg(:,imsizeL(2)-1:1:imsizeL(2)) ./ truncatedImg(:,imsizeL(2)+2:-1:imsizeL(2)+1);
brightnessRatio = mean(mean(contrast));
tunedImg = truncatedImg;
tunedImg(:, imsizeL(2)+1:end) = tunedImg(:, imsizeL(2)+1:end) * brightnessRatio;
tunedImgUint8 = uint8(round(tunedImg));
imshow(tunedImgUint8)

% % 3) Apply a small amount of Gaussian blur or alpha blending near the seam to make it less visible 
% %Apply on 4xN length along the line.
blurredImg = tunedImg;
bW = 3; %blurwidth - Half total width 
blurredImg(1+2:end-2, imsizeL(2)+1-bW:imsizeL(2)+bW) = gaussianBlur(blurredImg(1:end, imsizeL(2)-1-bW:imsizeL(2)+2+bW));
blurredImgUint8 = uint8(round(blurredImg));
imshow(blurredImgUint8)

% 4) Adjust the horizontal location of the seam (it can be moved further to the left as the right image overlaps into the left by quite a few pixels).


%Setup for task 5.4
negMargin = 450; %0 is natural point
% brightnessRatio = 1;

%Fill in RHS with transformed coodinates:
newxlindicies = imsizeL(1)*(imsizeL(2)-negMargin)+1:imsizeL(1)*imsizeL(2); %generate indexes
[newxl1, newxl2] = ind2sub([imsizeL(1), imsizeL(2)*2], newxlindicies); %generate coordinates
newcoordsL = [newxl2' newxl1' ones(length(newxl1),1)]; %Adds ones for homography
newxr = (H * newcoordsL')'; %Calcualte homography
newCoordsR = newxr(:,1:2)./newxr(:,3); %scale xy with z homography
[newIntensitiesR, invalidIndiciesR] = bilinearInterpolate(imgR, newCoordsR); %interpolate vals
newxlindicies = newxlindicies(invalidIndiciesR == 0); % remove invalid indicies from generated set
newIntensitiesR = newIntensitiesR(invalidIndiciesR==0); % remove invalid pixels from generated set
blurredImg(newxlindicies)= newIntensitiesR * brightnessRatio;  %set image values
newimgint8 = uint8(round(blurredImg)); %convert into uint8 for imshow.
imshow(newimgint8)
