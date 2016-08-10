function H = DLT(obj, match_points1, match_points2)
%EstimateHomography 根据两组匹配点计算两幅图之间的投影变换矩阵，至少需要4对匹配点
%  match_points1: 第1组点，一列是一个点的位置，match_points1中的第i列与match_points2中的第i列是对应点
%  match_points2：第2组点，一列是一个点的位置，match_points1中的第i列与match_points2中的第i列是对应点
%  H: 3x3的投影变换矩阵

    num_points = size(match_points1);
    num_points = num_points(2);
    
    A = zeros(2 * num_points,9);
    % 开始构造A矩阵
    for n = 1:num_points
        % 计算A矩阵的第row行
        row = 2*n - 1;
        A(row,1:3) =  0;
        A(row,4:6) = -1 * match_points1(3,n) * match_points2(:,n)';
        A(row,7:9) =      match_points1(2,n) * match_points2(:,n)';
        
        % 计算A矩阵的第row+1行
        row = row + 1;
        A(row,1:3) =      match_points1(3,n) * match_points2(:,n)';
        A(row,4:6) =  0;
        A(row,7:9) = -1 * match_points1(1,n) * match_points2(:,n)';
    end
    
    if num_points < 4
        error = 'need more match points!'
        exit(0);
    elseif num_points == 4
        h = null(A); %计算矩阵A的零空间，即齐次方程Ax=0的非零解
    elseif num_points > 4
        [~, ~, V] = svd(A);
        h = V(:,end);
    end
    
    [~,n] = size(h);
    if n~=1
        H = eye(3);
    else    
        h = h / norm(h); %将非零解进行归一化使其范数等于1
        H = reshape(h,3,3)';
    end
end





