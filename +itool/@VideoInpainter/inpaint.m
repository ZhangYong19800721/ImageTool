function mov = inpaint(obj,movie,mask)
%INPAINT 对视频进行修复
%   movie: 包含若干帧的电影帧数据
%   mask: 蒙板,是一个二值图像，需要修补的区域标记为1，其它区域标记为0。

    obj = obj.initialize(movie,mask); % 初始化
    [obj.front_idx, obj.front_x, obj.front_y, obj.front_t] = obj.find_front(); % 寻找待填充边界
    C = double(~obj.mask); % 初始化自信度
    C = obj.compute_confidence(C); % 计算填充边界上的自信度
    
    
    n = 1;
    while ~isempty(obj.front_idx) % 填充直到找不到任何边界
        D = obj.update_dataterm();
        
        [obj.front_idx, obj.front_x, obj.front_y, obj.front_t] = obj.find_front(); % 重新确定待填充边界
        n = n+1
    end
end

