function image = inpaint(obj,origin_image,mask)
%INPAINT 对图像进行修补
%   origin_image：需要被修补的图像
%   mask：蒙板，用来标记需要修补的区域，1为需要修补的区域，0为已知区域
    image = origin_image;
    [obj.row_num, obj.col_num] = size(mask);
    
    bound_finder = ones(3,3); bound_finder(5) = -8;
    bound_mat = conv2(double(mask),bound_finder,'same');
    bound_idx = find(bound_mat>0); [obj.boundx,obj.boundy] = find(bound_mat>0);
    obj.current_mask = mask; % 初始化current_mask,表示当前待填充的区域
    C = double(~mask); % 初始化置信度为：1-已知区域，0-未知区域
    C = obj.compute_confidence(C); % 计算填充边界上的自信度
    
    n = 1;
    while ~isempty(bound_idx) % 填充直到找不到任何边界
        D = obj.update_dataterm(image,obj.current_mask);
        P = obj.compute_priority(C,D,bound_idx);
        [~,best_idx] = max(P);
        posx = obj.boundx(best_idx); posy = obj.boundy(best_idx);
        [patch,ran_x,ran_y] = obj.get_patch(image,posx,posy);
        patch_mask = obj.get_patch(obj.current_mask,posx,posy);
        [best_exampler,~,~] = obj.find_best_exampler(patch,patch_mask,image);
        image(ran_x,ran_y,:) = patch .* repmat(double(~patch_mask),1,1,3) + best_exampler .* repmat(double(patch_mask),1,1,3); % 填充图像
        figure(1); imshow(uint8(image));
        C = obj.update_confidence(C,ran_x,ran_y); % 更新被填充区域的自信度
        obj.current_mask(ran_x,ran_y) = 0; % 更新current_mask蒙板
        bound_mat = conv2(double(obj.current_mask),bound_finder,'same'); % 重新确定边界
        bound_idx = find(bound_mat>0);
        [obj.boundx,obj.boundy] = find(bound_mat>0); 
        n = n+1
    end
end

