clear all;
close all;

images(1).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\IMG_0025.JPG');
% images(2).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\IMG_0026.JPG');
%images(3).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\IMG_0027.JPG');
% images(4).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\IMG_0028.JPG');
% images(5).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\IMG_0029.JPG');

istitcher = itool.ImageStitcher();
istitcher = istitcher.estimate(images);
result = istitcher.stitch(images);