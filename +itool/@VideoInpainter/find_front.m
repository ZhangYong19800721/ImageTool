function [idx,x,y,t] = find_front(obj) 
%FIND_FRONT Ѱ�Ҵ��������ı߽�
%
    front_finder = ones(3,3,3); front_finder(14) = -26; % ����Ѱ�ұ߽�ľ������
    covn_mat = convn(obj.mask,front_finder,'same'); % ����ҵ��߽��
    idx = find(covn_mat>0); % ����ҵ��߽��
    [x, y]  = find(covn_mat>0); % ����ҵ��߽��
    t = ceil(y / obj.col_num);
    y = y - (t-1) * obj.col_num;
end

