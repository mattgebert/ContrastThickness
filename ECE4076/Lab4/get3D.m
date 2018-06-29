function [xy, uv, scaledBaseline] = get3D(imgA, imgB, x, y, descript, siftsize)
%     imgsize
imsize = size(imgA);

matched = 0;
matchedIndexes = zeros(2, siftsize);
for keypointA = 1:siftsize
%         1xy = [round(x(1,keypointA)) round(y(1,keypointA))];
    distances = descript(2, :, :) - descript(1, keypointA, :);
    euclidDist = sqrt(sum(distances.^2,3));
    [dist1, closestTo1] = min(euclidDist,[],2);
    %remove first minimum and search for a second
    euclidDist(1,closestTo1) = max(euclidDist);
    [dist2, ~] = min(euclidDist,[],2);
    %Check for valid match:
    if (dist1/dist2 < 0.5) 
       matched = matched + 1;
       matchedIndexes(1, matched) = keypointA;
       matchedIndexes(2, matched) = closestTo1;
    end
end
matchedIndexes = matchedIndexes(:,1:matched);

% Assume baseline and focal lengths of 1. Triangulate keypoints?
% We need to use coordinates to triangulate the *depths* of the keypoints.
% Question is how to do this using translation and a camera model.
% \lambda (u, v, 1) = F * R * (x,y,z,1)
% For a Planar Scene, which is what we have:
% \lambda (u, v, 1) = F * R * (x,y,0,1)
% However, we seem to be inherently interested in depth in this task. 

% generate coordinate lists
xy = [x(1, matchedIndexes(1,:)); y(1, matchedIndexes(1,:)); ones(1,matched)];
uv = [x(2, matchedIndexes(2,:)); y(2, matchedIndexes(2,:)); ones(1,matched)];

% We assume the height is the same. In this case:
focalLength = 1;
baseline = 1;

% PART6.1 - Triangulate Depth of each coordinate by using shift info.
% Get Translational Coordinates
u1 = xy(:,:) - [imsize(1)/2; imsize(2)/2; 0];
u2 = uv(:,:) - [imsize(1)/2; imsize(2)/2; 0];
% Compute Depth:
depthz = baseline./(u1(1,:) - u2(1,:));

% Part 6.2
% Repeat with Im3 and Im4.

% PART6.3 - Normalize Properly 37cm is box width.
% Get Horizontal Distances using matched points.
% Do this by sampling: We can find points either side of the box.
imgAgrey = rgb2gray(imgA);
imgBgrey = rgb2gray(imgB);

%Find x and y gradients:
[imgAx,~] = sobelFilter(imgAgrey);
[imgBx,~] = sobelFilter(imgBgrey);

%Cast to unsigned:
imgAx = abs(double(imgAx) - 128);
imgBx = abs(double(imgBx) - 128);

%Find first and last non-zero gradient:
th = 5; %Threshold
firstAx=0;
lastAx=0;
firstBx=0;
lastBx=0;
countA = 0;
countB = 0;
for row = 1:imsize(1)-2
    fAx = find(imgAx(row,:) > th, 2, 'first');
    fBx = find(imgBx(row,:) > th, 2, 'first');
    gAx = find(imgAx(row,:) > th, 2, 'last');
    gBx = find(imgBx(row,:) > th, 2, 'last');
    if (length(fAx) == 2 && length(gAx) == 2)
        firstAx = firstAx + mean(fAx);
        lastAx = lastAx + mean(gAx);
        countA = countA + 1;
    end
    if (length(fBx) == 2 && length(gBx) == 2)
        firstBx = firstBx + mean(fBx);
        lastBx = lastBx + mean(gBx);
        countB = countB + 1;
    end
end
widthA = (lastAx - firstAx) / countA;
widthB = (lastBx - firstBx) / countB;

% Scale Depth using 1: 
boxWidth = 37.0;
scale = boxWidth / widthA;

% Get average X between 1 and 2 keypoints:
scaledBaseline = mean(uv(1,:) - xy(1,:)) * scale;
disp(scaledBaseline);

% Scale Baselines?
scaleddepthz = depthz * scaledBaseline;

% Plot Depth, with focal length and baseline of 1. 
% Also scale x and y directions:
xy(1,:) = xy(1,:) .* scaleddepthz(:)';
xy(2,:) = xy(2,:).* scaleddepthz(:)';
xy(3,:) = scaleddepthz(:);
uv(1,:) = uv(1,:) .* scaleddepthz(:)';
uv(2,:) = uv(2,:).* scaleddepthz(:)';
uv(3,:) = scaleddepthz(:);
