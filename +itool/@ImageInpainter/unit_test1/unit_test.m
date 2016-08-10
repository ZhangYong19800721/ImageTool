clear all;
close all;

iip = itool.ImageInpainter();
bungee0 = imread('bungee0.png');
bungee1 = imread('bungee1.png');

[row_num,col_num,~] = size(bungee1);
mask = zeros(row_num,col_num);

mask(bungee1(:,:,1)==0 & bungee1(:,:,2)==255 & bungee1(:,:,3)==0) = 1;
mask = logical(mask);

ip_image = iip.inpaint(bungee0,mask);