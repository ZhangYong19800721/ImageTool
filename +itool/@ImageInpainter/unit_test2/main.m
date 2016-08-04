clear all;
close all;

iip = itool.ImageInpainter();
origin_image = imread('movie.jpg');
[row_num,col_num,~] = size(origin_image);
mask = load('mask.mat');

xfactor = 0.22; yfactor = 0.3;
row_area = 1:(xfactor * row_num);
col_area = (col_num - yfactor * col_num + 1):col_num;
origin_image = origin_image(row_area,col_area,:);
mask = mask.image(row_area,col_area);

ip_image = iip.inpaint(origin_image,mask);