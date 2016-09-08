clear all;
close all;
rng('default');
tic
images(1).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\group4\IMG_0001.JPG');
images(2).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\group4\IMG_0002.JPG');
images(3).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\group4\IMG_0003.JPG');
images(4).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\group4\IMG_0004.JPG');
images(5).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\group4\IMG_0005.JPG');
images(6).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\group4\IMG_0006.JPG');
images(7).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\group4\IMG_0007.JPG');
images(8).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\group4\IMG_0008.JPG');
images(9).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\group4\IMG_0009.JPG');
images(10).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\group4\IMG_0010.JPG');
images(11).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\group4\IMG_0011.JPG');
images(12).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\group4\IMG_0012.JPG');


istitcher = itool.ImageStitcher().estimate(images);
result = istitcher.stitch(images,'show_line');
imshow(result)
imwrite(result,'result.bmp');
save('result.mat')
toc