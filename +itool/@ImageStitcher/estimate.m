function obj = estimate(obj, images)
%estimate ����ƴ�Ӳ���
%   images����Ҫ��ƴ�ӵ�ͼƬ����
    obj.canvas_row_num = 2048; obj.canvas_col_num = 4096; angle = 360 * pi / 180; % �������յ������������������յ�ͼ��ֱ���
    radius_cylind = (obj.canvas_col_num+1)/angle; % ����Բ���İ뾶
    midx = (obj.canvas_row_num-1)/2 + 1; midy = (obj.canvas_col_num-1)/2 + 1; % ����X�������ֵ���Y�������ֵ��
    [Y_cylind,X_cylind] = meshgrid(1:obj.canvas_col_num,1:obj.canvas_row_num); % ��ȡ��������Բ������ϵ��
    X_cylind = X_cylind - midx; Y_cylind = Y_cylind - midy; % ������λ�ö�׼����ԭ�㣨Բ������ϵ��
    Z_cylind = radius_cylind * ones(size(X_cylind)); % �뾶��Բ������ϵ��
    X_cylind = reshape(X_cylind,1,[]); Y_cylind = reshape(Y_cylind,1,[]); Z_cylind = reshape(Z_cylind,1,[]); 
    XYZ_cylind = cat(1,X_cylind,Y_cylind,Z_cylind); % �õ�������������������Բ������ϵ��
    XYZ_euclid = itool.ImageStitcher.inv_cylindrical(XYZ_cylind); % ��Բ������ϵ������ֵ�任Ϊŷ������ϵ������ֵ
    
    % �����е�����������й���
    obj = obj.bundle_adjust(images);
    
    % �����������H������ÿ��ͼƬ��Ӧ���ɰ�Ͳ�ֵ��ѯ������
    number_of_images = length(images); % ��Ҫƴ�ӵ�ͼƬ����
    for n = 1:number_of_images
        XYZ_Q_euclid = obj.cameras(n).H * XYZ_euclid; % ��ʼ�����ֵ��ѯ������
        XYZ_I_euclid = 1000 * XYZ_Q_euclid ./ abs(repmat(XYZ_Q_euclid(3,:),3,1));
        X_I_euclid = XYZ_I_euclid(1,:); Y_I_euclid = XYZ_I_euclid(2,:); Z_I_euclid = XYZ_I_euclid(3,:); 
        [image_row_num,image_col_num,~] = size(images(n).image); % ��ȡͼ��Ĵ�С
        image_midx = (image_row_num-1)/2 + 1; image_midy = (image_col_num-1)/2 + 1; % ����ͼ�����ֵ��
        mask = (X_I_euclid >= (1-image_midx)) & (X_I_euclid <= (image_row_num-image_midx)) & ...
               (Y_I_euclid >= (1-image_midy)) & (Y_I_euclid <= (image_col_num-image_midy)) & ...
               (Z_I_euclid > 0); % ����õ���ͼ���Ӧ���ɰ�
        obj.cameras(n).mask = mask; % ��¼��n��ͼƬ���ɰ�
        obj.cameras(n).query_x = X_I_euclid(mask) + image_midx; % ��¼��n��ͼƬ�Ĳ�ֵ��ѯ�� 
        obj.cameras(n).query_y = Y_I_euclid(mask) + image_midy; % ��¼��n��ͼƬ�Ĳ�ֵ��ѯ��
        
        mask2d = reshape(mask,obj.canvas_row_num,obj.canvas_col_num);
        front_finder = ones(3,3); front_finder(5) = -8;
        front_mat = conv2(double(mask2d),front_finder,'same');
        obj.cameras(n).front = find(front_mat<0); % ����õ���n��ͼƬ�ı߿�����
    end
    
    % �������油��Ȩֵ
    obj = obj.gain_compensation(images);
end

