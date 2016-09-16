function obj = wave_correct(obj)
%WAVE_CORRECT ��������
%   �˴���ʾ��ϸ˵��
    unit_y = [0 1 0]'; % ˮƽ����ĵ�λ����
    num = length(obj.cameras);
    A = zeros(3,3);
    for n = 1:num
        Y = obj.cameras(n).K * obj.cameras(n).R * unit_y;
        A = A + Y*Y';
    end
end

