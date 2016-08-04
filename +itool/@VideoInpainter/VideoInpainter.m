classdef VideoInpainter
    %VIDEOINPAINTER 用于修复视频的类
    %   最常见的用法是去除视频中的台标
    
    properties
        mask; % 蒙板,是一个二值图像，需要修补的区域标记为1，其它区域标记为0。
        row_area; % 感兴趣区域的行范围
        col_area; % 感兴趣区域的列范围
        movie_area; % 感兴趣区域的视频
        mask_area; % 感兴趣区域的蒙板
        row_num_area; % 感兴趣区域的行数
        col_num_area; % 感兴趣区域的列数
        % movie_gx; % x方向上的梯度图
        % movie_gy; % y方向上的梯度图
        movie_inpaint; % 经过修补的视频
        gapx;
        gapy;
        gapf;
        frame_num; % 总帧数
        row_num; % 视频帧的行数
        col_num; % 视频帧的列数
        boundary_x; % 边界点的x坐标序列
        boundary_y; % 边界点的y坐标序列
        boundary_f; % 边界点的f坐标序列
    end
    
    methods
        function obj = VideoInpainter(mask)
            % VideoInpainter: 构造函数
            % mask：用于标定修补区域的蒙板
            obj.mask = mask;
            obj.gapx = 4;
            obj.gapy = 4;
            obj.gapf = 2;
        end
    end
    
    methods
        obj = inpaint(obj,movie_data) % 对视频进行修复
        obj = crop(obj,movie_data,row_factor,col_factor) % 对视频进行裁剪 
        [x,y,f] = find_bound(obj) % 寻找待填充区域的边界
        confidence = update_confidence(obj,conf)
        cubic = get_patch(obj,matrix,x,y,z)
        d_term = update_dataterm(obj,ix,iy,ngx,ngy,data)
    end
end

