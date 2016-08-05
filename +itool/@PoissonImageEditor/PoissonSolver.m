function result_image = PoissonSolver(image, mask, adjacent)
%POISSONSOLVER 泊松方程解算器
%   image: 需要被篡改的图片，image中需要被篡改区域的数值是引导矢量场的散度（即div（v），其中v是引导矢量场）
%   mask：二值图像，其大小与image相同，1-表示需要被篡改的区域，0-表示已知区域
%   adjacent：邻接矩阵，表示mask中需要被篡改区域的元素的4-connect相邻关系
%   boundry：需要被篡改区域的边界
    result_image = image;
    [row_num,~] = size(adjacent);
    A = -4 * eye(row_num) + adjacent;
    F = double(image) .* double(~mask);
    F = conv2(F,[0 1 0; 1 0 1; 0 1 0],'same');
    b = -1 * image(logical(mask)) - F(logical(mask)); 
    x = cgs(A,b,1e-8,1e3); % 使用共轭梯度法解线性方程组Ax=b
    result_image(logical(mask)) = uint8(x);
end

