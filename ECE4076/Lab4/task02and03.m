clc;clear;close all;
%Import images:
im1 = 'im1.jpg';    im2 = 'im2.jpg';    im3 = 'im3.jpg';    im4 = 'im4.jpg';
img1 = imread(im1); img2 = imread(im2); img3 = imread(im3); img4 = imread(im4);
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
coords = zeros(2*siftsize,2);
for i = 1:2
    for j = 1:siftsize
        coords(siftsize*(i-1)+j,1) = round(x(i,j)) + (i-1)*imsize(2); %Add translation for second image added on.
        coords(siftsize*(i-1)+j,2) = round(y(i,j));
    end
end

%Join images
join12 = [img1, img2];
crossedImg = insertMarker(join12, coords,'x','color',[255,0,0]);
%Display
imshow(crossedImg);