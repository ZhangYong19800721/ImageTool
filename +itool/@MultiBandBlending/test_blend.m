function image = test_blend(image1,image2,blend_mask,level)
% test_blend : blend two images.
    [laplacian1, ~] = itool.MultiBandBlending.LaplacianPyramid(double(image1),level); % ����������˹������
    [laplacian2, ~] = itool.MultiBandBlending.LaplacianPyramid(double(image2),level); % ����������˹������
    region  = itool.MultiBandBlending.GaussianPyramid(double(blend_mask),level); % �ںϱ߽�
    for k = 1:level
        laplacian{k} = (1 - region{k}) .* laplacian1{k} + region{k} .* laplacian2{k}; % �ں�������˹������
    end
    image = itool.MultiBandBlending.reconstruct(laplacian); % ��ԭ�ں�ͼ��
end
