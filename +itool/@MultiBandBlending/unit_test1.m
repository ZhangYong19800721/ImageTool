function exit = unit_test1()
%UNIT_TEST 单元测试函数
%   此处显示详细说明
    image1 = imread('E:\WorkSpace\itool\+itool\@MultiBandBlending\unit_test\group2\apple.jpg');  
    image1 = imresize(image1,[512 512]); image1 = double(image1);
    image2 = imread('E:\WorkSpace\itool\+itool\@MultiBandBlending\unit_test\group2\orange.jpg'); 
    image2 = imresize(image2,[512 512]); image2 = double(image2);
    
    Y = itool.MultiBandBlending.Blend(image1(:,:,1), image2(:,:,1), 6, 256);
    U = itool.MultiBandBlending.Blend(image1(:,:,2), image2(:,:,2), 6, 256);
    V = itool.MultiBandBlending.Blend(image1(:,:,3), image2(:,:,3), 6, 256);
    
    canvas = cat(3,Y,U,V);
    imshow(uint8(canvas));
    exit = true;
end

