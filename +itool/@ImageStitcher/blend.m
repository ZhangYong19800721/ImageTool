function image = blend(obj,image1,mask1,image2,mask2,level) 
%BLEND ͼ���ں�
%   �˴���ʾ��ϸ˵��
    overlap_mask = mask1 & mask2; % �����ص�������ɰ�
    image = zeros(size(image1)); % ��ʼ���ںϺ��ͼ��,��image1ͬ��С
    
    if sum(sum(overlap_mask)) == 0
        image(mask1) = image1(mask1);
        image(mask2) = image2(mask2);
    else
        [row_idx,col_idx] = find(overlap_mask > 0);
        unique_row_idx = unique(row_idx);
        unique_col_idx = unique(col_idx);
        
        clip_mask = overlap_mask(unique_row_idx,unique_col_idx); % �ص����ֵļ��п���ɰ�
        
        image_1 = zeros(size(clip_mask)); % �ص����ֵ�ͼ��1������߽磩����ʼ��Ϊȫ0
        image_2 = zeros(size(clip_mask)); % �ص����ֵ�ͼ��2������߽磩����ʼ��Ϊȫ0
        
        image_1(clip_mask) = image1(overlap_mask); % �ص����ֵ�ͼ��1������߽磩
        image_2(clip_mask) = image2(overlap_mask); % �ص����ֵ�ͼ��2������߽磩
        
        % �����ںϱ߽�
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

