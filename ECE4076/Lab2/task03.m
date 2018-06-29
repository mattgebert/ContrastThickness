clc;clear;close all;
img_name = 'mandrill.jpg';
% img_name = 'amy_portrait.jpg';
% img_name = 'isaac1.jpg';
myimgint8 = imread(img_name);
myimg = double(myimgint8);
mysize = size(myimg);

k=4;
%Setup Random Means
means = zeros(k,3);
coords = zeros(k,2);
for i = 1:k
    pix = [ceil(rand()*mysize(1)) ceil(rand()*mysize(2))];
    coords(i,:) = pix(:);
    means(i,:) = myimg(pix(1), pix(2), :);
end

% figure
% imshow(myimgint8);
% title(['Original - Size: ', num2str(mysize)])

%Begin Looped Process
meansDist = ones(1,k)*10;
% for q = 1:5
q=1;
while sum((meansDist > 1.5))
    %For all pixels find which is closest:
    [closestTo,dist] = findClosest(myimg, means);
    %Set means to the new means, and get the new image.
   [newimg,newmeans]=getAveImg(myimg, closestTo, k);
   
    % Scatter Plot of Approaching the means:
    %Coordinates:
    y=1:10:mysize(1);
    x=1:10:mysize(2);
    fulllength = length(x)*length(y);
    distSamp = dist(y,x);
    indexSamp = closestTo(y,x);
    I=reshape(indexSamp, [1, fulllength]);
    %Prepare X and Y into vector format
    X=reshape(myimg(y,x,1), [1, fulllength]);
    Y=reshape(myimg(y,x,2), [1, fulllength]);
    Z=reshape(myimg(y,x,3), [1, fulllength]);
    % Size and colour matrixes:
    C=[newmeans(I,1) newmeans(I,2) newmeans(I,3)]/255.0;
    S=4*ones(1,length(C));
    % Plot
    figure
    scatter3(X,Y,Z,S,C);
    imColourBar(newmeans);
    title(['Iteration: ', num2str(q), ' Max Distance: ', num2str(max(max(closestTo)))])
%     pause
%     close all;

    meansDist = sqrt(sum((newmeans - means).^2,2))
    means = newmeans;
    q=q+1;
    pause(0.01)
end

% Show Calculated Figure with Colour Bar
figure
imshowclr(newimg, means);
title(['Clustered: ', num2str(k), ' Iteration: ', num2str(q)])