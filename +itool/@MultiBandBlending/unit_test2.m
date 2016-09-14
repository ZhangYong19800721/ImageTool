function exit = unit_test2()
%UNIT_TEST2 此处显示有关此函数的摘要
%   此处显示详细说明
    close all;
    
    image1 = double(imread('E:\WorkSpace\itool\+itool\@MultiBandBlending\unit_test\image1.jpg')); 
    figure; imshow(uint8(image1));
    image2 = double(imread('E:\WorkSpace\itool\+itool\@MultiBandBlending\unit_test\image2.jpg')); 
    figure; imshow(uint8(image2));
    load('E:\WorkSpace\itool\+itool\@MultiBandBlending\unit_test\mask.mat');
    
    R = itool.MultiBandBlending.test_blend(image1(:,:,1),image2(:,:,1), mask1_2d, mask2_2d, 6);
    G = itool.MultiBandBlending.test_blend(image1(:,:,2),image2(:,:,2), mask1_2d, mask2_2d, 6);
    B = itool.MultiBandBlending.test_blend(image1(:,:,3),image2(:,:,3), mask1_2d, mask2_2d, 6);
    image3 = uint8(cat(3,R,G,B));
    
    imwrite(image3,'blend_result.jpg');
    figure; imshow(image3);
    exit = true;
end

