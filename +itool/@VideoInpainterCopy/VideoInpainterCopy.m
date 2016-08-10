classdef VideoInpainterCopy
    %VIDEOINPAINTER 用于修复视频的类
    %   最常见的用法是去除视频中的台标
    
    properties
        mask3d; % 蒙板,是一个二值图像，需要修补的区域标记为1，其它区域标记为0。
        movie;  % 需要被修复的数据
        movie_DIV_Y; % Y分量的散度
        movie_DIV_U; % U分量的散度
        movie_DIV_V; % V分量的散度
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
        function obj = VideoInpainterCopy(dx,dy,dt) % VideoInpainter构造函数
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
        D = update_dataterm(obj,dataterm,ran_t) %更新数据项
        D = compute_dataterm(obj) %计算数据项
        P = compute_priority(obj,confidence,dataterm,front_idx); %计算所有边界点的优先级
        [cube,valid,r_x,r_y,r_t] = get_cube(obj,matrix,x,y,z) % 从3维（或4维）矩阵中取一个立方块的数据
        [YGx,YGy,UGx,UGy,VGx,VGy,sub_x,sub_y,sub_t] = find_best_exampler(obj,c_Y_Gx,c_Y_Gy,c_U_Gx,c_U_Gy,c_V_Gx,c_V_Gy,c_mask3d,t); 
        C = update_confidence(obj,confidence,ran_x,ran_y,ran_t)
    end
end

