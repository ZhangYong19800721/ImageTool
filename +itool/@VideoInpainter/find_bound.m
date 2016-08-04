function [x,y,f] = find_bound(obj) 
%FIND_BOUND 寻找待填充区域的边界
%
    m_b = ones(3,3,3); m_b(14) = -26; % 用来寻找边界的卷积矩阵
    [x, y]  = find(convn(obj.mask_area,m_b,'same')>0); % 卷积找到边界点
    f = ceil(y / obj.col_num_area);
    y = y - (f-1) * obj.col_num_area;
end

