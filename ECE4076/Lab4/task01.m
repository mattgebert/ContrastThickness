clc;clear;close all;
%Import images:
im1 = 'im1.jpg';    im2 = 'im2.jpg';    im3 = 'im3.jpg';    im4 = 'im4.jpg';
img1 = imread(im1); img2 = imread(im2); img3 = imread(im3); img4 = imread(im4);
%Join images
join12 = [img1, img2];
%Display
imshow(join12);