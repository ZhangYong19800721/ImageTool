function obj = interp_pos(obj,images)
%INTERP_POS �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    number_of_images = length(images); % ��Ҫƴ�ӵ�ͼƬ����
    for n = 1:number_of_images
        XYZ_Q_euclid = obj.cameras(n).K * obj.cameras(n).R * obj.correct * obj.xyz; % ��ʼ�����ֵ��ѯ������
        XYZ_I_euclid = 1000 * XYZ_Q_euclid ./ abs(repmat(XYZ_Q_euclid(3,:),3,1));
        X_I_euclid = XYZ_I_euclid(1,:); Y_I_euclid = XYZ_I_euclid(2,:); Z_I_euclid = XYZ_I_euclid(3,:); 
        [image_row_num,image_col_num,~] = size(images(n).image); % ��ȡͼ��Ĵ�С
        image_midx = (image_row_num-1)/2 + 1; image_midy = (image_col_num-1)/2 + 1; % ����ͼ�����ֵ��
        mask = (X_I_euclid >= (1-image_midx)) & (X_I_euclid <= (image_row_num-image_midx)) & ...
               (Y_I_euclid >= (1-image_midy)) & (Y_I_euclid <= (image_col_num-image_midy)) & ...
               (Z_I_euclid > 0); % ����õ���ͼ���Ӧ���ɰ�
        obj.cameras(n).mask = reshape(mask,obj.canvas_row_num,obj.canvas_col_num); % ��¼��n��ͼƬ���ɰ�
        obj.cameras(n).query_x = X_I_euclid(mask) + image_midx; % ��¼��n��ͼƬ�Ĳ�ֵ��ѯ�� 
        obj.cameras(n).query_y = Y_I_euclid(mask) + image_midy; % ��¼��n��ͼƬ�Ĳ�ֵ��ѯ��
        
        front_finder = ones(3,3); front_finder(5) = -8;
        front_mat = conv2(double(mask),front_finder,'same');
        obj.cameras(n).front = find(front_mat<0); % ����õ���n��ͼƬ�ı߿�����
    end
end

