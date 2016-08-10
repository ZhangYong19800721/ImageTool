function image = inpaint(obj,origin_image,mask)
%INPAINT ��ͼ������޲�
%   origin_image����Ҫ���޲���ͼ��
%   mask���ɰ壬���������Ҫ�޲�������1Ϊ��Ҫ�޲�������0Ϊ��֪����
    image = origin_image;
    [obj.row_num, obj.col_num] = size(mask);
    
    bound_finder = ones(3,3); bound_finder(5) = -8;
    bound_mat = conv2(double(mask),bound_finder,'same');
    bound_idx = find(bound_mat>0); [obj.boundx,obj.boundy] = find(bound_mat>0);
    obj.current_mask = mask; % ��ʼ��current_mask,��ʾ��ǰ����������
    C = double(~mask); % ��ʼ�����Ŷ�Ϊ��1-��֪����0-δ֪����
    C = obj.compute_confidence(C); % �������߽��ϵ����Ŷ�
    
    n = 1;
    while ~isempty(bound_idx) % ���ֱ���Ҳ����κα߽�
        D = obj.update_dataterm(image,obj.current_mask);
        P = obj.compute_priority(C,D,bound_idx);
        [~,best_idx] = max(P);
        posx = obj.boundx(best_idx); posy = obj.boundy(best_idx);
        [patch,ran_x,ran_y] = obj.get_patch(image,posx,posy);
        patch_mask = obj.get_patch(obj.current_mask,posx,posy);
        [best_exampler,~,~] = obj.find_best_exampler(patch,patch_mask,image);
        image(ran_x,ran_y,:) = patch .* repmat(double(~patch_mask),1,1,3) + best_exampler .* repmat(double(patch_mask),1,1,3); % ���ͼ��
        figure(1); imshow(uint8(image));
        C = obj.update_confidence(C,ran_x,ran_y); % ���±������������Ŷ�
        obj.current_mask(ran_x,ran_y) = 0; % ����current_mask�ɰ�
        bound_mat = conv2(double(obj.current_mask),bound_finder,'same'); % ����ȷ���߽�
        bound_idx = find(bound_mat>0);
        [obj.boundx,obj.boundy] = find(bound_mat>0); 
        n = n+1
    end
end

