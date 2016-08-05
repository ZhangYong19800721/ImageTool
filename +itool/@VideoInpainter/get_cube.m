function [cube,range_x,range_y,range_t] = get_cube(obj,matrix,x,y,t)
%GET_CUBE 取立方体数据块
%       
    ran_x = x + (-obj.delta_x : obj.delta_x);  ran_x(ran_x<1) = 1;  ran_x(ran_x>obj.row_num) = obj.row_num;
    ran_y = y + (-obj.delta_y : obj.delta_y);  ran_y(ran_y<1) = 1;  ran_y(ran_y>obj.col_num) = obj.col_num;
    ran_t = t + (-obj.delta_t : obj.delta_t);  ran_t(ran_t<1) = 1;  ran_t(ran_t>obj.frame_num) = obj.frame_num;
    
    range_x = ran_x;
    range_y = ran_y;
    range_t = ran_t;
    
    ndim = length(size(matrix));
    if ndim == 3
        cube = matrix(ran_x,ran_y,ran_t);
    elseif ndim == 4
        cube = matrix(ran_x,ran_y,:,ran_t);
    else
        error('Wrong matrix dimension!');
        exit(0);
    end
end

