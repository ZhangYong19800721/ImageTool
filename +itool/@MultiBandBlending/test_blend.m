function image = test_blend(image1, image2, mask1, mask2, level)
% test_blend : blend two images.
    overlap_mask = mask1 & mask2;
    image_1 = zeros(size(image1)); image_1(overlap_mask) = image1(overlap_mask);
    image_2 = zeros(size(image2)); image_2(overlap_mask) = image2(overlap_mask);        

    [laplacian1, ~] = itool.MultiBandBlending.LaplacianPyramid(double(image_1),level);
    [laplacian2, ~] = itool.MultiBandBlending.LaplacianPyramid(double(image_2),level);
    
    region_mask = overlap_mask; %region_mask(:,1:4270) = 0; region_mask(:,4271:8192) = 1;
    region  = itool.MultiBandBlending.GaussianPyramid(double(region_mask),level);
    laplacian = (1 - region) .* laplacian1 + region .* laplacian2;
    image = itool.MultiBandBlending.reconstruct(laplacian);
    
    mask1_mask2 = mask1; mask1_mask2(mask2) = 0;
    mask2_mask1 = mask2; mask2_mask1(mask1) = 0;
    image(mask1_mask2) = image1(mask1_mask2);
    image(mask2_mask1) = image2(mask2_mask1);
end
