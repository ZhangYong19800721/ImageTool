function image = test_blend(image1,image2,blend_mask,level)
% test_blend : blend two images.
    [laplacian1, ~] = itool.MultiBandBlending.LaplacianPyramid(double(image1),level); % 计算拉普拉斯金字塔
    [laplacian2, ~] = itool.MultiBandBlending.LaplacianPyramid(double(image2),level); % 计算拉普拉斯金字塔
    region  = itool.MultiBandBlending.GaussianPyramid(double(blend_mask),level); % 融合边界
    for k = 1:level
        laplacian{k} = (1 - region{k}) .* laplacian1{k} + region{k} .* laplacian2{k}; % 融合拉普拉斯金字塔
    end
    image = itool.MultiBandBlending.reconstruct(laplacian); % 复原融合图像
end
