function [patch, range_x, range_y] = get_patch(obj,mat,x,y)
%GET_PATCH 从mat矩阵中取一个特定的块
%   
    ran_x = x + (-obj.deltax : obj.deltax);  ran_x(ran_x<1) = 1;  ran_x(ran_x>obj.row_num) = obj.row_num;
    ran_y = y + (-obj.deltay : obj.deltay);  ran_y(ran_y<1) = 1;  ran_y(ran_y>obj.col_num) = obj.col_num;
    range_x = ran_x;
    range_y = ran_y;
    patch = mat(ran_x,ran_y,:);
end

