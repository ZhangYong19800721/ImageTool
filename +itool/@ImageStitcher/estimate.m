function obj = estimate(obj, images)
%estimate ����ƴ�Ӳ���
%   images����Ҫ��ƴ�ӵ�ͼƬ����
    obj.canvas_row_num = 1080; obj.canvas_col_num = 5400;
    row_num = obj.canvas_row_num; col_num = obj.canvas_col_num; % �������յ������������������յ�ͼ��ֱ��� 
    radius_cylind = (col_num+1)/(2*pi); % ����Բ���İ뾶
    midx = (row_num-1)/2 + 1; midy = (col_num-1)/2 + 1; % ����X�������ֵ���Y�������ֵ��
    [Y_cylind,X_cylind] = meshgrid(1:col_num,1:row_num); % ��ȡ��������Բ������ϵ��
    X_cylind = X_cylind - midx; Y_cylind = Y_cylind - midy; % ������λ�ö�׼����ԭ�㣨Բ������ϵ��
    Z_cylind = radius_cylind * ones(size(X_cylind)); % �뾶��Բ������ϵ��
    X_cylind = reshape(X_cylind,1,[]); Y_cylind = reshape(Y_cylind,1,[]); Z_cylind = reshape(Z_cylind,1,[]); 
    XYZ_cylind = cat(1,X_cylind,Y_cylind,Z_cylind); % �õ�������������������Բ������ϵ��
    XYZ_euclid = itool.ImageStitcher.inv_cylindrical(XYZ_cylind); % ��Բ������ϵ������ֵ�任Ϊŷ������ϵ������ֵ
    
    number_of_images = length(images); % ��Ҫƴ�ӵ�ͼƬ����
    for n = 1:number_of_images
        if n == 1
            f = 2.5 * radius_cylind;
            obj.cameras(n).K = diag([1 1 f]);
            obj.cameras(n).R = expm(zeros(3,3));
        end
    end
    
    for n = 1:number_of_images
        % XYZ_Q_euclid = obj.cameras(n).R' * (obj.cameras(n).K \ XYZ_euclid); % ��ʼ�����ֵ��ѯ������
        XYZ_Q_euclid = obj.cameras(n).K(3,3) * XYZ_euclid ./ abs(repmat(XYZ_euclid(3,:),3,1)); 
        XYZ_Q_euclid = obj.cameras(n).R' * (obj.cameras(n).K \ XYZ_Q_euclid);
        X_Q_euclid = XYZ_Q_euclid(1,:); Y_Q_euclid = XYZ_Q_euclid(2,:); Z_Q_euclid = XYZ_Q_euclid(3,:); 
        [image_row_num,image_col_num,~] = size(images(n).image); % ��ȡͼ��Ĵ�С
        image_midx = (image_row_num-1)/2 + 1; image_midy = (image_col_num-1)/2 + 1; % ����ͼ�����ֵ��
        mask = (X_Q_euclid >= (1-image_midx)) & (X_Q_euclid <= (image_row_num-image_midx)) & ...
               (Y_Q_euclid >= (1-image_midy)) & (Y_Q_euclid <= (image_col_num-image_midy)) & ...
               (Z_Q_euclid > 0); % ����õ���ͼ���Ӧ���ɰ�
        obj.cameras(n).mask = mask; % ��¼��n��ͼƬ���ɰ�
        obj.cameras(n).query_x = X_Q_euclid(mask) + image_midx; % ��¼��n��ͼƬ�Ĳ�ֵ��ѯ�� 
        obj.cameras(n).query_y = Y_Q_euclid(mask) + image_midy; % ��¼��n��ͼƬ�Ĳ�ֵ��ѯ��
    end
end

