function [cube,valid,r_x,r_y,r_t] = get_cube(obj,matrix,x,y,t)
%GET_CUBE 取立方体数据块
%       
    ran_x = x + (-obj.delta_x : obj.delta_x);  
    % range_x = ran_x(ran_x>=1 & ran_x<=obj.row_num); 
    r_x = ran_x; r_x(ran_x<1) = 1;  r_x(ran_x>obj.row_num) = obj.row_num;
    
    ran_y = y + (-obj.delta_y : obj.delta_y);  
    % range_y = ran_y(ran_y>=1 & ran_y<=obj.col_num); 
    r_y = ran_y; r_y(ran_y<1) = 1;  r_y(ran_y>obj.col_num) = obj.col_num;
    
    ran_t = t + (-obj.delta_t : obj.delta_t);  
    % range_t = ran_t(ran_t>=1 & ran_t<=obj.frame_num); 
    r_t = ran_t; r_t(ran_t<1) = 1;  r_t(ran_t>obj.frame_num) = obj.frame_num;
        
    cube_ran_x = 1:(2*obj.delta_x+1); 
    cube_ran_x = cube_ran_x .* (ran_x>=1 & ran_x<=obj.row_num); 
    cube_ran_x = cube_ran_x(cube_ran_x>0);
    
    cube_ran_y = 1:(2*obj.delta_y+1);
    cube_ran_y = cube_ran_y .* (ran_y>=1 & ran_y<=obj.col_num); 
    cube_ran_y = cube_ran_y(cube_ran_y>0);
    
    cube_ran_t = 1:(2*obj.delta_t+1);
    cube_ran_t = cube_ran_t .* (ran_t>=1 & ran_t<=obj.frame_num); 
    cube_ran_t = cube_ran_t(cube_ran_t>0);
    
    valid = false(2*obj.delta_x+1,2*obj.delta_y+1,2*obj.delta_t+1);
    valid(cube_ran_x,cube_ran_y,cube_ran_t) = 1;
    
    cube = matrix(r_x,r_y,r_t);
end

