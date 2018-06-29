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
% subplot(3,1,1)
axis([0, 640, 0, 480])
% plot(x(1,:),  imsize(1)-y(1,:),  '.b')
futuredots = ['o';'x';'+'];
clrs = [[1 0 0] %Red
    [1 0.5 0] %Orange
    [1 1 0]]; %Yellow
scatsizes = [8, 15, 15];

% Task 7: Reproject triangulated 3D points from image 14 onto image 3.
% Find 3D Points of 14
[xy14, uv14, scaledBaseline14] = get3D(img1, img4, x([1,4],:), y([1,4],:),descript([1,4],:,:), siftsize);
% Find basline of 13:
[~, ~, scaledBaseline13] = get3D(img1, img3, x([1,3],:), y([1,3],:),descript([1,3],:,:), siftsize);

% Project points of 14 onto image 3:
displayImg = img3;
% Calculate ratio of baseline in x direction:
scale = scaledBaseline13/scaledBaseline14;
% Project xy and uv coordinates to a 13 projection:
% Im1 3D points + vector distance to Im4 3D Points scaled by the length to img 3
wz = xy14 + (uv14 - xy14) * scale;
wzCoords = wz(1:2,:) ./ wz(3,:);

projectImg = insertMarker(displayImg, wzCoords(:,:)' ,'o','color',[255,255,255]);
imshow(projectImg)