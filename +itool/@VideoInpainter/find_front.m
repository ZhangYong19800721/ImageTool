function [idx,x,y,t] = find_front(obj) 
%FIND_FRONT 寻找待填充区域的边界
%
    front_finder = ones(3,3,3); front_finder(14) = -26; % 用来寻找边界的卷积矩阵
    covn_mat = convn(obj.mask,front_finder,'same'); % 卷积找到边界点
    idx = find(covn_mat>0); % 卷积找到边界点
    [x, y]  = find(covn_mat>0); % 卷积找到边界点
    t = ceil(y / obj.col_num);
    y = y - (t-1) * obj.col_num;
end

