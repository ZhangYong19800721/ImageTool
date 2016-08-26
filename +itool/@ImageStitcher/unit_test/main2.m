clear all;
close all;

image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\IMG_0025.JPG');
image = imresize(image,[800 800]);

f = 1;
theda1 = 10;
theda2 = 10;
theda3 = 30;
theda = [0 -theda3 theda2; theda3 0 -theda1; -theda2 theda1 0];
R = expm(theda*pi/180);

[canvas,mask] = itool.ImageStitcher.homography(f,R,image);
imshow(canvas)
