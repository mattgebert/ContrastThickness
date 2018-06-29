clc;clear;close all;
img_name = 'mandrill.jpg';
% img_name = 'amy_portrait.jpg';
% img_name = 'isaac1.jpg';
myimgint8 = imread(img_name);
myimg = double(myimgint8);
mysize = size(myimg);

figure
imshow(myimgint8);
title(['Original - Size: ', num2str(mysize)])

k=8;
%Setup Random Means
means = zeros(k,3);
coords = zeros(k,2);
for i = 1:k
    pix = [ceil(rand()*mysize(1)) ceil(rand()*mysize(2))];
    coords(i,:) = pix(:);
    means(i,:) = myimg(pix(1), pix(2), :);
end

figure
%Begin Looped Process
meansDist = ones(1,k)*10;
% for q = 1:5
q=1;
while sum((meansDist > 1.5))
    title(['Clustered: ', num2str(k), ' Iteration: ', num2str(q)])
    %For all pixels find which is closest:
    [closestTo,dist] = findClosest(myimg, means);
    %Set means to the new means, and get the new image.
   [newimg,newmeans]=getAveImg(myimg, closestTo, k);
    % Show Calculated Figure with Colour Bar
    imshowclr(newimg, newmeans);
    figure
    
    meansDist = sqrt(sum((newmeans - means).^2,2))
    means = newmeans;
    q=q+1;
end

