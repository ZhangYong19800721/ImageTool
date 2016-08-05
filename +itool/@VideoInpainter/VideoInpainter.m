classdef VideoInpainter
    %VIDEOINPAINTER 用于修复视频的类
    %   最常见的用法是去除视频中的台标
    
    properties
        mask; % 蒙板,是一个二值图像，需要修补的区域标记为1，其它区域标记为0。
        movie; % 待修补的视频数据
        movie_gradient_x; % 每一帧的x方向上的梯度图组成的视频
        movie_gradient_y; % 每一帧的y方向上的梯度图组成的视频
        
        delta_x; % 修补单元的高度为2*delta_x+1
        delta_y; % 修补单元的高度为2*delta_y+1
        delta_t; % 修补单元的高度为2*delta_t+1
        frame_num; % 总帧数
        row_num; % 视频帧的行数
        col_num; % 视频帧的列数
        channel_num; % 色彩通道数
        front_idx; % 边界点的总序列
        front_x; % 边界点的x坐标序列
        front_y; % 边界点的y坐标序列
        front_t; % 边界点的t坐标序列
    end
    
    methods
        function obj = VideoInpainter(dx,dy,dt) % VideoInpainter构造函数
            obj.delta_x = dx;
            obj.delta_y = dy;
            obj.delta_t = dt;
        end
    end
    
    methods
        mov = inpaint(obj,movie,mask) % 对视频进行修复
        obj = initialize(obj,movie,mask) % 初始化阶段
        [idx,x,y,t] = find_front(obj) % 寻找待填充区域的边界
        C = compute_confidence(obj,confidence) %计算填充边界上的自信度
        
        confidence = update_confidence(obj,conf)
        cubic = get_patch(obj,matrix,x,y,z)
        d_term = update_dataterm(obj,ix,iy,ngx,ngy,data)
    end
end

