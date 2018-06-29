clc;clear;close all;
%Import images:
im1 = 'im1.jpg';    im2 = 'im2.jpg';    im3 = 'im3.jpg';    im4 = 'im4.jpg';
img1 = imread(im1); img2 = imread(im2); img3 = imread(im3); img4 = imread(im4);
images = [img1, img2, img3, img4];

%Import sifts:
sf1 = 'im1.sift';   sf2 = 'im2.sift';    sf3 = 'im3.sift';    sf4 = 'im4.sift';
sft1 = fopen(sf1,'r');
sft2 = fopen(sf2,'r');
sft3 = fopen(sf3,'r');
sft4 = fopen(sf4,'r');
sifts = [sft1, sft2, sft3, sft4];

siftsize = 1000;
imnum = 4;
x = zeros(imnum, siftsize);
y = zeros(imnum, siftsize);
scale = zeros(imnum, siftsize);
orient = zeros(imnum, siftsize);
descript = zeros(imnum, siftsize, 128);

for im = 1:imnum
    sf = sifts(im);
    line = 1;
    while(~feof(sf))
        InputText = textscan(sf,'%s',1,'delimiter','\n');
        data = string(split(InputText{1},' ')); %133 in length.
        if (length(data) ~= 133)
            fprintf("Error at Image %d, Line %d.", im, line);
        else
            x(im, line) = str2double(data(1));
            y(im, line) = str2double(data(2));
            scale(im, line) = str2double(data(3));
            orient(im,line) = str2double(data(4));
            descript(im, line, 1:128) = str2double(data(5:132)); %133 is a newline.
        end
        line = line+1;
    end
end

%Get an image size:
imsize = size(img1);

%Plot all original points:
subplot(3,1,1)
axis([0, 640, 0, 480])
plot(x(1,:),  imsize(1)-y(1,:),  '.b')
futuredots = ['o';'x';'+'];
clrs = [[1 0 0] %Red
    [1 0.5 0] %Orange
    [1 1 0]]; %Yellow
scatsizes = [8, 15, 15];

%Process Coordinates
imA = 1;
for imB = 2:imnum
%     figure
    imChoice = [imA, imB]; %Array for iterating between images
    %Generate coordinate points for sift.
    jointcoords = zeros(2*siftsize,2);
    for i = 1:2
        imSel = imChoice(i); %Selected choice of image.
        for j = 1:siftsize
            jointcoords(siftsize*(i-1)+j,1) = round(x(imSel,j)) + (i-1)*imsize(2); %Add translation for second image added on.
            jointcoords(siftsize*(i-1)+j,2) = round(y(imSel,j));
        end
    end
    % Join images
    imgA = images(:,1+imsize(2)*(imA-1):imsize(2)*(imA),:);
    imgB =  images(:,1+imsize(2)*(imB-1):imsize(2)*(imB),:);
    joinAB = [imgA, imgB];
    % mark crosses
    crossedImg = insertMarker(joinAB, jointcoords,'x','color',[255,0,0]);

    matched = 0;
    matchedIndexes = zeros(2, siftsize);
    for keypointA = 1:siftsize
        imAxy = [round(x(imA,keypointA)) round(y(imA,keypointA))];
        distances = descript(imB, :, :) - descript(imA, keypointA, :);
        euclidDist = sqrt(sum(distances.^2,3));
        [dist1, closestTo1] = min(euclidDist,[],2);
        %remove first minimum and search for a second
        euclidDist(1,closestTo1) = max(euclidDist);
        [dist2, closestTo2] = min(euclidDist,[],2);
        %Check for valid match:
        if (dist1/dist2 < 0.5) 
           matched = matched + 1;
           matchedIndexes(1, matched) = keypointA;
           matchedIndexes(2, matched) = closestTo1;
        end
    end
    matchedIndexes = matchedIndexes(:,1:matched);

    %Draw lines
    linedImage = crossedImg;
    for i = 1:matched
        line = [x(imA, matchedIndexes(1,i)), y(imA, matchedIndexes(1,i)), x(imB, matchedIndexes(2,i)) + imsize(2), y(imB, matchedIndexes(2,i))];
        linedImage = insertShape(linedImage, 'Line',line,'LineWidth',2,'Color','green');
    end
    %Display
%      subplot(2,2,1);
%     imshow(linedImage);
%     figure 
    matchedImg = insertMarker(img1, [x(imA,:)', y(imA, :)'] ,'o','color',[255,255,255],'size',1);
    matchedImg = insertMarker(matchedImg, [x(imA,:)', y(imA, :)'] ,'x','color',[255,255,255],'size',1);
    matchedImg = insertMarker(matchedImg, [x(imA, matchedIndexes(1,:))', y(imA, matchedIndexes(1,:))'] ,'o','color',[255,0,0]);
%     subplot(2,2,2);
%     imshow(matchedImg)

    % Assume baseline and focal lengths of 1. Triangulate keypoints?
    % We need to use coordinates to triangulate the *depths* of the keypoints.
    % Question is how to do this using translation and a camera model.
    % \lambda (u, v, 1) = F * R * (x,y,z,1)
    % For a Planar Scene, which is what we have:
    % \lambda (u, v, 1) = F * R * (x,y,0,1)
    % However, we seem to be inherently interested in depth in this task. 

    % generate coordinate lists
    xy = [x(imA, matchedIndexes(1,:)); y(imA, matchedIndexes(1,:)); ones(1,matched)];
    uv = [x(imB, matchedIndexes(2,:)); y(imB, matchedIndexes(2,:)); ones(1,matched)];

%     figure %Show a plot of selected points.
    subplot(3,1,1)
    hold on
    plot(xy(1,:), imsize(1)-xy(2,:), futuredots(imB-1,1), 'MarkerEdgeColor', clrs(imB-1,:))
    axis([0, 640, 0, 480])
    hold off
    
    
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
    [imgAx,imgAy] = sobelFilter(imgAgrey);
    [imgBx,imgBy] = sobelFilter(imgBgrey);
    
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
    
    % Scale Depth using ImA: 
    boxWidth = 37.0;
    scale = boxWidth / widthA;
    
    % Get average X between imA and imB keypoints:
    scaledBaseline = mean(uv(1,:) - xy(1,:)) * scale;
    disp(scaledBaseline);
   
    % Scale Baselines?
    scaleddepthz = depthz * scaledBaseline;
    
    % Plot Depth
    subplot(3,1,2);
    % figure
    hold on
    scatter3(xy(1,:),imsize(1)-xy(2,:),depthz(:), ones(matched,1)*scatsizes(imB-1), clrs(imB-1,:),futuredots(imB-1,1));
    axis([0, 640, 0, 480]);
    hold off
    
    % Plot Depth
    subplot(3,1,3);
    % figure
    hold on
    scatter3(xy(1,:),imsize(1)-xy(2,:),scaleddepthz(:), ones(matched,1)*scatsizes(imB-1), clrs(imB-1,:),futuredots(imB-1,1));
    axis([0, 640, 0, 480]);
    hold off
    
end

% Label Plots:
subplot(3,1,1);
legend('Img1','Img2','Img3','Img4');
title('Keypoints matching Image1')
subplot(3,1,2);
title("Computed depths of keypoints (rotate to see) plotted using Img1's Coordinates")
legend('Img1&2','Img1&3','Img1&4');
subplot(3,1,3);
title("Computed scaled depths")
legend('Img1&2','Img1&3','Img1&4');
