function H = DLT(obj, match_points1, match_points2)
%EstimateHomography ��������ƥ����������ͼ֮���ͶӰ�任����������Ҫ4��ƥ���
%  match_points1: ��1��㣬һ����һ�����λ�ã�match_points1�еĵ�i����match_points2�еĵ�i���Ƕ�Ӧ��
%  match_points2����2��㣬һ����һ�����λ�ã�match_points1�еĵ�i����match_points2�еĵ�i���Ƕ�Ӧ��
%  H: 3x3��ͶӰ�任����

    num_points = size(match_points1);
    num_points = num_points(2);
    
    A = zeros(2 * num_points,9);
    % ��ʼ����A����
    for n = 1:num_points
        % ����A����ĵ�row��
        row = 2*n - 1;
        A(row,1:3) =  0;
        A(row,4:6) = -1 * match_points1(3,n) * match_points2(:,n)';
        A(row,7:9) =      match_points1(2,n) * match_points2(:,n)';
        
        % ����A����ĵ�row+1��
        row = row + 1;
        A(row,1:3) =      match_points1(3,n) * match_points2(:,n)';
        A(row,4:6) =  0;
        A(row,7:9) = -1 * match_points1(1,n) * match_points2(:,n)';
    end
    
    if num_points < 4
        error = 'need more match points!'
        exit(0);
    elseif num_points == 4
        h = null(A); %�������A����ռ䣬����η���Ax=0�ķ����
    elseif num_points > 4
        [~, ~, V] = svd(A);
        h = V(:,end);
    end
    
    [~,n] = size(h);
    if n~=1
        H = eye(3);
    else    
        h = h / norm(h); %���������й�һ��ʹ�䷶������1
        H = reshape(h,3,3)';
    end
end





