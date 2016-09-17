function exit = unit_test1()
%UNIT_TEST 单元测试函数
%   此处显示详细说明
    close all;
    rng('default');
    tic
    images(1).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\IMG_0001.JPG');
    images(2).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\IMG_0002.JPG');
    images(3).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\IMG_0003.JPG');
    images(4).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\IMG_0004.JPG');
    images(5).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\IMG_0005.JPG');
    images(6).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\IMG_0006.JPG');
    images(7).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\IMG_0007.JPG');
    images(8).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\IMG_0008.JPG');
    images(9).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\IMG_0009.JPG');
    images(10).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\IMG_0010.JPG');
    images(11).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\IMG_0011.JPG');
    images(12).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\IMG_0012.JPG');
    
    istitcher = itool.ImageStitcher().estimate(images, 2048, 4096);
    options.is_blending = false;
    options.is_show_skeleton = true;
    options.is_gain_compensation = true;
    result = istitcher.stitch(images,options);
    imshow(result)
    save('result_group4.mat');
    imwrite(result,'result.bmp');
    toc
    exit = true;
end

