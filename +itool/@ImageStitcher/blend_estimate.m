function obj = blend_estimate(obj)
%BLEND_ESTIMATE ��ͼ���ں���Ҫ�Ĳ������й���
%   �˴���ʾ��ϸ˵��
    
    mask1 = logical(zeros(obj.canvas_row_num,obj.canvas_col_num)); % ��ʼ����maskΪȫ0
    for n = obj.sequence
        mask2 = obj.cameras(n).mask; % ȡ�õ�n��ͼ����ɰ�
        overlap_mask = mask1 & mask2; % 
        if sum(sum(overlap_mask)) == 0 % �������ص���������
            obj.cameras(n).blend.isblend = false; % ����Ҫ��ͼ���ں�
        else % �����ص���������
            obj.cameras(n).blend.isblend = true; % ��Ҫ��ͼ���ں�
            [row_idx,col_idx] = find(overlap_mask > 0);
            row_idx = unique(row_idx); % �ص���������±�
            col_idx = unique(col_idx); % �ص���������±�
            % ������ڶ��ٸ������ص�����
            cut = cat(1,col_idx,col_idx(end)+1) - cat(1,col_idx(1)-1,col_idx);
            cut = find(cut > 1); % �ֶε�����±�
            
            is_most_r = col_idx(end) == obj.canvas_col_num; % �жϻ��������Ҳ����Ƿ����ص�����
            is_most_l = col_idx(1) == 1;                    % �жϻ�������������Ƿ����ص�����
            is_cross = obj.alfa == 360 && is_most_r && is_most_l; % �ж��ص����Ƿ���
            
            if is_cross; obj.cameras(n).blend.zone_num = length(cut);   % �ص���  �������
            else         obj.cameras(n).blend.zone_num = 1+length(cut); % �ص������������
            end
            
            if is_cross;  cut = cat(1,cut,length(col_idx)+1);    % �ص���  �������
            else          cut = cat(1,1,cut,length(col_idx)+1);  % �ص������������
            end
            
            for z = 1:obj.cameras(n).blend.zone_num % ��ÿһ���ص��������м���    
                if z == obj.cameras(n).blend.zone_num && is_cross % z�����һ�������ҿ��
                    col_idx_z_part1 = col_idx(cut(z):end); 
                    col_idx_z_part2 = col_idx(1:(cut(1)-1));
                    col_idx_z = [col_idx_z_part1; col_idx_z_part2];
                    [row_idx_z,~] = find(overlap_mask(:,col_idx_z)>0);
                    row_idx_z = unique(row_idx_z);
                    obj.cameras(n).blend.clip_mask{z} = overlap_mask(row_idx_z,col_idx_z); % �õ����п��ɰ�
                    
                    overlap_mask_z_part1 = logical(zeros(size(overlap_mask)));
                    overlap_mask_z_part2 = logical(zeros(size(overlap_mask)));
                    overlap_mask_z_part1(row_idx_z,col_idx_z_part1) = overlap_mask(row_idx_z,col_idx_z_part1);
                    overlap_mask_z_part2(row_idx_z,col_idx_z_part2) = overlap_mask(row_idx_z,col_idx_z_part2);
                    overlap_mask_z_part1 = find(overlap_mask_z_part1);
                    overlap_mask_z_part2 = find(overlap_mask_z_part2);
                    overlap_mask_z = cat(1,overlap_mask_z_part1,overlap_mask_z_part2);
                    obj.cameras(n).blend.overlap_mask{z} = overlap_mask_z;  
                    
                    % �����ںϱ߽�
                    region_z = zeros(size(obj.cameras(n).blend.clip_mask{z}));
                    mask1_z = mask1(row_idx_z,col_idx_z);
                    mask2_z = mask2(row_idx_z,col_idx_z);
                    non_mask1_z = ~mask1_z; non_mask2_z = ~mask2_z; % ȡmask1��mask2�ķ�
                    region_z(non_mask2_z) = -1; % ��ԭ������������image1�Ĳ��ֱ��Ϊ-1
                    region_z(non_mask1_z) = +1; % ��ԭ������������image2�Ĳ��ֱ��Ϊ+1
                    
                    % ��region���е�ͨ�˲�
                    kernel_z = fspecial('gaussian',size(region_z),length(col_idx_z));
                    region_z = conv2(region_z,kernel_z,'same');
                    region_z = (region_z>0); % ��0Ϊ�罫region��Ϊ��ֵͼ
                    obj.cameras(n).blend.region{z} = region_z;
                else
                    col_idx_z = col_idx(cut(z):(cut(z+1)-1));
                    [row_idx_z,~] = find(overlap_mask(:,col_idx_z)>0);
                    row_idx_z = unique(row_idx_z);
                    
                    obj.cameras(n).blend.clip_mask{z} = overlap_mask(row_idx_z,col_idx_z); % �õ����п��ɰ�
                    
                    overlap_mask_z = logical(zeros(size(overlap_mask)));
                    overlap_mask_z(row_idx_z,col_idx_z) = obj.cameras(n).blend.clip_mask{z};
                    obj.cameras(n).blend.overlap_mask{z} = overlap_mask_z; % �õ��ص��ɰ�
                    
                    % �����ںϱ߽�
                    region_z = zeros(size(obj.cameras(n).blend.clip_mask{z}));
                    mask1_z = mask1(row_idx_z,col_idx_z);
                    mask2_z = mask2(row_idx_z,col_idx_z);
                    non_mask1_z = ~mask1_z; non_mask2_z = ~mask2_z; % ȡmask1��mask2�ķ�
                    region_z(non_mask2_z) = -1; % ��ԭ������������image1�Ĳ��ֱ��Ϊ-1
                    region_z(non_mask1_z) = +1; % ��ԭ������������image2�Ĳ��ֱ��Ϊ+1
                    
                    % ��region���е�ͨ�˲�
                    kernel_z = fspecial('gaussian',size(region_z),length(col_idx_z));
                    region_z = conv2(region_z,kernel_z,'same');
                    region_z = (region_z>0); % ��0Ϊ�罫region��Ϊ��ֵͼ
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
%     overlap_mask = mask1 & mask2; % �����ص�������ɰ�
%     image = zeros(size(image1)); % ��ʼ���ںϺ��ͼ��,��image1ͬ��С
%     
%     if sum(sum(overlap_mask)) == 0 % �������ص���������
%         image(mask1) = image1(mask1); % ֱ�ӽ�ͼ�񿽱����ںϽ����
%         image(mask2) = image2(mask2); % ֱ�ӽ�ͼ�񿽱����ںϽ����
%     else % �����ص���������
%         [row_idx,col_idx] = find(overlap_mask > 0);
%         unique_row_idx = unique(row_idx); % �ص���������±�
%         unique_col_idx = unique(col_idx); % �ص���������±�
% 
%         is_cross_r = logical(sum(unique_col_idx == obj.canvas_col_num)); % �жϻ��������Ҳ����Ƿ����ص�����
%         is_cross_l = logical(sum(unique_col_idx == 1)); % �жϻ�������������Ƿ����ص�����
%         if obj.alfa == 360 && is_cross_r && is_cross_l % �ص����������
%             cut = cat(1,unique_col_idx,obj.canvas_col_num+1) - cat(1,0,unique_col_idx);
%             cut_idx = find(cut > 1);
%             overlap_part1_col_idx = unique_col_idx(cut_idx:end);   % �ص�����ಿ�ֵ������  
%             overlap_part2_col_idx = unique_col_idx(1:(cut_idx-1)); % �ص����Ҳಿ�ֵ������
%             clip_mask = overlap_mask(unique_row_idx,cat(1,overlap_part1_col_idx,overlap_part2_col_idx)); % �ص����ֵļ��п���ɰ� 
%             image_1 = zeros(size(clip_mask)); % �ص����ֵ�ͼ��1������߽磩����ʼ��Ϊȫ0
%             image_2 = zeros(size(clip_mask)); % �ص����ֵ�ͼ��2������߽磩����ʼ��Ϊȫ0
%             clip_mask_part1 = clip_mask; clip_mask_part1(:,(end-cut_idx+2):end) = 0;
%             clip_mask_part2 = clip_mask; clip_mask_part2(:,1:(end-cut_idx+1)) = 0;
%             overlap_mask_part1 = overlap_mask; overlap_mask_part1(:,overlap_part2_col_idx) = 0;
%             overlap_mask_part2 = overlap_mask; overlap_mask_part2(:,overlap_part1_col_idx) = 0;
%             image_1(clip_mask_part1) = image1(overlap_mask_part1); % �ص����ֵ�ͼ��1������߽磩
%             image_1(clip_mask_part2) = image1(overlap_mask_part2); % �ص����ֵ�ͼ��1������߽磩
%             image_2(clip_mask_part1) = image2(overlap_mask_part1); % �ص����ֵ�ͼ��2������߽磩
%             image_2(clip_mask_part2) = image2(overlap_mask_part2); % �ص����ֵ�ͼ��2������߽磩
%             
%             % �����ںϱ߽�
%             region = zeros(size(clip_mask));
%             unmask1 = ~mask1; unmask2 = ~mask2; % ȡmask1��mask2�ķ�
%             front1 = cat(2,unmask2(unique_row_idx,overlap_part1_col_idx),unmask2(unique_row_idx,overlap_part2_col_idx)); % �õ�ԭ������������image1�Ĳ���
%             front2 = cat(2,unmask1(unique_row_idx,overlap_part1_col_idx),unmask1(unique_row_idx,overlap_part2_col_idx)); % �õ�ԭ������������image2�Ĳ���
%             region(front1) = -1; % ��ԭ������������image1�Ĳ��ֱ��Ϊ-1
%             region(front2) = +1; % ��ԭ������������image2�Ĳ��ֱ��Ϊ+1
%             % region(front1 & front2) = 0; 
%             
%             % ��region���е�ͨ�˲�
%             kernel = fspecial('gaussian',size(clip_mask),length(unique_col_idx));
%             region = conv2(region,kernel,'same');
%             region = (region>0); % ��0Ϊ�罫region��Ϊ��ֵͼ
%             
%             % ͼ���ں�
%             blend_image = itool.MultiBandBlending.test_blend(image_1,image_2,region,level);
%             
%             mask1_mask2 = mask1; mask1_mask2(mask2) = 0;
%             mask2_mask1 = mask2; mask2_mask1(mask1) = 0;
%             image(mask1_mask2) = image1(mask1_mask2);
%             image(mask2_mask1) = image2(mask2_mask1);
%             
%             image(overlap_mask_part1) = blend_image(clip_mask_part1);
%             image(overlap_mask_part2) = blend_image(clip_mask_part2);
%         else % �ص������������
% 
%         end
%     end
end

