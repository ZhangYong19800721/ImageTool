clear all;
close all;

im1 = imread('E:\WorkSpace\itool\+itool\@MultiBandBlending\unit_test\eye.bmp');  im1 = double(rgb2gray(im1));
im2 = imread('E:\WorkSpace\itool\+itool\@MultiBandBlending\unit_test\hand.bmp'); im2 = double(rgb2gray(im2));
im3 = imread('E:\WorkSpace\itool\+itool\@MultiBandBlending\unit_test\mask.bmp'); im3 = double(im3);
%C = BlendArbitrary(im1, im2, im3/255, 4);
C = itool.MultiBandBlending.Blend(im1, im2, 4, 130);