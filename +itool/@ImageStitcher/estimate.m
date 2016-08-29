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
    
    % ������������Ĳ���K��R
    for n = 1:number_of_images
        if n == 1
            f = 2.5;
            obj.cameras(n).K = diag([f f 1]);
            theda1 = 0; theda2 = 0; theda3 = 0;
            theda = [0 -theda3 theda2; theda3 0 -theda1; -theda2 theda1 0] * pi / 180;
            obj.cameras(n).R = expm(theda);
        end
        
        if n == 2
            obj.cameras(n).K = obj.cameras(1).K;
            image1 = rgb2gray(images(1).image); f1 = obj.cameras(1).K(1,1) * radius_cylind;
            image2 = rgb2gray(images(2).image); f2 = obj.cameras(2).K(1,1) * radius_cylind;
            H = itool.ImageStitcher.estimate_homography2(image1,f1,image2,f2);
            obj.cameras(n).R = inv(H);
            %theda1 = 180; theda2 = 0; theda3 = 180;
            %theda = [0 -theda3 theda2; theda3 0 -theda1; -theda2 theda1 0] * pi / 180;
            %obj.cameras(n).R = expm(theda) * obj.cameras(n).R;
        end
        
%         if n == 3
%             obj.cameras(n).K = obj.cameras(1).K;
%             image1 = rgb2gray(images(1).image); f1 = obj.cameras(1).K(1,1) * radius_cylind;
%             image3 = rgb2gray(images(3).image); f3 = obj.cameras(3).K(1,1) * radius_cylind;
%             H = itool.ImageStitcher.estimate_homography2(image1,f1,image3,f3);
%             obj.cameras(n).R = inv(H);
%         end
    end
    
    % �����������K��R������ÿ��ͼƬ��Ӧ���ɰ�Ͳ�ֵ��ѯ������
    for n = 1:number_of_images
        XYZ_Q_euclid = obj.cameras(n).K * obj.cameras(n).R * XYZ_euclid; % ��ʼ�����ֵ��ѯ������
        XYZ_Q_euclid = radius_cylind * XYZ_Q_euclid ./ abs(repmat(XYZ_Q_euclid(3,:),3,1));
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

