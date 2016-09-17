function obj = wave_correct(obj)
%WAVE_CORRECT 波浪修正
%   此处显示详细说明
    unit_y = [0 1 0]'; % 水平方向的单位向量
    num = length(obj.cameras);
    A = zeros(3,3);
    for n = 1:num
        Y = obj.cameras(n).K * obj.cameras(n).R * unit_y;
        A = A + Y*Y';
    end
    
    [~, ~, V] = svd(A);
    h = V(:,end);
    t3 = atan(h(2)/h(1));
    t2 = atan(sqrt(h(1).^2 + h(2).^2)/h(3));
    
    R1 = expm([0 -t3 0; t3 0 0; 0 0 0]);
    R2 = expm([0 0 t2; 0 0 0; -t2 0 0]);
    UP = R1 * R2;
    
    for n = 1:num
        obj.cameras(n).R = UP * obj.cameras(n).R;
    end
end

