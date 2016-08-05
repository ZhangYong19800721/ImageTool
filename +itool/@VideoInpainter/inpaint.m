function mov = inpaint(obj,movie,mask)
%INPAINT ����Ƶ�����޸�
%   movie: ��������֡�ĵ�Ӱ֡����
%   mask: �ɰ�,��һ����ֵͼ����Ҫ�޲���������Ϊ1������������Ϊ0��

    obj = obj.initialize(movie,mask); % ��ʼ��
    [obj.front_idx, obj.front_x, obj.front_y, obj.front_t] = obj.find_front(); % Ѱ�Ҵ����߽�
    C = double(~obj.mask); % ��ʼ�����Ŷ�
    C = obj.compute_confidence(C); % �������߽��ϵ����Ŷ�
    
    
    n = 1;
    while ~isempty(obj.front_idx) % ���ֱ���Ҳ����κα߽�
        D = obj.update_dataterm();
        
        [obj.front_idx, obj.front_x, obj.front_y, obj.front_t] = obj.find_front(); % ����ȷ�������߽�
        n = n+1
    end
end

