function image = blend(obj,image1,image2,image2_idx) 
%BLEND ͼ���ں�
%   �˴���ʾ��ϸ˵��
    image = zeros(obj.canvas_row_num,obj.canvas_col_num);

    if obj.cameras(image2_idx).blend.isblend == false % ����Ҫ��ͼ���ں�
        image = image1;
        mask2 = obj.cameras(image2_idx).mask;
        image(mask2) = image2(mask2);
    else % ��Ҫ��ͼ���ں�
        for z = 1:obj.cameras(image2_idx).blend.zone_num % �ж����Ҫ���ںϵ�����˳���ÿһ�����д���
            clip_mask = obj.cameras(image2_idx).blend.clip_mask{z}; % ��z���ں����ľ��μ���ģ��
            image_1 = zeros(size(clip_mask)); % ���ݾ��μ���ģ��Ĵ�С��ʼ�����ں�ͼ��1
            image_2 = zeros(size(clip_mask)); % ���ݾ��μ���ģ��Ĵ�С��ʼ�����ں�ͼ��2
            
            overlap_mask = obj.cameras(image2_idx).blend.overlap_mask{z}; % ��z���ں�����Դͼ�����ɰ�
            image_1(clip_mask) = image1(overlap_mask);
            image_2(clip_mask) = image2(overlap_mask);
            
            region = obj.cameras(image2_idx).blend.region{z}; % ��z���ں������ںϱ߽�
            level = floor(log2(length(region))) - 1;
            blend_image = itool.MultiBandBlending.test_blend(image_1,image_2,region,level);
            
            image(overlap_mask) = blend_image(clip_mask); % ���ںϺ��ͼ������ȥ
        end
        
        mask1_mask2 = obj.cameras(image2_idx).blend.mask1_mask2;
        mask2_mask1 = obj.cameras(image2_idx).blend.mask2_mask1;
        image(mask1_mask2) = image1(mask1_mask2);
        image(mask2_mask1) = image2(mask2_mask1);
    end

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
%             cut = cat(1,unique_col_idx,unique_col_idx(end)+1) - cat(1,unique_col_idx(1)-1,unique_col_idx);
%             cut_idx = find(cut > 1); % �ֶε�����±�
%             seg_num = 1 + length(cut_idx); % �ܶ���
%             if seg_num == 1
%                 clip_mask = overlap_mask(unique_row_idx,unique_col_idx); % �ص����ֵļ��п���ɰ�    
%                 image_1 = zeros(size(clip_mask)); % �ص����ֵ�ͼ��1������߽磩����ʼ��Ϊȫ0
%                 image_2 = zeros(size(clip_mask)); % �ص����ֵ�ͼ��2������߽磩����ʼ��Ϊȫ0
%                 image_1(clip_mask) = image1(overlap_mask); % �ص����ֵ�ͼ��1������߽磩
%                 image_2(clip_mask) = image2(overlap_mask); % �ص����ֵ�ͼ��2������߽磩
%                 
%                 % �����ںϱ߽�
%                 region = zeros(size(clip_mask));
%                 unmask1 = ~mask1; unmask2 = ~mask2; % ȡmask1��mask2�ķ�
%                 front1 = unmask2(unique_row_idx,unique_col_idx); % �õ�ԭ������������image1�Ĳ���
%                 front2 = unmask1(unique_row_idx,unique_col_idx); % �õ�ԭ������������image2�Ĳ���
%                 region(front1) = -1; % ��ԭ������������image1�Ĳ��ֱ��Ϊ-1
%                 region(front2) = +1; % ��ԭ������������image2�Ĳ��ֱ��Ϊ+1
%                 
%                 % ��region���е�ͨ�˲�
%                 kernel = fspecial('gaussian',size(clip_mask),length(unique_col_idx));
%                 region = conv2(region,kernel,'same');
%                 region = (region>0); % ��0Ϊ�罫region��Ϊ��ֵͼ
%                 
%                 % ͼ���ں�
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
%                     clip_mask_seg = overlap_mask(unique_row_idx_seg,unique_col_idx_seg); % �ص����ֵļ��п���ɰ�
%                     image_1 = zeros(size(clip_mask_seg)); % �ص����ֵ�ͼ��1������߽磩����ʼ��Ϊȫ0
%                     image_2 = zeros(size(clip_mask_seg)); % �ص����ֵ�ͼ��2������߽磩����ʼ��Ϊȫ0
%                     overlap_mask_seg = logical(zeros(size(overlap_mask))); overlap_mask_seg(unique_row_idx_seg,unique_col_idx_seg) = clip_mask_seg;
%                     image_1(clip_mask_seg) = image1(overlap_mask_seg);
%                     image_2(clip_mask_seg) = image2(overlap_mask_seg);
%                     % �����ںϱ߽�
%                     region = zeros(size(clip_mask_seg));
%                     mask1_seg = mask1(unique_row_idx_seg,unique_col_idx_seg);
%                     mask2_seg = mask2(unique_row_idx_seg,unique_col_idx_seg);
%                     unmask1_seg = ~mask1_seg; unmask2_seg = ~mask2_seg; % ȡmask1��mask2�ķ�
%                     front1 = unmask2_seg; % �õ�ԭ������������image1�Ĳ���
%                     front2 = unmask1_seg; % �õ�ԭ������������image2�Ĳ���
%                     region(front1) = -1; % ��ԭ������������image1�Ĳ��ֱ��Ϊ-1
%                     region(front2) = +1; % ��ԭ������������image2�Ĳ��ֱ��Ϊ+1
%                     
%                     % ��region���е�ͨ�˲�
%                     kernel = fspecial('gaussian',size(clip_mask_seg),length(unique_col_idx_seg));
%                     region = conv2(region,kernel,'same');
%                     region = (region>0); % ��0Ϊ�罫region��Ϊ��ֵͼ
%                     
%                     % ͼ���ں�
%                     blend_image = itool.MultiBandBlending.test_blend(image_1,image_2,region,level);
%                     
%                     image(overlap_mask_seg) = blend_image(clip_mask_seg); % ���ںϺ��ͼ�񿽱�����Ӧ��λ��
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

