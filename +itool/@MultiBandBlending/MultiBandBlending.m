classdef MultiBandBlending
    %MULTIBANDBLENDING 此处显示有关此类的摘要
    %   此处显示详细说明
    
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

