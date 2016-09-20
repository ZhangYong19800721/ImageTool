function obj = blend_estimate(obj)
%BLEND_ESTIMATE 对图像融合需要的参数进行估计
%   此处显示详细说明
    
    mask1 = logical(zeros(obj.canvas_row_num,obj.canvas_col_num)); % 初始化总mask为全0
    for n = obj.sequence
        mask2 = obj.cameras(n).mask; % 取得第n个图像的蒙板
        overlap_mask = mask1 & mask2; % 
        if sum(sum(overlap_mask)) == 0 % 不存在重叠区域的情况
            obj.cameras(n).blend.isblend = false; % 不需要做图像融合
        else % 存在重叠区域的情况
            obj.cameras(n).blend.isblend = true; % 需要做图像融合
            [row_idx,col_idx] = find(overlap_mask > 0);
            row_idx = unique(row_idx); % 重叠区域的行下标
            col_idx = unique(col_idx); % 重叠区域的列下标
            % 计算存在多少个独立重叠子区
            cut = cat(1,col_idx,col_idx(end)+1) - cat(1,col_idx(1)-1,col_idx);
            cut = find(cut > 1); % 分段点的列下标
            
            is_most_r = col_idx(end) == obj.canvas_col_num; % 判断画布的最右侧列是否在重叠区中
            is_most_l = col_idx(1) == 1;                    % 判断画布的最左侧列是否在重叠区中
            is_cross = obj.alfa == 360 && is_most_r && is_most_l; % 判断重叠区是否跨界
            
            if is_cross; obj.cameras(n).blend.zone_num = length(cut);   % 重叠区  跨界的情况
            else         obj.cameras(n).blend.zone_num = 1+length(cut); % 重叠区不跨界的情况
            end
            
            if is_cross;  cut = cat(1,cut,length(col_idx)+1);    % 重叠区  跨界的情况
            else          cut = cat(1,1,cut,length(col_idx)+1);  % 重叠区不跨界的情况
            end
            
            for z = 1:obj.cameras(n).blend.zone_num % 对每一个重叠子区进行计算    
                if z == obj.cameras(n).blend.zone_num && is_cross % z是最后一个子区且跨界
                    col_idx_z_part1 = col_idx(cut(z):end); 
                    col_idx_z_part2 = col_idx(1:(cut(1)-1));
                    col_idx_z = [col_idx_z_part1; col_idx_z_part2];
                    [row_idx_z,~] = find(overlap_mask(:,col_idx_z)>0);
                    row_idx_z = unique(row_idx_z);
                    obj.cameras(n).blend.clip_mask{z} = overlap_mask(row_idx_z,col_idx_z); % 得到剪切块蒙板
                    
                    overlap_mask_z_part1 = logical(zeros(size(overlap_mask)));
                    overlap_mask_z_part2 = logical(zeros(size(overlap_mask)));
                    overlap_mask_z_part1(row_idx_z,col_idx_z_part1) = overlap_mask(row_idx_z,col_idx_z_part1);
                    overlap_mask_z_part2(row_idx_z,col_idx_z_part2) = overlap_mask(row_idx_z,col_idx_z_part2);
                    overlap_mask_z_part1 = find(overlap_mask_z_part1);
                    overlap_mask_z_part2 = find(overlap_mask_z_part2);
                    overlap_mask_z = cat(1,overlap_mask_z_part1,overlap_mask_z_part2);
                    obj.cameras(n).blend.overlap_mask{z} = overlap_mask_z;  
                    
                    % 计算融合边界
                    region_z = zeros(size(obj.cameras(n).blend.clip_mask{z}));
                    mask1_z = mask1(row_idx_z,col_idx_z);
                    mask2_z = mask2(row_idx_z,col_idx_z);
                    non_mask1_z = ~mask1_z; non_mask2_z = ~mask2_z; % 取mask1和mask2的非
                    region_z(non_mask2_z) = -1; % 将原来单独归属于image1的部分标记为-1
                    region_z(non_mask1_z) = +1; % 将原来单独归属于image2的部分标记为+1
                    
                    % 对region进行低通滤波
                    kernel_z = fspecial('gaussian',size(region_z),length(col_idx_z));
                    region_z = conv2(region_z,kernel_z,'same');
                    region_z = (region_z>0); % 以0为界将region变为二值图
                    obj.cameras(n).blend.region{z} = region_z;
                else
                    col_idx_z = col_idx(cut(z):(cut(z+1)-1));
                    [row_idx_z,~] = find(overlap_mask(:,col_idx_z)>0);
                    row_idx_z = unique(row_idx_z);
                    
                    obj.cameras(n).blend.clip_mask{z} = overlap_mask(row_idx_z,col_idx_z); % 得到剪切块蒙板
                    
                    overlap_mask_z = logical(zeros(size(overlap_mask)));
                    overlap_mask_z(row_idx_z,col_idx_z) = obj.cameras(n).blend.clip_mask{z};
                    obj.cameras(n).blend.overlap_mask{z} = overlap_mask_z; % 得到重叠蒙板
                    
                    % 计算融合边界
                    region_z = zeros(size(obj.cameras(n).blend.clip_mask{z}));
                    mask1_z = mask1(row_idx_z,col_idx_z);
                    mask2_z = mask2(row_idx_z,col_idx_z);
                    non_mask1_z = ~mask1_z; non_mask2_z = ~mask2_z; % 取mask1和mask2的非
                    region_z(non_mask2_z) = -1; % 将原来单独归属于image1的部分标记为-1
                    region_z(non_mask1_z) = +1; % 将原来单独归属于image2的部分标记为+1
                    
                    % 对region进行低通滤波
                    kernel_z = fspecial('gaussian',size(region_z),length(col_idx_z));
                    region_z = conv2(region_z,kernel_z,'same');
                    region_z = (region_z>0); % 以0为界将region变为二值图
                    obj.cameras(n).blend.region{z} = region_z;
                end
            end
            
            obj.cameras(n).blend.mask1_mask2 = mask1; obj.cameras(n).blend.mask1_mask2(mask2) = 0;
            obj.cameras(n).blend.mask2_mask1 = mask2; obj.cameras(n).blend.mask2_mask1(mask1) = 0;
        end
        mask1(mask2) = 1;
    end
    
%     return;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
% 
%         end
%     end
end

