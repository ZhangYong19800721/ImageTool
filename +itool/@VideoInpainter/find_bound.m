function [x,y,f] = find_bound(obj) 
%FIND_BOUND Ѱ�Ҵ��������ı߽�
%
    m_b = ones(3,3,3); m_b(14) = -26; % ����Ѱ�ұ߽�ľ������
    [x, y]  = find(convn(obj.mask_area,m_b,'same')>0); % ����ҵ��߽��
    f = ceil(y / obj.col_num_area);
    y = y - (f-1) * obj.col_num_area;
end

