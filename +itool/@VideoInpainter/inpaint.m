function obj = inpaint(obj,movie_data)
%INPAINT 对视频进行修复
%   movie_data: 包含若干帧的电影帧数据
%   mov: 经过修复后的电影帧数据
    
    obj = obj.crop(movie_data,0.22,0.3);
    obj.movie_inpaint = zeros(obj.row_num,obj.col_num,3,obj.frame_num,'uint8'); % 将修复后的视频帧初始化为全0.

    c_term = zeros(size(obj.mask_area)); % 表示自信度
    d_term = zeros(size(obj.mask_area)); % 表示数据项
    
    [obj.boundary_x,obj.boundary_y,obj.boundary_f] = obj.find_bound(); % 找到待填充区域的边界，bx表示边界的x坐标，by表示边界的y坐标，bf表示帧号
    c_term(obj.mask_area==0) = 1;  % 初始化自信度,mask标记为0的区域自信度初始化为1，mask标记为1的区域自信度初始化为0.

    while ~isempty(obj.boundary_x) % 当边界不为空时，继续填充，边界为空时停止
        c_term = obj.update_confidence(c_term);
        d_term = obj.update_dataterm(d_term);
        p_term = 0 * p_term;
        max_priority = -inf;
        for n = 1:length(obj.boundary_x)
            nx = obj.boundary_x(n); ny = obj.boundary_y(n); nf = obj.boundary_f(n);
            current_priority = c_term(nx,ny,nf) * d_term(nx,ny,nf);
            if current_priority > max_priority
                max_priority = current_priority;
                max_posx = nx;
                max_posy = ny;
                max_posf = nf;
            end
        end
        
        cubic = obj.get_patch(,max_posx,max_posy,max_posf);

        [obj.boundary_x,obj.boundary_y,obj.boundary_f] = obj.find_bound(); % 更新边界
    end
end

