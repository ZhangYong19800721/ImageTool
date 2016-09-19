function [L, G] = LaplacianPyramid( input, level )
    G = itool.MultiBandBlending.GaussianPyramid(input,level);
    for i = 1:level-1
        A = G{i}; B = itool.MultiBandBlending.expand(G{i+1});[row,col] = size(A);
        L{i} = A - B(1:row,1:col); % ����������˹������
    end
    L{level} = G{level}; % ���ֱ�Ӹ���
end