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

%Process Coordinates
imA = 1;
for imB = 2:4
    figure
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
    joinAB = [images(:,1+imsize(2)*imA:imsize(2)*(imA+1)), images(:,1+imsize(2)*imB:imsize(2)*(imB+1))];
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
     subplot(2,2,1);
    imshow(linedImage);
%     figure 
    matchedImg = insertMarker(img1, [x(imA,:)', y(imA, :)'] ,'o','color',[255,255,255],'size',1);
    matchedImg = insertMarker(matchedImg, [x(imA,:)', y(imA, :)'] ,'x','color',[255,255,255],'size',1);
    matchedImg = insertMarker(matchedImg, [x(imA, matchedIndexes(1,:))', y(imA, matchedIndexes(1,:))'] ,'o','color',[255,0,0]);
    subplot(2,2,2);
    imshow(matchedImg)

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
   subplot(2,2,3)
    hold on
    axis([0, 640, -480, 0])
    plot(x(1,:),  -y(1,:),  '.b')
    plot(xy(1,:), -xy(2,:), 'or')
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
    
    % Plot Depth
     subplot(2,2,4);
%     figure
    scatter3(xy(1,:),-xy(2,:),depthz(:),'.');
    axis([0, 640, -480, 0]);
    
    % Part 6.2
    % Repeat with Im3 and Im4.
    
    % PART6.3 - Normalize Properly 37cm is 
    % Get Horizontal Distances using matched points.
    % Do this by sampling: We can find points either side of the 

    % Scale Depth: 

end



% We've found the homography. Now we need to calculate the point where
% there is depth. 
% x = 
% THIS IS FROM LECTURE 17
% 1) Select Point, find epipolar line in other image.
% 2) Repeat
% 3) Using multiple epipolar lines, they converge on the epipole (location
% the image was taken from)
% FROM LECTURE 18: Apparently it simplifies down dramaticall for a 2D set
% of points. I've done way too much work haha.
% z = a / (u_1 - u_2), a = a_1 + a_2


% Obtain? We have p1 and q1, the coordinates in each frame.
% to find z, and x, we need epipolar line from camera 2.
% here p = (u1, v1, 1), l = Ep. 
% So we can get u1 and u2. What about a1 and a2


% FROM lecture 17:
% mu * [q1,q2,1] = lambda R [p1, p2, 1] + t
% Do we know R and t? Should do if we know H.
% Because we have the planar case, R = [H(:,1:2), 0] and t = H(:,3)
% R = [baseH(:,1:2), [0,0,0]'];
% t = baseH(:,3);
% calcualte the cross product of these two 
% p = [sXY(1,1) sXY(2,1) 1]';
% tcross = [0 -t(3,1) t(2,1); t(3,1) 0 -t(1,1); -t(2,1), t(1,1), 0];
% E = tcross * R; 
% l = E * p;


% CODE TO COMPUTE THE HOMOGRAPHY!! EXCITING
% Implement RANSAC, because a single set of COORDS isn't reliable.
% THIS IS FROM LECTURE 7.

% baseConsensus = 0;
% baseH = zeros(3,3);
% for i = 1:200
%     % 1) Select 4 Random Matches:
%     selection = ceil(rand([4,1])*matched);
%     sXY = [x(imA, matchedIndexes(1,selection)) 
%            y(imA, matchedIndexes(1,selection))]';
%     sUV = [x(imB, matchedIndexes(2,selection))
%            y(imB, matchedIndexes(2,selection))]';
% 
%     % 2) Build a matrix from u,v,x,y values:
%     M = [-sXY(1,1) -sXY(1,2) -1 0 0 0 sXY(1,1)*sUV(1,1) sXY(1,2)*sUV(1,1) sUV(1,1);
%         0 0 0 -sXY(1,1) -sXY(1,2) -1 sXY(1,1)*sUV(1,2) sXY(1,2)*sUV(1,2) sUV(1,2);
%         -sXY(2,1) -sXY(2,2) -1 0 0 0 sXY(2,1)*sUV(2,1) sXY(2,2)*sUV(2,1) sUV(2,1);
%         0 0 0 -sXY(2,1) -sXY(2,2) -1 sXY(2,1)*sUV(2,2) sXY(2,2)*sUV(2,2) sUV(2,2);
%         -sXY(3,1) -sXY(3,2) -1 0 0 0 sXY(3,1)*sUV(3,1) sXY(3,2)*sUV(3,1) sUV(3,1);
%         0 0 0 -sXY(3,1) -sXY(3,2) -1 sXY(3,1)*sUV(3,2) sXY(3,2)*sUV(3,2) sUV(3,2);
%         -sXY(4,1) -sXY(4,2) -1 0 0 0 sXY(4,1)*sUV(4,1) sXY(4,2)*sUV(4,1) sUV(4,1);
%         0 0 0 -sXY(4,1) -sXY(4,2) -1 sXY(4,1)*sUV(4,2) sXY(4,2)*sUV(4,2) sUV(4,2);
%     ];
% 
%     % 3) Calculate the null of H:
%     nullM = null(M);
%     nullSize = size(nullM);
%     for j = 1:nullSize(2)
%         % 4) Reshape matrix
%         H = reshape(nullM(:,j),[3,3])';
%         % 5) Use to check all values:
%         lamUV= H * xy;
%         depths = lamUV(3,:);
%         UV(1:3,:) = lamUV(1:3,:) ./ depths; %Normalize
%         errors = uv - UV;
%         eMag = sum(abs(errors));
%         consensus = sum((eMag < 0.5));
%         if (consensus > baseConsensus)
%            baseConsensus = consensus;
%            baseH = H;
%            baseDepths = depths;
%         end
%     end
% end
