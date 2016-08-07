function [idx,x,y,t] = find_front(obj) 
%FIND_FRONT Ѱ�Ҵ��������ı߽�
%
    front_finder = ones(3,3,3); front_finder(14) = -26; % ����Ѱ�ұ߽�ľ������
    covn_mat = convn(obj.mask3d,front_finder,'same'); % ����ҵ��߽��
    idx = find(covn_mat>0); % ����ҵ��߽��
    [x,y,t] = ind2sub(size(obj.mask3d),idx); % ����߽���x��y��t����
end

