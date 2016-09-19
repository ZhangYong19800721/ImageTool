function image = blend(obj,image1,mask1,image2,mask2,level) 
%BLEND 图像融合
%   此处显示详细说明
    overlap_mask = mask1 & mask2; % 计算重叠区域的蒙板
    image = zeros(size(image1)); % 初始化融合后的图像,与image1同大小
    
    if sum(sum(overlap_mask)) == 0
        image(mask1) = image1(mask1);
        image(mask2) = image2(mask2);
    else
        [row_idx,col_idx] = find(overlap_mask > 0);
        unique_row_idx = unique(row_idx);
        unique_col_idx = unique(col_idx);
        
        clip_mask = overlap_mask(unique_row_idx,unique_col_idx); % 重叠部分的剪切块的蒙板
        
        image_1 = zeros(size(clip_mask)); % 重叠部分的图像1（规则边界），初始化为全0
        image_2 = zeros(size(clip_mask)); % 重叠部分的图像2（规则边界），初始化为全0
        
        image_1(clip_mask) = image1(overlap_mask); % 重叠部分的图像1（规则边界）
        image_2(clip_mask) = image2(overlap_mask); % 重叠部分的图像2（规则边界）
        
        % 计算融合边界
        [m,n] = size(clip_mask);
        blend_mask = logical(zeros(size(clip_mask))); 
        blend_mask(:,ceil(n/2):n) = 1;
        blend_image = itool.MultiBandBlending.test_blend(image_1,image_2,blend_mask,level);
        
        mask1_mask2 = mask1; mask1_mask2(mask2) = 0;
        mask2_mask1 = mask2; mask2_mask1(mask1) = 0;
        image(mask1_mask2) = image1(mask1_mask2);
        image(mask2_mask1) = image2(mask2_mask1);
        image(overlap_mask) = blend_image(clip_mask);
    end
end

