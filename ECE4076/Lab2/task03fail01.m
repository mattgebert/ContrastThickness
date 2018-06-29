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
for q = 1:6
    %For all pixels find which is closest:
    [closestTo,dist] = findClosest(myimg, means);
    %Set means to the new means, and get the new image.
   [newimg,means]=getAveImg(myimg, closestTo, k);
   
    % Scatter Plot of Approaching the means:
    %Coordinates:
    y=1:8:mysize(1);
    x=1:12:mysize(2);
    [X,Y] = meshgrid(x,y);
    distSamp = dist(y,x);
    indexSamp = closestTo(y,x);
    %Prepare X and Y into vector format
    X = reshape(X, [1,length(x)*length(y)]);
    Y = reshape(Y, [1,length(x)*length(y)]);
    Z = reshape(distSamp, [1, length(x)*length(y)]);
    I = reshape(indexSamp, [1, length(x)*length(y)]);
    % Size and colour matrixes:
    c= means / 255.0;
    C=c(I);
    S=4*ones(1,length(C));
    % Plot
    figure
    scatter3(X,Y,Z,S,C);
    imColourBar(means);
    title(['Iteration: ', num2str(q), ' Max Distance: ', num2str(max(max(closestTo)))])
    pause
    close all;
end


% Show Calculated Figure with Colour Bar
figure
imshowclr(newimg, means);
title(['Clustered: ', num2str(k), ' Iteration: ', num2str(q)])