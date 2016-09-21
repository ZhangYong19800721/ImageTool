function image = blend(obj,image1,image2,image2_idx) 
%BLEND 图像融合
%   此处显示详细说明
    image = zeros(obj.canvas_row_num,obj.canvas_col_num);

    if obj.cameras(image2_idx).blend.isblend == false % 不需要做图像融合
        image = image1;
        mask2 = obj.cameras(image2_idx).mask;
        image(mask2) = image2(mask2);
    else % 需要做图像融合
        for z = 1:obj.cameras(image2_idx).blend.zone_num % 有多个需要做融合的区域，顺序对每一个进行处理
            clip_mask = obj.cameras(image2_idx).blend.clip_mask{z}; % 第z个融合区的矩形剪辑模板
            image_1 = zeros(size(clip_mask)); % 根据矩形剪辑模板的大小初始化待融合图像1
            image_2 = zeros(size(clip_mask)); % 根据矩形剪辑模板的大小初始化待融合图像2
            
            overlap_mask = obj.cameras(image2_idx).blend.overlap_mask{z}; % 第z个融合区的源图拷贝蒙板
            image_1(clip_mask) = image1(overlap_mask);
            image_2(clip_mask) = image2(overlap_mask);
            
            region = obj.cameras(image2_idx).blend.region{z}; % 第z个融合区的融合边界
            level = floor(log2(length(region))) - 1;
            blend_image = itool.MultiBandBlending.test_blend(image_1,image_2,region,level);
            
            image(overlap_mask) = blend_image(clip_mask); % 将融合后的图拷贝回去
        end
        
        mask1_mask2 = obj.cameras(image2_idx).blend.mask1_mask2;
        mask2_mask1 = obj.cameras(image2_idx).blend.mask2_mask1;
        image(mask1_mask2) = image1(mask1_mask2);
        image(mask2_mask1) = image2(mask2_mask1);
    end

%     overlap_mask = mask1 & mask2; % 计算重叠区域的蒙板
%     image = zeros(size(image1)); % 初始化融合后的图像,与image1同大小
%     
%     if sum(sum(overlap_mask)) == 0 % 不存在重叠区域的情况
%         image(mask1) = image1(mask1); % 直接将图像拷贝到融合结果中
%         image(mask2) = image2(mask2); % 直接将图像拷贝到融合结果中
%     else % 存在重叠区域的情况
%         [row_idx,col_idx] = find(overlap_mask > 0);
%         unique_row_idx = unique(row_idx); % 重叠区域的行下标
%         unique_col_idx = unique(col_idx); % 重叠区域的列下标
% 
%         is_cross_r = logical(sum(unique_col_idx == obj.canvas_col_num)); % 判断画布的最右侧列是否在重叠区中
%         is_cross_l = logical(sum(unique_col_idx == 1)); % 判断画布的最左侧列是否在重叠区中
%         if obj.alfa == 360 && is_cross_r && is_cross_l % 重叠区跨界的情况
%             cut = cat(1,unique_col_idx,obj.canvas_col_num+1) - cat(1,0,unique_col_idx);
%             cut_idx = find(cut > 1);
%             overlap_part1_col_idx = unique_col_idx(cut_idx:end);   % 重叠区左侧部分的列序号  
%             overlap_part2_col_idx = unique_col_idx(1:(cut_idx-1)); % 重叠区右侧部分的列序号
%             clip_mask = overlap_mask(unique_row_idx,cat(1,overlap_part1_col_idx,overlap_part2_col_idx)); % 重叠部分的剪切块的蒙板 
%             image_1 = zeros(size(clip_mask)); % 重叠部分的图像1（规则边界），初始化为全0
%             image_2 = zeros(size(clip_mask)); % 重叠部分的图像2（规则边界），初始化为全0
%             clip_mask_part1 = clip_mask; clip_mask_part1(:,(end-cut_idx+2):end) = 0;
%             clip_mask_part2 = clip_mask; clip_mask_part2(:,1:(end-cut_idx+1)) = 0;
%             overlap_mask_part1 = overlap_mask; overlap_mask_part1(:,overlap_part2_col_idx) = 0;
%             overlap_mask_part2 = overlap_mask; overlap_mask_part2(:,overlap_part1_col_idx) = 0;
%             image_1(clip_mask_part1) = image1(overlap_mask_part1); % 重叠部分的图像1（规则边界）
%             image_1(clip_mask_part2) = image1(overlap_mask_part2); % 重叠部分的图像1（规则边界）
%             image_2(clip_mask_part1) = image2(overlap_mask_part1); % 重叠部分的图像2（规则边界）
%             image_2(clip_mask_part2) = image2(overlap_mask_part2); % 重叠部分的图像2（规则边界）
%             
%             % 计算融合边界
%             region = zeros(size(clip_mask));
%             unmask1 = ~mask1; unmask2 = ~mask2; % 取mask1和mask2的非
%             front1 = cat(2,unmask2(unique_row_idx,overlap_part1_col_idx),unmask2(unique_row_idx,overlap_part2_col_idx)); % 得到原来单独归属于image1的部分
%             front2 = cat(2,unmask1(unique_row_idx,overlap_part1_col_idx),unmask1(unique_row_idx,overlap_part2_col_idx)); % 得到原来单独归属于image2的部分
%             region(front1) = -1; % 将原来单独归属于image1的部分标记为-1
%             region(front2) = +1; % 将原来单独归属于image2的部分标记为+1
%             % region(front1 & front2) = 0; 
%             
%             % 对region进行低通滤波
%             kernel = fspecial('gaussian',size(clip_mask),length(unique_col_idx));
%             region = conv2(region,kernel,'same');
%             region = (region>0); % 以0为界将region变为二值图
%             
%             % 图像融合
%             blend_image = itool.MultiBandBlending.test_blend(image_1,image_2,region,level);
%             
%             mask1_mask2 = mask1; mask1_mask2(mask2) = 0;
%             mask2_mask1 = mask2; mask2_mask1(mask1) = 0;
%             image(mask1_mask2) = image1(mask1_mask2);
%             image(mask2_mask1) = image2(mask2_mask1);
%             
%             image(overlap_mask_part1) = blend_image(clip_mask_part1);
%             image(overlap_mask_part2) = blend_image(clip_mask_part2);
%         else % 重叠区不跨界的情况
%             cut = cat(1,unique_col_idx,unique_col_idx(end)+1) - cat(1,unique_col_idx(1)-1,unique_col_idx);
%             cut_idx = find(cut > 1); % 分段点的列下标
%             seg_num = 1 + length(cut_idx); % 总段数
%             if seg_num == 1
%                 clip_mask = overlap_mask(unique_row_idx,unique_col_idx); % 重叠部分的剪切块的蒙板    
%                 image_1 = zeros(size(clip_mask)); % 重叠部分的图像1（规则边界），初始化为全0
%                 image_2 = zeros(size(clip_mask)); % 重叠部分的图像2（规则边界），初始化为全0
%                 image_1(clip_mask) = image1(overlap_mask); % 重叠部分的图像1（规则边界）
%                 image_2(clip_mask) = image2(overlap_mask); % 重叠部分的图像2（规则边界）
%                 
%                 % 计算融合边界
%                 region = zeros(size(clip_mask));
%                 unmask1 = ~mask1; unmask2 = ~mask2; % 取mask1和mask2的非
%                 front1 = unmask2(unique_row_idx,unique_col_idx); % 得到原来单独归属于image1的部分
%                 front2 = unmask1(unique_row_idx,unique_col_idx); % 得到原来单独归属于image2的部分
%                 region(front1) = -1; % 将原来单独归属于image1的部分标记为-1
%                 region(front2) = +1; % 将原来单独归属于image2的部分标记为+1
%                 
%                 % 对region进行低通滤波
%                 kernel = fspecial('gaussian',size(clip_mask),length(unique_col_idx));
%                 region = conv2(region,kernel,'same');
%                 region = (region>0); % 以0为界将region变为二值图
%                 
%                 % 图像融合
%                 blend_image = itool.MultiBandBlending.test_blend(image_1,image_2,region,level);
%                 
%                 mask1_mask2 = mask1; mask1_mask2(mask2) = 0;
%                 mask2_mask1 = mask2; mask2_mask1(mask1) = 0;
%                 image(mask1_mask2) = image1(mask1_mask2);
%                 image(mask2_mask1) = image2(mask2_mask1);
%                 image(overlap_mask) = blend_image(clip_mask);
%             else
%                 cut_idx = cat(1,1,cut_idx,length(unique_col_idx)+1);
%                 for s = 1:seg_num
%                     unique_col_idx_seg = unique_col_idx(cut_idx(s):(cut_idx(s+1)-1));
%                     [row_idx_seg,~] = find(overlap_mask(:,unique_col_idx_seg)>0);
%                     unique_row_idx_seg = unique(row_idx_seg);
%                     clip_mask_seg = overlap_mask(unique_row_idx_seg,unique_col_idx_seg); % 重叠部分的剪切块的蒙板
%                     image_1 = zeros(size(clip_mask_seg)); % 重叠部分的图像1（规则边界），初始化为全0
%                     image_2 = zeros(size(clip_mask_seg)); % 重叠部分的图像2（规则边界），初始化为全0
%                     overlap_mask_seg = logical(zeros(size(overlap_mask))); overlap_mask_seg(unique_row_idx_seg,unique_col_idx_seg) = clip_mask_seg;
%                     image_1(clip_mask_seg) = image1(overlap_mask_seg);
%                     image_2(clip_mask_seg) = image2(overlap_mask_seg);
%                     % 计算融合边界
%                     region = zeros(size(clip_mask_seg));
%                     mask1_seg = mask1(unique_row_idx_seg,unique_col_idx_seg);
%                     mask2_seg = mask2(unique_row_idx_seg,unique_col_idx_seg);
%                     unmask1_seg = ~mask1_seg; unmask2_seg = ~mask2_seg; % 取mask1和mask2的非
%                     front1 = unmask2_seg; % 得到原来单独归属于image1的部分
%                     front2 = unmask1_seg; % 得到原来单独归属于image2的部分
%                     region(front1) = -1; % 将原来单独归属于image1的部分标记为-1
%                     region(front2) = +1; % 将原来单独归属于image2的部分标记为+1
%                     
%                     % 对region进行低通滤波
%                     kernel = fspecial('gaussian',size(clip_mask_seg),length(unique_col_idx_seg));
%                     region = conv2(region,kernel,'same');
%                     region = (region>0); % 以0为界将region变为二值图
%                     
%                     % 图像融合
%                     blend_image = itool.MultiBandBlending.test_blend(image_1,image_2,region,level);
%                     
%                     image(overlap_mask_seg) = blend_image(clip_mask_seg); % 将融合后的图像拷贝到相应的位置
%                 end
%                 
%                 mask1_mask2 = mask1; mask1_mask2(mask2) = 0;
%                 mask2_mask1 = mask2; mask2_mask1(mask1) = 0;
%                 image(mask1_mask2) = image1(mask1_mask2);
%                 image(mask2_mask1) = image2(mask2_mask1);
%             end
%         end
%     end
end

