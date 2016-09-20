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
    
    t1 = 0;
    t2 = -atan(h(3)/sqrt(h(1).^2 + h(2).^2)); % TODO 检查什么情况下应该取负号
    t3 = atan(h(2)/h(1));
   
    obj.correct = expm([0 -t3 t2; t3 0 -t1; -t2 t1 0]);
end

