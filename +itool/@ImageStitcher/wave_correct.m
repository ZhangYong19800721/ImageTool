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
end

