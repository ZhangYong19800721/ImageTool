function [L, G] = LaplacianPyramid( input, level )
    G = itool.MultiBandBlending.GaussianPyramid(input,level);
    for i = 1:level-1
        A = G{i}; B = itool.MultiBandBlending.expand(G{i+1});[row,col] = size(A);
        L{i} = A - B(1:row,1:col); % 计算拉普拉斯金字塔
    end
    L{level} = G{level}; % 最顶层直接复制
end