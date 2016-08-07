function [YGx,YGy,UGx,UGy,VGx,VGy,sub_x,sub_y,sub_t] = find_best_exampler(obj,c_Y_Gx,c_Y_Gy,c_U_Gx,c_U_Gy,c_V_Gx,c_V_Gy,c_mask3d)
%FIND_BEST_EXAMPLER 找到最优的匹配块，在sx和sy给定的数据中找到与gx，gy相似性最好的数据块。
%   

    Y_Gx = c_Y_Gx; Y_Gx(c_mask3d) = 0; 
    Y_Gy = c_Y_Gy; Y_Gy(c_mask3d) = 0;
    U_Gx = c_U_Gx; U_Gx(c_mask3d) = 0;
    U_Gy = c_U_Gy; U_Gy(c_mask3d) = 0;
    V_Gx = c_V_Gx; V_Gx(c_mask3d) = 0;
    V_Gy = c_V_Gy; V_Gy(c_mask3d) = 0; 
    
    [m,n,k] = size(c_mask3d);
    front_finder = ones(m,n,k); 
    front_finder(ceil(m/2),ceil(n/2),ceil(k/2)) = 1-(m*n*k);
    mask2 = (convn(obj.mask3d,front_finder,'same') > 0);

    cov_mat1 = convn(obj.movie_Y_Gx,Y_Gx,'same');
    cov_mat2 = convn(obj.movie_Y_Gy,Y_Gy,'same');
    cov_mat3 = convn(obj.movie_U_Gx,U_Gx,'same');
    cov_mat4 = convn(obj.movie_U_Gy,U_Gy,'same');
    cov_mat5 = convn(obj.movie_V_Gx,V_Gx,'same');
    cov_mat6 = convn(obj.movie_V_Gy,V_Gy,'same'); 
    
    cov_mat = cov_mat1 + cov_mat2 + cov_mat3 + cov_mat4 + cov_mat5 + cov_mat6;
    cov_mat(obj.mask3d) = -inf; cov_mat(mask2) = -inf;
    cov_mat_1d = reshape(cov_mat,[],1);
    [~,best_idx] = max(cov_mat_1d);
    [sub_x,sub_y,sub_t] = ind2sub(size(cov_mat),best_idx);
    
    YGx = obj.get_cube(obj.movie_Y_Gx,sub_x,sub_y,sub_t);
    YGy = obj.get_cube(obj.movie_Y_Gy,sub_x,sub_y,sub_t);
    UGx = obj.get_cube(obj.movie_U_Gx,sub_x,sub_y,sub_t);
    UGy = obj.get_cube(obj.movie_U_Gy,sub_x,sub_y,sub_t);
    VGx = obj.get_cube(obj.movie_V_Gx,sub_x,sub_y,sub_t);
    VGy = obj.get_cube(obj.movie_V_Gy,sub_x,sub_y,sub_t); 
end

