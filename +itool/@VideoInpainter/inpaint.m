function mov = inpaint(obj,movie,mask)
%INPAINT 对视频进行修复
%   movie: 包含若干帧的电影帧数据
%   mask: 蒙板,是一个二值图像，需要修补的区域标记为1，其它区域标记为0。

    obj = obj.initialize(movie,mask); % 初始化
    [obj.front_idx, obj.front_x, obj.front_y, obj.front_t] = obj.find_front(); % 寻找待填充边界
    C = double(~obj.mask3d); % 初始化自信度
    C = obj.compute_confidence(C); % 计算填充边界上的自信度
    
    while ~isempty(obj.front_idx) % 填充直到找不到任何边界
        D = obj.update_dataterm(obj.mask3d);
        P = obj.compute_priority(C,D,ones(size(C)),obj.front_idx);
        [~,best_idx] = max(P);
        posx = obj.front_x(best_idx); posy = obj.front_y(best_idx); post = obj.front_t(best_idx);
        [cube_Y_Gx,range_x,range_y,range_t] = obj.get_cube(obj.movie_Y_Gx,posx,posy,post);
        [cube_Y_Gy,~,~,~]                   = obj.get_cube(obj.movie_Y_Gy,posx,posy,post);
        [cube_U_Gx,~,~,~]                   = obj.get_cube(obj.movie_U_Gx,posx,posy,post);
        [cube_U_Gy,~,~,~]                   = obj.get_cube(obj.movie_U_Gy,posx,posy,post);
        [cube_V_Gx,~,~,~]                   = obj.get_cube(obj.movie_V_Gx,posx,posy,post);
        [cube_V_Gy,~,~,~]                   = obj.get_cube(obj.movie_V_Gy,posx,posy,post);
        cube_mask3d                         = obj.get_cube(obj.mask3d,posx,posy,post);

        [bYGx,bYGy,bUGx,bUGy,bVGx,bVGy,~,~,~] = obj.find_best_exampler(cube_Y_Gx,cube_Y_Gy,cube_U_Gx,cube_U_Gy,cube_V_Gx,cube_V_Gy,cube_mask3d);
        
        obj.movie_Y_Gx(range_x,range_y,range_t) = cube_Y_Gx .* double(~cube_mask3d) + bYGx .* double(cube_mask3d); 
        obj.movie_Y_Gy(range_x,range_y,range_t) = cube_Y_Gy .* double(~cube_mask3d) + bYGy .* double(cube_mask3d); 
        obj.movie_U_Gx(range_x,range_y,range_t) = cube_U_Gx .* double(~cube_mask3d) + bUGx .* double(cube_mask3d); 
        obj.movie_U_Gy(range_x,range_y,range_t) = cube_U_Gy .* double(~cube_mask3d) + bUGy .* double(cube_mask3d); 
        obj.movie_V_Gx(range_x,range_y,range_t) = cube_V_Gx .* double(~cube_mask3d) + bVGx .* double(cube_mask3d); 
        obj.movie_V_Gy(range_x,range_y,range_t) = cube_V_Gy .* double(~cube_mask3d) + bVGy .* double(cube_mask3d); 
        
        C = obj.update_confidence(C,range_x,range_y,range_t); % 更新自信度
        obj.mask3d(range_x,range_y,range_t) = 0; % 更新三维mask蒙板
        
        [obj.front_idx, obj.front_x, obj.front_y, obj.front_t] = obj.find_front(); % 重新确定待填充边界
        fill_region = sum(sum(sum(obj.mask3d)))
    end
    
    % 用poisson方程解算每一帧的图像
    mov = movie;
    pie = itool.PoissonImageEditor();
    adjacent = pie.compute_adjacent(mask);
    for frame = 1:obj.frame_num
        Y = double(movie(:,:,1,frame)); U = double(movie(:,:,2,frame)); V = double(movie(:,:,3,frame));
        divY = divergence(obj.movie_Y_Gx(:,:,frame),obj.movie_Y_Gy(:,:,frame));
        divU = divergence(obj.movie_U_Gx(:,:,frame),obj.movie_U_Gy(:,:,frame));
        divV = divergence(obj.movie_V_Gx(:,:,frame),obj.movie_V_Gy(:,:,frame));
        Y(mask) = -1 * divY(mask); U(mask) = -1 * divU(mask); V(mask) = -1 * divV(mask);
        mov(:,:,1,frame) = pie.poisson_solver(Y,mask,adjacent);
        mov(:,:,2,frame) = pie.poisson_solver(U,mask,adjacent);
        mov(:,:,3,frame) = pie.poisson_solver(V,mask,adjacent);
    end
end

