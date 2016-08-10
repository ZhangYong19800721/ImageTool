classdef ImageInpainter         
    %IMAGEINPAINTER 修补图像的类
    %   实现了2004年A.Criminisi的算法，论文原文为“Region Filling and Object Removal by Exemplar-Based Image Inpaiting”
    
    properties
        row_num; % 图像的行数
        col_num; % 图像的列数
        boundx; % 待填充区域的边界
        boundy; % 待填充区域的边界
        deltax; % 块的x大小
        deltay; % 块的y大小
        current_mask; % 当前蒙板
    end
    
    methods
        function obj = ImageInpainter()
            obj.deltax = 5;
            obj.deltay = 5;
        end
    end
    
    methods
        image = inpaint(obj,origin_image,mask)
        C = update_confidence(obj,confidence,range_x,range_y);
        D = update_dataterm(obj,image,mask)
        [patch, range_x, range_y] = get_patch(obj,mat,x,y)
        [exampler,x,y] = find_best_exampler(obj,patch,patch_mask,image)
        distance = match_distance(obj,patch,exampler,patch_mask)
        C = compute_confidence(obj,confidence)
        P = compute_priority(obj,confidence,dataterm,boundary)
    end
end

