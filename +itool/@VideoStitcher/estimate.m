function obj = estimate(obj, yuvs)
%estimate ����ƴ�Ӳ���
%   yuvs��Я��YUV�ļ���Ϣ�Ľṹ������

    N = length(yuvs); % �õ���Ҫƴ�ӵ���Ƶ·��
    
    yuvs(1).fid = fopen(yuvs(1).filename,'r');
    yuvs(2).fid = fopen(yuvs(2).filename,'r');
    yuvs(3).fid = fopen(yuvs(3).filename,'r');
    
    image1 = itool.read_frame(yuvs(1)); images(1).Y = image1(:,:,1);
    image2 = itool.read_frame(yuvs(2)); images(2).Y = image2(:,:,1);
    image3 = itool.read_frame(yuvs(3)); images(3).Y = image3(:,:,1);
    
    H12 = obj.estimate_homography(images(2).Y,images(1).Y);
    H32 = obj.estimate_homography(images(2).Y,images(3).Y);
    obj.H(:,:,1) = H12;
    obj.H(:,:,2) = eye(3);
    obj.H(:,:,3) = H32;
    
    image1_size = size(images(1).Y);
    image2_size = size(images(2).Y);
    image3_size = size(images(3).Y);
    
    image1_corner = [1 1 1;1 image1_size(2) 1;image1_size(1) 1 1;image1_size(1) image1_size(2) 1]';
    image2_corner = [1 1 1;1 image2_size(2) 1;image2_size(1) 1 1;image2_size(1) image2_size(2) 1]';
    image3_corner = [1 1 1;1 image3_size(2) 1;image3_size(1) 1 1;image3_size(1) image3_size(2) 1]';
    
    image1_c_corner = obj.H(:,:,1) * image1_corner; image1_c_corner = image1_c_corner ./ repmat(image1_c_corner(3,:),3,1);
    image2_c_corner = obj.H(:,:,2) * image2_corner; image2_c_corner = image2_c_corner ./ repmat(image2_c_corner(3,:),3,1);
    image3_c_corner = obj.H(:,:,3) * image3_corner; image3_c_corner = image3_c_corner ./ repmat(image3_c_corner(3,:),3,1);
    
    canvas_corner = cat(2,image1_c_corner,image2_c_corner,image3_c_corner);
    row_min = floor(min(canvas_corner(1,:)));
    row_max =  ceil(max(canvas_corner(1,:)));
    col_min = floor(min(canvas_corner(2,:)));
    col_max =  ceil(max(canvas_corner(2,:)));
    
    obj.canvas_row_num = row_max - row_min + 1; 
    obj.canvas_col_num = col_max - col_min + 1; 
    
    M = [1 0 (-row_min+1);0 1 (-col_min+1);0 0 1];
    obj.H(:,:,1) = M * obj.H(:,:,1); % �õ���1·��Ƶ��ͶӰ�任����
    obj.H(:,:,2) = M * obj.H(:,:,2); % �õ���2·��Ƶ��ͶӰ�任����
    obj.H(:,:,3) = M * obj.H(:,:,3); % �õ���3·��Ƶ��ͶӰ�任����
    
    fclose(yuvs(1).fid);
    fclose(yuvs(2).fid);
    fclose(yuvs(3).fid);
    
    % ����ÿһ·��Ƶ���ɰ�Ͳ�ֵ��ѯ��
    [y_g_c,x_g_c] = meshgrid(1:obj.canvas_col_num,1:obj.canvas_row_num); 
    x_c = reshape(x_g_c,1,[]); % תΪ������
    y_c = reshape(y_g_c,1,[]); % תΪ������
    xy_c = cat(1,x_c,y_c,ones(1,length(x_c))); % �õ�����������
    for n = 1:N
        % ����ÿһ·��Ƶ���ɰ�
        xy_i = obj.H(:,:,n)\xy_c; % ͼ������ϵ�µ�xy���� 
        xy_i = xy_i ./ repmat(xy_i(3,:),3,1); % �õ�����ͶӰ��ͼ������ϵ�µ�����
        x_i = reshape(xy_i(1,:),obj.canvas_row_num,obj.canvas_col_num); 
        y_i = reshape(xy_i(2,:),obj.canvas_row_num,obj.canvas_col_num);
        [image_row_num,image_col_num] = size(images(n).Y);
        image_mask = (x_i >= 1) & (x_i <= image_row_num) & (y_i >= 1) & (y_i <= image_col_num); % �õ��ɰ�
        obj.mask(:,:,n) = image_mask;
        xy_q_c = cat(1,x_g_c(image_mask)',y_g_c(image_mask)',ones(1,sum(sum(image_mask))));  % canvas����ϵ�µĲ�ѯ������
        xy_q_i = obj.H(:,:,n)\xy_q_c; xy_q_i = xy_q_i ./ repmat(xy_q_i(3,:),3,1); % image����ϵ�µĲ�ѯ������
        
        % ����ÿһ·��Ƶ�Ĳ�ֵ��ѯ��
        obj.interp_pos(n).x = xy_q_i(1,:);
        obj.interp_pos(n).y = xy_q_i(2,:);
    end
end

