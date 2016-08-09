function [YGx,YGy,UGx,UGy,VGx,VGy,sub_x,sub_y,sub_t] = find_best_exampler(obj,c_Y_Gx,c_Y_Gy,c_U_Gx,c_U_Gy,c_V_Gx,c_V_Gy,c_mask3d,t)
%FIND_BEST_EXAMPLER 找到最优的匹配块，在sx和sy给定的数据中找到与gx，gy相似性最好的数据块。
%   
    
    [m,n,k] = size(c_mask3d);
    front_finder = ones(m,n,k); 
    front_finder(ceil(m/2),ceil(n/2),ceil(k/2)) = 1-(m*n*k);
    mask2 = (convn(obj.mask3d,front_finder,'same') > 0);
    
    space = ~obj.mask3d; space(mask2) = 0;
    [nx,ny,~] = size(space);
    
    mindis = inf;
    for x = 1:nx
        for y = 1:ny
            if space(x,y,t) == 0
                continue;
            else
                exam_Y_Gx = obj.get_cube(obj.movie_Y_Gx,x,y,t);
                exam_Y_Gy = obj.get_cube(obj.movie_Y_Gy,x,y,t);
                exam_U_Gx = obj.get_cube(obj.movie_U_Gx,x,y,t);
                exam_U_Gy = obj.get_cube(obj.movie_U_Gy,x,y,t);
                exam_V_Gx = obj.get_cube(obj.movie_V_Gx,x,y,t);
                exam_V_Gy = obj.get_cube(obj.movie_V_Gy,x,y,t);
                
                dis_Y_Gx = (c_Y_Gx(~c_mask3d) - exam_Y_Gx(~c_mask3d)).^2;
                dis_Y_Gy = (c_Y_Gy(~c_mask3d) - exam_Y_Gy(~c_mask3d)).^2;
                dis_U_Gx = (c_U_Gx(~c_mask3d) - exam_U_Gx(~c_mask3d)).^2;
                dis_U_Gy = (c_U_Gy(~c_mask3d) - exam_U_Gy(~c_mask3d)).^2;
                dis_V_Gx = (c_V_Gx(~c_mask3d) - exam_V_Gx(~c_mask3d)).^2;
                dis_V_Gy = (c_V_Gy(~c_mask3d) - exam_V_Gy(~c_mask3d)).^2;
                
                dis = sqrt(sum(dis_Y_Gx + dis_Y_Gy + dis_U_Gx + dis_U_Gy + dis_V_Gx + dis_V_Gy));
                
                if dis < mindis
                    mindis = dis;
                    YGx = exam_Y_Gx;
                    YGy = exam_Y_Gy;
                    UGx = exam_U_Gx;
                    UGy = exam_U_Gy;
                    VGx = exam_V_Gx;
                    VGy = exam_V_Gy;
                    sub_x = x;
                    sub_y = y;
                end
            end
        end
    end
    
    sub_t = t;
end

