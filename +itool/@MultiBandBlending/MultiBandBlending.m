classdef MultiBandBlending
    %MULTIBANDBLENDING �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
    end
    
    methods(Static)
        C = Blend(A, B, level, boundary)
        G = GaussianPyramid(input, level)
        [L, G] = LaplacianPyramid( input, level )
        out = reduce(input)
        out = expand(input)
        out = reconstruct(input_pyramid)
    end
    
end

