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
%Choose first random mean:
pix = [ceil(rand()*mysize(1)) ceil(rand()*mysize(2))];
means(1,:) = myimg(pix(1), pix(2), :);
coords(1,:) = pix(:);

distances = ones(k-1, mysize(1),mysize(2))*3*255; %Initialize to a value greater than any possible colour distance
distancesMin = zeros(mysize(1),mysize(2));
for q = 2:k
    %Find distance to most recent mean colour value.
    [closestTo,dist] = findClosest(myimg, means(q-1,:));
    distances(q-1,:,:) = dist(:,:);
    [distancesMin, distancesInd] = min(distances,[],1); % Update distances vector & indexes
    %Calculate Probability:
    prob = (distancesMin.^2) ./ (sum(sum(distancesMin.^2)));
    %Randomly draw a new colour mean value based on computed probabilitiy
    %distribution
    cumulativeDist = cumsum(reshape(prob(:,:), [1, mysize(1) * mysize(2)]));
    randNum = rand(1);
    randIndex = find(cumulativeDist > randNum, 1 );
    x = 1+floor((randIndex -1) / mysize(1));
    y = 1+mod((randIndex-1), mysize(1));
    means(q,:) = myimg(y,x,:);
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
end

% Show Calculated Figure with Colour Bar
figure
imshowclr(newimg, means);
title(['Clustered: ', num2str(k), ' Iteration: ', num2str(q)])