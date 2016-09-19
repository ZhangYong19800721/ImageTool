classdef MultiBandBlending
    %MULTIBANDBLENDING �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
    end
    
    methods(Static)
        G = GaussianPyramid(input, level)
        [L, G] = LaplacianPyramid( input, level )
        output = reduce(input)
        output = expand(input)
        output = reconstruct(input)
        image = Blend(image1, image2, level, boundary) 
        image = test_blend(image1, image2, mask1, mask2, level)
        exit = unit_test1();
        exit = unit_test2();
    end
    %C = Blend(A, B, level, boundary)
    %C = BlendArbitrary(A, B, R, level)
    %out = stretchImage(indexImage)
end

