function obj = estimate(obj, images)
%estimate ����ƴ�Ӳ���
%   images����Ҫ��ƴ�ӵ�ͼƬ����

    N = length(images); % �õ���Ҫƴ�ӵ�ͼƬ����
    
    H12 = obj.estimate_homography(rgb2gray(images(2).image),rgb2gray(images(1).image));
    H32 = obj.estimate_homography(rgb2gray(images(2).image),rgb2gray(images(3).image));
    obj.cameras(1).H = H12;
    obj.cameras(2).H = eye(3);
    obj.cameras(3).H = H32;
    
    image1_size = size(rgb2gray(images(1).image));
    image2_size = size(rgb2gray(images(2).image));
    image3_size = size(rgb2gray(images(3).image));
    
    image1_corner = [1 1 1;1 image1_size(2) 1;image1_size(1) 1 1;image1_size(1) image1_size(2) 1]';
    image2_corner = [1 1 1;1 image2_size(2) 1;image2_size(1) 1 1;image2_size(1) image2_size(2) 1]';
    image3_corner = [1 1 1;1 image3_size(2) 1;image3_size(1) 1 1;image3_size(1) image3_size(2) 1]';
    
    image1_c_corner = obj.cameras(1).H * image1_corner; image1_c_corner = image1_c_corner ./ repmat(image1_c_corner(3,:),3,1);
    image2_c_corner = obj.cameras(2).H * image2_corner; image2_c_corner = image2_c_corner ./ repmat(image2_c_corner(3,:),3,1);
    image3_c_corner = obj.cameras(3).H * image3_corner; image3_c_corner = image3_c_corner ./ repmat(image3_c_corner(3,:),3,1);
    
    canvas_corner = cat(2,image1_c_corner,image2_c_corner,image3_c_corner);
    row_min = floor(min(canvas_corner(1,:)));
    row_max =  ceil(max(canvas_corner(1,:)));
    col_min = floor(min(canvas_corner(2,:)));
    col_max =  ceil(max(canvas_corner(2,:)));
    
    obj.canvas_row_num = row_max - row_min + 1; 
    obj.canvas_col_num = col_max - col_min + 1; 
    
    M = [1 0 (-row_min+1);0 1 (-col_min+1);0 0 1];
    obj.cameras(1).H = M * obj.cameras(1).H; % �õ���1·��Ƶ��ͶӰ�任����
    obj.cameras(2).H = M * obj.cameras(2).H; % �õ���2·��Ƶ��ͶӰ�任����
    obj.cameras(3).H = M * obj.cameras(3).H; % �õ���3·��Ƶ��ͶӰ�任����
    
    % ����ÿһ·��Ƶ���ɰ�Ͳ�ֵ��ѯ��
    [y_g_c,x_g_c] = meshgrid(1:obj.canvas_col_num,1:obj.canvas_row_num); 
    x_c = reshape(x_g_c,1,[]); % תΪ������
    y_c = reshape(y_g_c,1,[]); % תΪ������
    xy_c = cat(1,x_c,y_c,ones(1,length(x_c))); % �õ�����������
    for n = 1:N
        % ����ÿһ·��Ƶ���ɰ�
        xy_i = obj.cameras(n).H\xy_c; % ͼ������ϵ�µ�xy���� 
        xy_i = xy_i ./ repmat(xy_i(3,:),3,1); % �õ�����ͶӰ��ͼ������ϵ�µ�����
        x_i = reshape(xy_i(1,:),obj.canvas_row_num,obj.canvas_col_num); 
        y_i = reshape(xy_i(2,:),obj.canvas_row_num,obj.canvas_col_num);
        [image_row_num,image_col_num] = size(rgb2gray(images(n).image));
        image_mask = (x_i >= 1) & (x_i <= image_row_num) & (y_i >= 1) & (y_i <= image_col_num); % �õ��ɰ�
        obj.cameras(n).mask = image_mask;
        xy_q_c = cat(1,x_g_c(image_mask)',y_g_c(image_mask)',ones(1,sum(sum(image_mask))));  % canvas����ϵ�µĲ�ѯ������
        xy_q_i = obj.cameras(n).H\xy_q_c; xy_q_i = xy_q_i ./ repmat(xy_q_i(3,:),3,1); % image����ϵ�µĲ�ѯ������
        
        % ����ÿһ·��Ƶ�Ĳ�ֵ��ѯ��
        obj.cameras(n).interp_pos.x = xy_q_i(1,:);
        obj.cameras(n).interp_pos.y = xy_q_i(2,:);
    end
end

