function obj = wave_correct(obj)
%WAVE_CORRECT 波浪修正
%   此处显示详细说明
    unit_z = [0 0 1000]'; % 水平方向的单位向量
    num = length(obj.cameras);
    A = zeros(3,3);
    for n = 1:num
        Z = obj.cameras(n).R' * diag(1./diag(obj.cameras(n).K)) * unit_z;
        A = A + Z*Z';
    end
    
    [U, S, V] = svd(A);
    h = V(:,end);
    
    t1 = -obj.cameras(1).P(1); % 选择第n幅图像作为正面
    t2 = atan(h(3)/sqrt(h(1).^2 + h(2).^2));
    t3 = atan(h(2)/h(1));
    
    R1 = expm([0 0 0; 0 0 -t1; 0 t1 0]); 
    R2 = expm([0 0 t2; 0 0 0; -t2 0 0]); 
    R3 = expm([0 -t3 0; t3 0 0; 0 0 0]);

    obj.correct = R3 * R2 * R1;
end

